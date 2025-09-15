# Design System - Yole Flutter App

This directory contains the centralized design system for the Yole Flutter application, including design tokens, typography, themes, and color utilities.

## 📁 **File Structure**

```
lib/design/
├── tokens.dart          # Design tokens (colors, spacing, radius, etc.)
├── typography.dart      # Typography system and text styles
├── theme.dart           # Complete theme system (light/dark)
├── color_utils.dart     # Color utilities and OKLCH support
└── README.md           # This file
```

## 🎨 **Design Tokens**

### **Colors**
- **Primary Colors:** Primary, onPrimary, primaryContainer, onPrimaryContainer
- **Surface Colors:** Surface, onSurface, surfaceVariant, onSurfaceVariant
- **Background Colors:** Background, onBackground
- **Semantic Colors:** Success, warning, error, info with variants
- **Sidebar Colors:** sidebarBg, sidebarActive, sidebarInactive, sidebarHover
- **Chart Palette:** 5 colors for data visualization
- **Interactive Colors:** Ring, switch thumb/track colors

### **Spacing Scale**
```dart
spacingXs = 4.0    // Extra small
spacingSm = 8.0    // Small
spacingMd = 12.0   // Medium
spacingLg = 16.0   // Large
spacingXl = 20.0   // Extra large
spacing2xl = 24.0  // 2X large
spacing3xl = 32.0  // 3X large
```

### **Border Radius**
```dart
radiusSm = 8.0     // Small radius
radiusMd = 12.0    // Medium radius
radiusLg = 16.0    // Large radius
radiusPill = 999.0 // Pill radius
```

### **Typography**
- **Font Family:** Inter (with Roboto fallback)
- **Font Weights:** Regular (400), Medium (500), SemiBold (600), Bold (700)
- **Font Sizes:** 12px to 36px scale
- **Line Heights:** Tight (1.2), Normal (1.4), Relaxed (1.6), Loose (1.8)

## 🌙 **Theme System**

### **Light Theme**
- Clean, modern design with high contrast
- Primary blue (#3B82F6) with white backgrounds
- Subtle shadows and borders

### **Dark Theme**
- Dark backgrounds (#19173D) with light text
- Adjusted colors for better contrast
- Consistent with light theme structure

### **Theme Extensions**
- **Sidebar Colors:** Custom sidebar theming
- **Chart Colors:** Data visualization palette
- **Interactive Colors:** Form element colors
- **Spacing Extension:** Consistent spacing values
- **Radius Extension:** Border radius values
- **Animation Extension:** Duration and curve values

## 🎯 **Usage Guidelines**

### **✅ Do's**
- Use design tokens from `DesignTokens` class
- Use typography styles from `AppTypography` class
- Use theme extensions for custom colors
- Test both light and dark themes
- Use OKLCH colors for better color consistency

### **❌ Don'ts**
- Don't hardcode colors (use `Color(0x...)`)
- Don't hardcode text styles (use `TextStyle(...)`)
- Don't hardcode spacing (use `EdgeInsets.all(...)`)
- Don't use colors outside the design system
- Don't create custom themes without approval

## 🔧 **Implementation Examples**

### **Using Design Tokens**
```dart
import 'package:flutter/material.dart';
import '../design/tokens.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: DesignTokens.spacingLgAll,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: DesignTokens.radiusMdAll,
      ),
      child: Text(
        'Hello World',
        style: AppTypography.bodyMedium,
      ),
    );
  }
}
```

### **Using Typography**
```dart
import '../design/typography.dart';

Text('Heading', style: AppTypography.h1),
Text('Body text', style: AppTypography.bodyMedium),
Text('Caption', style: AppTypography.caption),
```

### **Using Theme Extensions**
```dart
final theme = Theme.of(context);
final sidebarColors = theme.sidebarColors;
final spacing = theme.spacing;
final radius = theme.radius;

Container(
  padding: EdgeInsets.all(spacing.lg),
  decoration: BoxDecoration(
    color: sidebarColors.backgroundColor,
    borderRadius: BorderRadius.circular(radius.md),
  ),
)
```

### **Using OKLCH Colors**
```dart
import '../design/color_utils.dart';

final oklchColor = ColorUtils.oklch(0.7, 0.15, 250); // Lightness, Chroma, Hue
```

## 🧪 **Testing**

### **Golden Tests**
The design system includes comprehensive golden tests to ensure visual consistency:

```bash
# Run theme gallery golden tests
flutter test test/goldens/screens/theme_gallery_golden_test.dart

# Update golden baselines
flutter test --update-goldens test/goldens/screens/theme_gallery_golden_test.dart
```

### **Theme Gallery**
The theme gallery showcases all design system components:
- Typography styles
- Button variants
- Chip types
- Form elements
- Cards and surfaces
- Interactive elements

## 🔄 **Migration Guide**

### **From Old Theme System**
1. Replace `YoleTheme` imports with `AppTheme`
2. Replace `YoleColorSchemes` with `DesignTokens`
3. Replace `YoleThemeExtensions` with theme extensions
4. Update widget imports to use new design system

### **Before (Old System)**
```dart
import '../core/theme/app_theme.dart';
import '../core/theme/theme_extensions.dart';

final theme = YoleTheme.light;
final colors = Theme.of(context).extension<GradientColors>();
```

### **After (New System)**
```dart
import '../design/theme.dart';
import '../design/tokens.dart';

final theme = AppTheme.light;
final colors = DesignTokens.primary;
```

## 📊 **Color System**

### **OKLCH Support**
The design system includes OKLCH color support for better color consistency:

```dart
// OKLCH color with sRGB fallback
final color = ColorUtils.oklch(0.7, 0.15, 250);
```

### **Color Utilities**
- `ColorUtils.oklch()` - Convert OKLCH to sRGB
- `ColorUtils.withOpacity()` - Create color with opacity
- `ColorUtils.blend()` - Blend two colors
- `ColorUtils.getContrastColor()` - Get contrast color
- `ColorUtils.isLight()` / `ColorUtils.isDark()` - Check color brightness

## 🎨 **Design Principles**

### **Consistency**
- All components use the same design tokens
- Consistent spacing and typography
- Unified color palette

### **Accessibility**
- High contrast ratios
- Readable typography
- Color-blind friendly palette

### **Scalability**
- Token-based system
- Easy to update globally
- Theme extensions for customization

### **Performance**
- Efficient color calculations
- Optimized theme switching
- Minimal rebuilds

## 🔍 **Debugging**

### **Theme Inspector**
Use Flutter's theme inspector to debug theme issues:
```bash
flutter run --debug
# Press 't' to open theme inspector
```

### **Color Testing**
Test colors in both light and dark themes:
```dart
// Test color contrast
final contrast = ColorUtils.getContrastColor(DesignTokens.primary);
print('Contrast color: $contrast');
```

## 📚 **Resources**

- [Material Design 3](https://m3.material.io/)
- [OKLCH Color Space](https://oklch.com/)
- [Inter Font](https://rsms.me/inter/)
- [Flutter Theming](https://docs.flutter.dev/cookbook/design/themes)

## 🤝 **Contributing**

When contributing to the design system:

1. **Follow the token system** - Use existing tokens before creating new ones
2. **Test both themes** - Ensure components work in light and dark modes
3. **Update golden tests** - Add tests for new components
4. **Document changes** - Update this README for significant changes
5. **Get approval** - Design system changes require team approval

## 📞 **Support**

For questions about the design system:
- **Design Team:** design@yole.com
- **Engineering Team:** engineering@yole.com
- **Documentation:** [Internal Design System Docs](https://design.yole.com)

---

**Last Updated:** 2025-01-27  
**Version:** 1.0.0  
**Maintainer:** Design System Team

