#!/usr/bin/env node

/**
 * Extract CSS variables from design bundle globals.css
 * Reads :root (light) and .dark (dark) variables and outputs tokens.json
 */

const fs = require('fs');
const path = require('path');

function extractCSSVariables(cssContent) {
  const tokens = {
    light: {},
    dark: {}
  };

  // Extract :root variables (light mode)
  const rootMatch = cssContent.match(/:root\s*\{([^}]+)\}/);
  if (rootMatch) {
    const rootContent = rootMatch[1];
    const lightVars = extractVariablesFromBlock(rootContent);
    tokens.light = lightVars;
  }

  // Extract .dark variables (dark mode)
  const darkMatch = cssContent.match(/\.dark\s*\{([^}]+)\}/);
  if (darkMatch) {
    const darkContent = darkMatch[1];
    const darkVars = extractVariablesFromBlock(darkContent);
    tokens.dark = darkVars;
  }

  return tokens;
}

function extractVariablesFromBlock(blockContent) {
  const variables = {};
  
  // Match CSS custom properties: --name: value;
  const varRegex = /--([^:]+):\s*([^;]+);/g;
  let match;
  
  while ((match = varRegex.exec(blockContent)) !== null) {
    const name = match[1].trim();
    const value = match[2].trim();
    variables[name] = value;
  }
  
  return variables;
}

function main() {
  const args = process.argv.slice(2);
  
  if (args.length < 2) {
    console.error('Usage: node extract_css_tokens.js <css-file> <output-json>');
    console.error('Example: node extract_css_tokens.js "design/Yole Final/src/styles/globals.css" tokens.json');
    process.exit(1);
  }
  
  const cssFilePath = args[0];
  const outputPath = args[1];
  
  // Check if CSS file exists
  if (!fs.existsSync(cssFilePath)) {
    console.error(`❌ CSS file not found: ${cssFilePath}`);
    console.error('Available paths in design bundle:');
    
    // Try to find CSS files in design directory
    const designDir = 'design';
    if (fs.existsSync(designDir)) {
      try {
        const files = fs.readdirSync(designDir, { recursive: true });
        const cssFiles = files.filter(file => file.endsWith('.css'));
        cssFiles.forEach(file => console.error(`  - ${designDir}/${file}`));
      } catch (err) {
        console.error('  Could not read design directory');
      }
    }
    
    process.exit(1);
  }
  
  try {
    console.log(`📖 Reading CSS file: ${cssFilePath}`);
    const cssContent = fs.readFileSync(cssFilePath, 'utf8');
    
    console.log('🔍 Extracting CSS variables...');
    const tokens = extractCSSVariables(cssContent);
    
    // Count extracted variables
    const lightCount = Object.keys(tokens.light).length;
    const darkCount = Object.keys(tokens.dark).length;
    
    console.log(`✅ Extracted ${lightCount} light mode variables`);
    console.log(`✅ Extracted ${darkCount} dark mode variables`);
    
    // Write tokens to output file
    fs.writeFileSync(outputPath, JSON.stringify(tokens, null, 2));
    console.log(`💾 Saved tokens to: ${outputPath}`);
    
    // Show sample of extracted tokens
    console.log('\n📋 Sample extracted tokens:');
    const sampleLight = Object.keys(tokens.light).slice(0, 5);
    const sampleDark = Object.keys(tokens.dark).slice(0, 5);
    
    console.log('Light mode:', sampleLight.join(', '));
    console.log('Dark mode:', sampleDark.join(', '));
    
  } catch (error) {
    console.error(`❌ Error processing CSS file: ${error.message}`);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { extractCSSVariables };
