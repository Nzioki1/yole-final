#!/usr/bin/env dart
/**
 * Generate Flutter tokens from extracted CSS tokens and design-lock.json
 * Updates design-lock.json with extracted tokens and generates tokens_color.dart
 */

import 'dart:convert';
import 'dart:io';

class TokenGenerator {
  final String tokensJsonPath;
  final String designLockPath;
  final String outputPath;

  TokenGenerator({
    required this.tokensJsonPath,
    required this.designLockPath,
    required this.outputPath,
  });

  Future<void> generate() async {
    print('🔧 Generating Flutter tokens...');

    // Read extracted CSS tokens
    final tokensJson = await _readTokensJson();
    print(
      '📖 Read ${tokensJson['light']?.length ?? 0} light tokens, ${tokensJson['dark']?.length ?? 0} dark tokens',
    );

    // Read design-lock.json
    final designLock = await _readDesignLock();
    print('📖 Read design-lock.json');

    // Update design-lock.json with extracted tokens
    await _updateDesignLock(designLock, tokensJson);
    print('✅ Updated design-lock.json with extracted tokens');

    // Generate Flutter tokens from design-lock.json (single source of truth)
    await _generateFlutterTokens(designLock);
    print('✅ Generated Flutter tokens from design-lock.json');
  }

  Future<Map<String, dynamic>> _readTokensJson() async {
    final file = File(tokensJsonPath);
    if (!await file.exists()) {
      throw Exception('Tokens JSON file not found: $tokensJsonPath');
    }
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _readDesignLock() async {
    final file = File(designLockPath);
    if (!await file.exists()) {
      throw Exception('Design lock file not found: $designLockPath');
    }
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> _updateDesignLock(
    Map<String, dynamic> designLock,
    Map<String, dynamic> tokensJson,
  ) async {
    // Update colors in design-lock.json with extracted tokens
    final tokens = designLock['tokens'] as Map<String, dynamic>;
    final colors = tokens['colors'] as Map<String, dynamic>;

    // Update light colors
    final lightColors = colors['light'] as Map<String, dynamic>;
    final extractedLight = tokensJson['light'] as Map<String, dynamic>? ?? {};
    _updateColorTokens(lightColors, extractedLight);

    // Update dark colors
    final darkColors = colors['dark'] as Map<String, dynamic>;
    final extractedDark = tokensJson['dark'] as Map<String, dynamic>? ?? {};
    _updateColorTokens(darkColors, extractedDark);

    // Write updated design-lock.json
    final file = File(designLockPath);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(designLock),
    );
  }

  void _updateColorTokens(
    Map<String, dynamic> colorTokens,
    Map<String, dynamic> extractedTokens,
  ) {
    // Map CSS variables to Flutter color tokens based on PRD mapping
    final mapping = {
      'primary': 'primary',
      'background': 'background',
      'card': 'surface',
      'foreground': 'onSurface',
      'muted-foreground': 'onSurfaceVariant',
      'border': 'outline',
      'destructive': 'error',
      'success': 'success',
      'primary-gradient-start': 'primaryGradientStart',
      'primary-gradient-end': 'primaryGradientEnd',
    };

    for (final entry in mapping.entries) {
      final cssVar = entry.key;
      final flutterToken = entry.value;

      if (extractedTokens.containsKey(cssVar)) {
        colorTokens[flutterToken] = extractedTokens[cssVar];
      }
    }
  }

  Future<void> _generateFlutterTokens(Map<String, dynamic> designLock) async {
    final tokens = designLock['tokens'] as Map<String, dynamic>;
    final colors = tokens['colors'] as Map<String, dynamic>;
    final lightColors = colors['light'] as Map<String, dynamic>;
    final darkColors = colors['dark'] as Map<String, dynamic>;

    // Read new token structure with fallback to legacy
    final spacing = _getTokenWithFallback(tokens, 'spacing', '_legacy.spacing');
    final radius = _getTokenWithFallback(
      tokens,
      'radius',
      '_legacy.border_radius',
    );
    final elevation = _getTokenWithFallback(
      tokens,
      'elevation',
      'elevationLegacy',
    );
    final typography = _getTokenWithFallback(
      tokens,
      'typography',
      'typographyLegacy',
    );
    final state = tokens['state'] as Map<String, dynamic>? ?? {};
    final components = _getTokenWithFallback(
      tokens,
      'components',
      '_legacy.components',
    );

    // Get design hash for header
    final designHash = designLock['design_hash'] as String?;

    final dartCode = _generateDartCode(
      lightColors,
      darkColors,
      spacing,
      radius,
      elevation,
      typography,
      state,
      components,
      designHash,
    );

    // Ensure output directory exists
    final outputFile = File(outputPath);
    await outputFile.parent.create(recursive: true);

    // Write Flutter tokens file
    await outputFile.writeAsString(dartCode);
  }

  Map<String, dynamic> _getTokenWithFallback(
    Map<String, dynamic> tokens,
    String primaryKey,
    String fallbackKey,
  ) {
    // Try primary key first
    if (tokens.containsKey(primaryKey)) {
      return tokens[primaryKey] as Map<String, dynamic>;
    }

    // Fallback to legacy key
    final legacyKeys = fallbackKey.split('.');
    Map<String, dynamic> current = tokens;
    for (final key in legacyKeys) {
      if (current.containsKey(key)) {
        current = current[key] as Map<String, dynamic>;
      } else {
        print(
          '⚠️  WARNING: No fallback available for $primaryKey (tried $fallbackKey)',
        );
        return {}; // No fallback available
      }
    }
    print(
      '⚠️  WARNING: Using legacy fallback for $primaryKey from $fallbackKey',
    );
    return current;
  }

  String _generateDartCode(
    Map<String, dynamic> lightColors,
    Map<String, dynamic> darkColors,
    Map<String, dynamic> spacing,
    Map<String, dynamic> radius,
    Map<String, dynamic> elevation,
    Map<String, dynamic> typography,
    Map<String, dynamic> state,
    Map<String, dynamic> components,
    String? designHash,
  ) {
    final buffer = StringBuffer();

    // Add the required header
    buffer.writeln('// GENERATED FROM design-lock.json — DO NOT EDIT');
    if (designHash != null) {
      buffer.writeln('// lock sha256: $designHash');
    }
    buffer.writeln('');
    buffer.writeln('import \'package:flutter/material.dart\';');
    buffer.writeln('');
    buffer.writeln('/// Design tokens extracted from design-lock.json');
    buffer.writeln('/// Single source of truth: docs/design-lock.json');
    buffer.writeln('class DesignTokens {');
    buffer.writeln('  const DesignTokens._();');
    buffer.writeln('');

    // Generate light theme colors
    buffer.writeln('  // Light Theme Colors');
    for (final entry in lightColors.entries) {
      final name = entry.key;
      final value = entry.value;
      if (value != 'TBD' && value != null) {
        final colorValue = _convertToFlutterColor(value);
        buffer.writeln(
          '  static const Color light${_capitalize(name)} = $colorValue;',
        );
      }
    }

    buffer.writeln('');

    // Generate dark theme colors
    buffer.writeln('  // Dark Theme Colors');
    for (final entry in darkColors.entries) {
      final name = entry.key;
      final value = entry.value;
      if (value != 'TBD' && value != null) {
        final colorValue = _convertToFlutterColor(value);
        buffer.writeln(
          '  static const Color dark${_capitalize(name)} = $colorValue;',
        );
      }
    }

    buffer.writeln('');

    // Generate color schemes
    buffer.writeln('  /// Light theme color scheme');
    buffer.writeln(
      '  static const ColorScheme lightColorScheme = ColorScheme.light(',
    );
    _writeColorSchemeProperties(buffer, lightColors, 'light');
    buffer.writeln('  );');
    buffer.writeln('');

    buffer.writeln('  /// Dark theme color scheme');
    buffer.writeln(
      '  static const ColorScheme darkColorScheme = ColorScheme.dark(',
    );
    _writeColorSchemeProperties(buffer, darkColors, 'dark');
    buffer.writeln('  );');
    buffer.writeln('');

    // Generate theme extensions
    buffer.writeln('  /// Custom theme extensions');
    buffer.writeln(
      '  static const List<ThemeExtension<dynamic>> extensions = [',
    );
    buffer.writeln('    _SuccessColors(),');
    buffer.writeln('    _GradientColors(),');
    buffer.writeln('  ];');
    buffer.writeln('}');
    buffer.writeln('');

    // Generate theme extensions
    _generateThemeExtensions(buffer, lightColors, darkColors);

    return buffer.toString();
  }

  void _writeColorSchemeProperties(
    StringBuffer buffer,
    Map<String, dynamic> colors,
    String theme,
  ) {
    final mapping = {
      'primary': 'primary',
      'background': 'background',
      'surface': 'surface',
      'onSurface': 'onSurface',
      'onSurfaceVariant': 'onSurfaceVariant',
      'outline': 'outline',
      'error': 'error',
    };

    for (final entry in mapping.entries) {
      final tokenName = entry.key;
      final schemeProperty = entry.value;
      final value = colors[tokenName];

      if (value != 'TBD' && value != null) {
        final colorValue = _convertToFlutterColor(value);
        buffer.writeln('    $schemeProperty: $colorValue,');
      }
    }
  }

  void _generateThemeExtensions(
    StringBuffer buffer,
    Map<String, dynamic> lightColors,
    Map<String, dynamic> darkColors,
  ) {
    // Success colors extension
    buffer.writeln(
      'class _SuccessColors extends ThemeExtension<_SuccessColors> {',
    );
    buffer.writeln('  const _SuccessColors({');
    buffer.writeln('    required this.success,');
    buffer.writeln('    required this.onSuccess,');
    buffer.writeln('  });');
    buffer.writeln('');
    buffer.writeln('  final Color success;');
    buffer.writeln('  final Color onSuccess;');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  _SuccessColors copyWith({');
    buffer.writeln('    Color? success,');
    buffer.writeln('    Color? onSuccess,');
    buffer.writeln('  }) {');
    buffer.writeln('    return _SuccessColors(');
    buffer.writeln('      success: success ?? this.success,');
    buffer.writeln('      onSuccess: onSuccess ?? this.onSuccess,');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln(
      '  _SuccessColors lerp(ThemeExtension<_SuccessColors>? other, double t) {',
    );
    buffer.writeln('    if (other is! _SuccessColors) return this;');
    buffer.writeln('    return _SuccessColors(');
    buffer.writeln('      success: Color.lerp(success, other.success, t)!,');
    buffer.writeln(
      '      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,',
    );
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');

    // Gradient colors extension
    buffer.writeln(
      'class _GradientColors extends ThemeExtension<_GradientColors> {',
    );
    buffer.writeln('  const _GradientColors({');
    buffer.writeln('    required this.primaryGradientStart,');
    buffer.writeln('    required this.primaryGradientEnd,');
    buffer.writeln('  });');
    buffer.writeln('');
    buffer.writeln('  final Color primaryGradientStart;');
    buffer.writeln('  final Color primaryGradientEnd;');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  _GradientColors copyWith({');
    buffer.writeln('    Color? primaryGradientStart,');
    buffer.writeln('    Color? primaryGradientEnd,');
    buffer.writeln('  }) {');
    buffer.writeln('    return _GradientColors(');
    buffer.writeln(
      '      primaryGradientStart: primaryGradientStart ?? this.primaryGradientStart,',
    );
    buffer.writeln(
      '      primaryGradientEnd: primaryGradientEnd ?? this.primaryGradientEnd,',
    );
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln(
      '  _GradientColors lerp(ThemeExtension<_GradientColors>? other, double t) {',
    );
    buffer.writeln('    if (other is! _GradientColors) return this;');
    buffer.writeln('    return _GradientColors(');
    buffer.writeln(
      '      primaryGradientStart: Color.lerp(primaryGradientStart, other.primaryGradientStart, t)!,',
    );
    buffer.writeln(
      '      primaryGradientEnd: Color.lerp(primaryGradientEnd, other.primaryGradientEnd, t)!,',
    );
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
  }

  String _convertToFlutterColor(String value) {
    // Handle hex colors
    if (value.startsWith('#')) {
      return 'Color(0xFF${value.substring(1)})';
    }

    // Handle rgba colors
    if (value.startsWith('rgba(')) {
      final rgbaMatch = RegExp(
        r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)',
      ).firstMatch(value);
      if (rgbaMatch != null) {
        final r = int.parse(rgbaMatch.group(1)!);
        final g = int.parse(rgbaMatch.group(2)!);
        final b = int.parse(rgbaMatch.group(3)!);
        final a = (double.parse(rgbaMatch.group(4)!) * 255).round();
        return 'Color.fromARGB($a, $r, $g, $b)';
      }
    }

    // Handle oklch colors (convert to approximate hex for now)
    if (value.startsWith('oklch(')) {
      // For now, return a placeholder - in production you'd want proper OKLCH conversion
      return 'Color(0xFF3B82F6)'; // Default blue
    }

    // Fallback
    return 'Color(0xFF000000)';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

Future<void> main(List<String> args) async {
  if (args.length < 1) {
    print('Usage: dart run tools/gen_flutter_tokens.dart <tokens-json>');
    print('Example: dart run tools/gen_flutter_tokens.dart tokens.json');
    exit(1);
  }

  final tokensJsonPath = args[0];
  final designLockPath = 'docs/design-lock.json';
  final outputPath = 'lib/core/theme/tokens_color.dart';

  try {
    final generator = TokenGenerator(
      tokensJsonPath: tokensJsonPath,
      designLockPath: designLockPath,
      outputPath: outputPath,
    );

    await generator.generate();
    print('🎉 Flutter tokens generated successfully!');
  } catch (e) {
    print('❌ Error generating Flutter tokens: $e');
    exit(1);
  }
}
