#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const OUT = [];
const repoRoot = process.cwd();

function p(...segs){ return path.join(repoRoot, ...segs); }
function exists(fp){ try { fs.accessSync(fp); return true; } catch { return false; } }
function read(fp){ try { return fs.readFileSync(fp, 'utf8'); } catch { return ''; } }
function sha256File(fp){
  try {
    const buf = fs.readFileSync(fp);
    return crypto.createHash('sha256').update(buf).digest('hex');
  } catch { return null; }
}
function mtime(fp){
  try { return fs.statSync(fp).mtimeMs; } catch { return 0; }
}
function walk(dir, acc=[], ignore=['.git','build','.dart_tool','ios/Pods','android/.gradle','node_modules']){
  if(!exists(dir)) return acc;
  for(const entry of fs.readdirSync(dir)){
    const full = path.join(dir, entry);
    const rel  = path.relative(repoRoot, full);
    const st = fs.statSync(full);
    if (ignore.some(x => rel.split(path.sep).includes(x))) continue;
    if (st.isDirectory()) walk(full, acc, ignore);
    else acc.push(full);
  }
  return acc;
}
function grepFiles(globRoots, regex, exclude=[]) {
  const files = [].concat(...globRoots.map(r => walk(p(r))))
    .filter(f => exclude.every(ex => !f.includes(ex)));
  const hits = [];
  for (const f of files) {
    const txt = read(f);
    if (regex.test(txt)) hits.push(f);
  }
  return [...new Set(hits)].sort();
}
function frontMatterValue(md, key){
  const m = md.match(/^---\s*([\s\S]*?)\s*---/);
  if(!m) return null;
  const block = m[1];
  const rx = new RegExp('^'+key+':\\s*"?([^"\\n]+)"?\\s*$','m');
  const mm = block.match(rx);
  return mm ? mm[1].trim() : null;
}
function add(line){ OUT.push(line); }
function pass(line){ add(`- ✅ ${line}`); }
function fail(line){ add(`- ❌ ${line}`); }
function warn(line){ add(`- ⚠️ ${line}`); }

(function main(){
  add('# Yole Repo Audit\n');

  // 1) Design bundle present + SHA pinned in PRD & lock
  const designZip = p('design','Yole Final.zip');
  const prdPath = p('docs','PRD.md');
  const lockPath= p('docs','design-lock.json');

  const hasZip = exists(designZip);
  const hasPrd = exists(prdPath);
  const hasLock= exists(lockPath);

  let prdSha = null, lockSha = null, zipSha = null;
  if (hasPrd) prdSha = frontMatterValue(read(prdPath), 'design_sha256');
  if (hasLock) {
    try { lockSha = JSON.parse(read(lockPath)).design_hash || null; } catch {}
  }
  if (hasZip) zipSha = sha256File(designZip);

  if (hasZip && hasPrd && hasLock && zipSha && prdSha && lockSha && prdSha.toLowerCase()===zipSha && lockSha.toLowerCase()===zipSha) {
    pass('Design bundle present and SHA-256 matches in PRD.md and design-lock.json.');
  } else {
    fail('Design bundle SHA pin mismatch or missing.');
    add(`  • design zip present: ${hasZip? 'yes':'no'}`);
    add(`  • PRD.md present: ${hasPrd? 'yes':'no'} | design_sha256: ${prdSha||'N/A'}`);
    add(`  • design-lock.json present: ${hasLock? 'yes':'no'} | design_hash: ${lockSha||'N/A'}`);
    add(`  • computed zip sha256: ${zipSha||'N/A'}`);
    add('  → Fix: compute SHA256 of design/Yole Final.zip and update PRD.md front-matter design_sha256 and design-lock.json.design_hash to match.');
  }

  add('');

  // 2) tokens_color.dart generated from lock (heuristics)
  const tokensDart = p('lib','core','theme','tokens_color.dart');
  if (!exists(tokensDart)) {
    fail('tokens_color.dart not found.');
    add('  → Fix: run token extractor/codegen to emit lib/core/theme/tokens_color.dart from docs/design-lock.json.');
  } else {
    const genMarker = /GENERATED\s+FROM\s+design-lock\.json/i.test(read(tokensDart));
    const newerThanLock = mtime(tokensDart) >= mtime(lockPath);
    if (genMarker || newerThanLock) {
      pass('tokens_color.dart appears generated from design-lock.json (marker or newer mtime).');
      if (!genMarker) warn('Consider adding a header comment: "// GENERATED FROM design-lock.json — DO NOT EDIT".');
    } else {
      fail('tokens_color.dart is older than design-lock.json or missing generation marker.');
      add('  → Fix: regenerate tokens_color.dart from design-lock.json.');
    }
  }

  add('');

  // 3) No hardcoded Colors/TextStyle/EdgeInsets in screens (token-aware)
  const offenders = [];
  const files = walk(p('lib'))
    .filter(f => f.includes(`${path.sep}features${path.sep}`) || f.includes(`${path.sep}screens${path.sep}`))
    .filter(f => !f.includes(`${path.sep}core${path.sep}theme${path.sep}`));

  function hasRawColors(txt){
    // Check for raw Color(...) calls, but allow design token constants
    const colorMatches = txt.match(/\bColor\s*\(/g);
    if (!colorMatches) return /\bColors\./.test(txt);
    
    // Allow design token constants that reference design-lock.json
    const lines = txt.split('\n');
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (/\bColor\s*\(/.test(line)) {
        // Check if this line is a design token constant
        const isDesignToken = /\/\/.*design.*token|tokens\.|design-lock\.json/i.test(line) ||
                             /const.*Color.*=.*Color\(.*\);?\s*$/.test(line.trim());
        if (!isDesignToken) {
          return true; // Found a raw Color(...) that's not a design token
        }
      }
    }
    return /\bColors\./.test(txt);
  }
  function argsUseTokens(args){
    return /spacingX|SpacingX|\bs\.|SpacingTokens\./.test(args) || /colorScheme\./.test(args);
  }
  for (const f of files) {
    const txt = read(f);
    let flagged = false;

    // Raw colors anywhere in screens — still forbidden
    if (hasRawColors(txt)) flagged = true;

    // Raw TextStyle(...) calls — should use textTheme
    if (/\bTextStyle\s*\(/.test(txt)) flagged = true;

    // EdgeInsets.* — flag only when numeric literals are used and NOT tokenized
    const ei = /\bEdgeInsets\.(only|symmetric|fromLTRB|all)\s*\(([^)]*)\)/g;
    let m;
    while ((m = ei.exec(txt)) !== null) {
      const args = m[2];
      const numeric = /\b\d+(\.\d+)?\b/.test(args);
      if (numeric && !argsUseTokens(args)) { flagged = true; break; }
    }

    // BorderSide / OutlineInputBorder — allow if color comes from colorScheme and width is 1 or from tokens
    const borderSide = /\bBorderSide\s*\(\s*color\s*:\s*([^,)\n]+).*?\)/gs;
    while ((m = borderSide.exec(txt)) !== null) {
      const colorExpr = m[1];
      const usesScheme = /colorScheme\./.test(colorExpr);
      const hasRawColor = /Color\s*\(|Colors\./.test(colorExpr);
      const widthMatch = m[0].match(/width\s*:\s*([0-9.]+)/);
      const widthIsTokenOrOne = !widthMatch || widthMatch[1] === '1';
      if ((hasRawColor || !usesScheme) && !widthIsTokenOrOne) { flagged = true; break; }
    }
    const outline = /\bOutlineInputBorder\s*\(([^)]*)\)/gs;
    while ((m = outline.exec(txt)) !== null) {
      const args = m[1];
      const sideMatch = args.match(/borderSide\s*:\s*BorderSide\s*\(([^)]*)\)/s);
      if (sideMatch) {
        const sideArgs = sideMatch[1];
        const usesScheme = /colorScheme\./.test(sideArgs);
        const hasRawColor = /Color\s*\(|Colors\./.test(sideArgs);
        const widthMatch = sideArgs.match(/width\s*:\s*([0-9.]+)/);
        const widthIsTokenOrOne = !widthMatch || widthMatch[1] === '1';
        if ((hasRawColor || !usesScheme) && !widthIsTokenOrOne) { flagged = true; break; }
      }
    }

    if (flagged) offenders.push(f);
  }

  if (offenders.length === 0) {
    pass('No hardcoded styling (token-aware) found under lib/features or lib/screens.');
  } else {
    fail('Hardcoded styling detected under lib/features or lib-screens.');
    offenders.slice(0,25).forEach(f => add(`  • ${path.relative(repoRoot,f)}`));
    add('  → Fix: route colors via Theme.colorScheme, typography via textTheme, and paddings via Spacing tokens. Tokenized EdgeInsets/Border/OutlineInputBorder are allowed.');
  }

  add('');

  // 4) Dark & Light parity visually OK — manual, but detect theme wiring
  const appPath = p('lib','app.dart');
  const wired = exists(appPath) && /darkTheme:|ThemeMode\.system/.test(read(appPath));
  if (wired) {
    warn('Dark/Light theming is wired (theme/darkTheme/ThemeMode.system). Manual visual parity check needed.');
  } else {
    fail('Dark/Light theming not clearly wired (missing theme/darkTheme/ThemeMode.system in lib/app.dart).');
    add('  → Fix: wire ThemeData.light()/dark() and ThemeMode.system per PRD.');
  }

  add('');

  // 5) Send flow E2E (Pesapal) — manual; quick presence checks
  const pesapalRepo = p('lib','data','repos','pesapal_repo.dart');
  const payWebView  = p('lib','features','send','send_pay_webview_screen.dart');
  if (exists(pesapalRepo) && exists(payWebView)) {
    warn('Pesapal files present. Run a manual E2E: Auth → SubmitOrder → Redirect → Callback/IPN → GetStatus.');
  } else {
    fail('Pesapal integration files missing.');
    add('  → Fix: add lib/data/repos/pesapal_repo.dart and send_pay_webview_screen.dart per PRD.');
  }

  add('');

  // 6) Email verification + KYC gate — manual; presence check
  const verifyScreen = p('lib','features','auth','verify_email_screen.dart');
  const kycPhone     = p('lib','features','kyc','kyc_phone_screen.dart');
  const kycOtp       = p('lib','features','kyc','kyc_otp_screen.dart');
  if (exists(verifyScreen) && (exists(kycPhone) || exists(kycOtp))) {
    warn('Email verify + KYC screens present. Manually confirm the Confirm & Send button stays disabled until both are complete.');
  } else {
    fail('Email verification and/or KYC screens not found.');
    add('  → Fix: implement verify_email_screen.dart and KYC flow screens per PRD.');
  }

  add('');

  // 7) M-Pesa caps UI blocks — heuristic (banner/state files)
  const capState = p('lib','features','send','cap_limit_state.dart');
  const capBanner= p('lib','widgets','cap_limit_banner.dart');
  if (exists(capState) && exists(capBanner)) {
    pass('M-Pesa caps UI files found (state + banner). Verify on Amount/Review screens.');
  } else {
    fail('M-Pesa caps UI not detected.');
    add('  → Fix: add cap_limit_state.dart and cap_limit_banner.dart and wire into Amount/Review screens.');
  }

  add('');

  // 8) Favorites server-synced; repeat works — heuristic presence
  const favRepo = p('lib','data','repos','favorites_repo.dart');
  const homeScr = p('lib','features','home','home_screen.dart');
  if (exists(favRepo) && exists(homeScr)) {
    warn('Favorites repo & Home screen present. Manually test server sync and repeat send.');
  } else {
    fail('Favorites or Home implementation missing.');
    add('  → Fix: add favorites_repo.dart and ensure Home shows favorites & repeat actions.');
  }

  add('');

  // 9) PRD version bumped; CHANGELOG updated
  const prdVer = hasPrd ? frontMatterValue(read(prdPath), 'prd_version') : null;
  const hasChangelog = exists(p('docs','CHANGELOG.md'));
  if (prdVer && hasChangelog) {
    pass(`PRD present (prd_version: ${prdVer}) and CHANGELOG.md exists. Ensure version bump for this change.`);
  } else {
    fail('PRD version and/or CHANGELOG missing.');
    add(`  • PRD present: ${hasPrd? 'yes':'no'} | prd_version: ${prdVer||'N/A'}`);
    add(`  • CHANGELOG.md present: ${hasChangelog? 'yes':'no'}`);
    add('  → Fix: add /docs/CHANGELOG.md and ensure PRD front-matter has prd_version bumped.');
  }

  add('');

  // 10) CI "PRD Guard" present
  const ciGuard = p('.github','workflows','prd-guard.yml');
  if (exists(ciGuard)) pass('CI workflow present: .github/workflows/prd-guard.yml');
  else { fail('CI workflow missing: .github/workflows/prd-guard.yml'); add('  → Fix: add the PRD Guard workflow from our build plan.'); }

  // Print report
  console.log(OUT.join('\n'));
})();
