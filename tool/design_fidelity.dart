// Minimal, pragmatic Design ⇄ PRD ⇄ Code auditor.
// Compares /design assets, PRD screens/components, and code files.
// Writes docs/DESIGN_FIDELITY_REPORT.md and exits non-zero if below threshold.

import 'dart:convert';
import 'dart:io';

final repoRoot = Directory.current.path;

void main(List<String> args) async {
  final argMap = _parseArgs(args);
  final threshold = double.tryParse(argMap['--threshold'] ?? '0.95') ?? 0.95;

  final designDir = Directory('design');
  final prdFile = File('docs/PRD.md');
  final codeDir = Directory('lib');

  if (!designDir.existsSync()) _bail('Missing /design folder');
  if (!prdFile.existsSync()) _bail('Missing docs/PRD.md');
  if (!codeDir.existsSync()) _bail('Missing /lib folder');

  // 1) Discover design assets (screens/components by filename)
  final designImages = _listFiles(
    designDir,
    exts: {'.png', '.jpg', '.jpeg', '.svg'},
  );
  final designTokens = _findFirst(
    designDir,
    names: {'tokens.json', 'design-tokens.json'},
  );

  // 2) Parse PRD for screen/component names (very simple heuristics: Markdown lists & headings)
  final prd = prdFile.readAsStringSync();
  final prdScreens = _extractMdItems(
    prd,
    patterns: [
      RegExp(r'#+\s*Screens', caseSensitive: false),
      RegExp(r'-\s+(.+)'),
    ],
  );
  final prdComponents = _extractMdItems(
    prd,
    patterns: [
      RegExp(r'#+\s*Components', caseSensitive: false),
      RegExp(r'-\s+(.+)'),
    ],
  );
  final prdTokens = _extractMdItems(
    prd,
    patterns: [
      RegExp(r'#+\s*(Tokens|Design Tokens)', caseSensitive: false),
      RegExp(r'-\s+(.+)'),
    ],
  );

  // 3) Inspect code tree for screens/components/tokens
  final codeScreens = _listFiles(
    Directory('lib/features'),
    exts: {'.dart'},
  ).where((p) => p.contains('/screens/')).map(_basenameNoExt).toSet();
  final codeComponents = _listFiles(
    Directory('lib/ui/components'),
    exts: {'.dart'},
  ).map(_basenameNoExt).toSet();
  final codeTokenFiles = {
    ..._maybe('lib/design/tokens.dart'),
    ..._maybe('lib/design/typography.dart'),
    ..._maybe('lib/design/theme.dart'),
    ..._maybe('lib/design/color_utils.dart'),
  };

  // Normalize design names to slugs
  final designScreens = designImages
      .where(
        (p) =>
            p.contains(RegExp(r'/screens?/|/frames?/', caseSensitive: false)),
      )
      .map(_basenameNoExt)
      .map(_slug)
      .toSet();
  final designComponents = designImages
      .where((p) => p.contains(RegExp(r'/components?/', caseSensitive: false)))
      .map(_basenameNoExt)
      .map(_slug)
      .toSet();

  final prdScreensSet = prdScreens.map(_slug).toSet();
  final prdCompsSet = prdComponents.map(_slug).toSet();

  // 4) Presence matrices
  Map<String, Map<String, bool>> screenMatrix = {};
  for (final name in {
    ...designScreens,
    ...prdScreensSet,
    ...codeScreens.map(_slug),
  }) {
    screenMatrix[name] = {
      'design': designScreens.contains(name),
      'prd': prdScreensSet.contains(name),
      'code': codeScreens.map(_slug).contains(name),
    };
  }
  Map<String, Map<String, bool>> compMatrix = {};
  for (final name in {
    ...designComponents,
    ...prdCompsSet,
    ...codeComponents.map(_slug),
  }) {
    compMatrix[name] = {
      'design': designComponents.contains(name),
      'prd': prdCompsSet.contains(name),
      'code': codeComponents.map(_slug).contains(name),
    };
  }

  // 5) Token rough checks
  final tokensDesign = (designTokens != null && File(designTokens).existsSync())
      ? jsonDecode(File(designTokens).readAsStringSync())
      : {};
  final tokenDesignCount = tokensDesign is Map ? tokensDesign.length : 0;
  final tokenCodeOk = codeTokenFiles.isNotEmpty;

  // 6) Compute alignment (simple ratio: items in all three / items in union)
  double _alignment(Map<String, Map<String, bool>> m) {
    final total = m.length;
    if (total == 0) return 1.0;
    final inAll = m.values
        .where(
          (v) => v['design'] == true && v['prd'] == true && v['code'] == true,
        )
        .length;
    return inAll / total;
  }

  final screensAlign = _alignment(screenMatrix);
  final componentsAlign = _alignment(compMatrix);
  // tokens: rough 1.0 if code token files exist; degrade if design has many tokens but no code tokens
  final tokensAlign = tokenCodeOk ? 1.0 : (tokenDesignCount == 0 ? 1.0 : 0.0);

  final overall =
      [
        if (screenMatrix.isNotEmpty) screensAlign,
        if (compMatrix.isNotEmpty) componentsAlign,
        tokensAlign,
      ].fold<double>(0, (a, b) => a + b) /
      3.0;

  // 7) Write report
  final report = StringBuffer()
    ..writeln('# DESIGN FIDELITY REPORT')
    ..writeln()
    ..writeln(
      '**Overall alignment:** ${(overall * 100).toStringAsFixed(1)}%  '
      '(Screens: ${(screensAlign * 100).toStringAsFixed(1)}% | '
      'Components: ${(componentsAlign * 100).toStringAsFixed(1)}% | '
      'Tokens: ${(tokensAlign * 100).toStringAsFixed(1)}%)',
    )
    ..writeln()
    ..writeln('## Screens Matrix')
    ..writeln('| Screen | Design | PRD | Code | Action |')
    ..writeln('|---|:--:|:--:|:--:|---|');
  for (final e
      in screenMatrix.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key))) {
    final n = e.key, v = e.value;
    final action = (v['design']! && v['prd']! && v['code']!)
        ? '—'
        : (!v['design']!
              ? 'Add to Figma'
              : !v['prd']!
              ? 'Doc in PRD'
              : 'Implement in code');
    report.writeln(
      '| $n | ${_t(v['design'])} | ${_t(v['prd'])} | ${_t(v['code'])} | $action |',
    );
  }
  report
    ..writeln()
    ..writeln('## Components Matrix')
    ..writeln('| Component | Design | PRD | Code | Action |')
    ..writeln('|---|:--:|:--:|:--:|---|');
  for (final e
      in compMatrix.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final n = e.key, v = e.value;
    final action = (v['design']! && v['prd']! && v['code']!)
        ? '—'
        : (!v['design']!
              ? 'Add to Figma'
              : !v['prd']!
              ? 'Doc in PRD'
              : 'Implement in code');
    report.writeln(
      '| $n | ${_t(v['design'])} | ${_t(v['prd'])} | ${_t(v['code'])} | $action |',
    );
  }
  report
    ..writeln()
    ..writeln('## Tokens')
    ..writeln('- Design tokens file: ${designTokens ?? "not found"}')
    ..writeln(
      '- Token files in code: ${codeTokenFiles.isEmpty ? "missing" : codeTokenFiles.join(", ")}',
    )
    ..writeln(
      '- Token alignment (rough): ${(tokensAlign * 100).toStringAsFixed(1)}%',
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln('- Screens total: ${screenMatrix.length}')
    ..writeln('- Components total: ${compMatrix.length}')
    ..writeln('- Action: Fix rows not in **all three** and re-run this audit.');

  Directory('docs').createSync(recursive: true);
  File('docs/DESIGN_FIDELITY_REPORT.md').writeAsStringSync(report.toString());

  // 8) Exit code on threshold
  stdout.writeln(
    'Overall alignment = ${(overall * 100).toStringAsFixed(1)}%  (threshold ${(threshold * 100).toStringAsFixed(0)}%)',
  );
  stdout.writeln('Report written to docs/DESIGN_FIDELITY_REPORT.md');
  if (overall + 1e-9 < threshold) {
    stderr.writeln(
      'Design fidelity below threshold. Please address mismatches.',
    );
    exit(1);
  }
}

// Helpers
List<String> _listFiles(Directory dir, {required Set<String> exts}) {
  if (!dir.existsSync()) return [];
  return dir
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((f) => exts.contains(_ext(f.path)))
      .map((f) => f.path)
      .toList();
}

String? _findFirst(Directory dir, {required Set<String> names}) {
  for (final e in dir.listSync(recursive: true, followLinks: false)) {
    if (e is File && names.contains(_basename(e.path))) return e.path;
  }
  return null;
}

Iterable<String> _maybe(String path) =>
    File(path).existsSync() ? [path] : const [];

String _basename(String p) => p.split(Platform.pathSeparator).last;
String _ext(String p) {
  final b = _basename(p);
  final i = b.lastIndexOf('.');
  return i == -1 ? '' : b.substring(i).toLowerCase();
}

String _basenameNoExt(String p) {
  final b = _basename(p);
  final i = b.lastIndexOf('.');
  return i == -1 ? b : b.substring(0, i);
}

String _slug(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '')
    .trim();

String _t(bool? v) => v == true ? '✅' : '—';

Map<String, String> _parseArgs(List<String> args) {
  final m = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a.startsWith('--')) {
      final n = a;
      final v = (i + 1 < args.length && !args[i + 1].startsWith('--'))
          ? args[++i]
          : 'true';
      m[n] = v;
    }
  }
  return m;
}

void _bail(String msg) {
  stderr.writeln('ERROR: $msg');
  exit(1);
}

List<String> _extractMdItems(String content, {required List<RegExp> patterns}) {
  final lines = content.split('\n');
  final items = <String>[];
  bool inSection = false;

  for (final line in lines) {
    // Check if we're entering a relevant section
    if (patterns[0].hasMatch(line)) {
      inSection = true;
      continue;
    }

    // If we're in a relevant section, extract list items
    if (inSection && patterns[1].hasMatch(line)) {
      final match = patterns[1].firstMatch(line);
      if (match != null && match.groupCount > 0) {
        items.add(match.group(1)!.trim());
      }
    }

    // Stop if we hit another major heading
    if (inSection && line.startsWith('#') && !patterns[0].hasMatch(line)) {
      inSection = false;
    }
  }

  return items;
}
