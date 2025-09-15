/// Theme system for Yole app
///
/// This file defines the complete theme system including light and dark themes,
/// component themes, and theme extensions using the design tokens.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tokens.dart';
import 'typography.dart';

/// Main theme class for Yole app
class AppTheme {
  const AppTheme._();

  /// Light theme configuration
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: _lightColorScheme,

      // Typography
      textTheme: AppTypography.createLightTextTheme(),

      // App bar theme
      appBarTheme: _lightAppBarTheme,

      // Button themes
      elevatedButtonTheme: _lightElevatedButtonTheme,
      filledButtonTheme: _lightFilledButtonTheme,
      outlinedButtonTheme: _lightOutlinedButtonTheme,
      textButtonTheme: _lightTextButtonTheme,

      // Input decoration theme
      inputDecorationTheme: _lightInputDecorationTheme,

      // Card theme
      cardTheme: _lightCardThemeData,

      // Chip theme
      chipTheme: _lightChipTheme,

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _lightBottomNavigationBarTheme,

      // Divider theme
      dividerTheme: _lightDividerTheme,

      // List tile theme
      listTileTheme: _lightListTileTheme,

      // Switch theme
      switchTheme: _lightSwitchTheme,

      // Checkbox theme
      checkboxTheme: _lightCheckboxTheme,

      // Radio theme
      radioTheme: _lightRadioTheme,

      // Slider theme
      sliderTheme: _lightSliderTheme,

      // Progress indicator theme
      progressIndicatorTheme: _lightProgressIndicatorTheme,

      // Dialog theme
      dialogTheme: _lightDialogThemeData,

      // Bottom sheet theme
      bottomSheetTheme: _lightBottomSheetTheme,

      // Snack bar theme
      snackBarTheme: _lightSnackBarTheme,

      // Tooltip theme
      tooltipTheme: _lightTooltipTheme,

      // Extensions
      extensions: [
        _lightSidebarColors,
        _lightChartColors,
        _lightInteractiveColors,
        _lightSpacingExtension,
        _lightRadiusExtension,
        _lightAnimationExtension,
      ],
    );
  }

  /// Dark theme configuration
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: _darkColorScheme,

      // Typography
      textTheme: AppTypography.createDarkTextTheme(),

      // App bar theme
      appBarTheme: _darkAppBarTheme,

      // Button themes
      elevatedButtonTheme: _darkElevatedButtonTheme,
      filledButtonTheme: _darkFilledButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _darkTextButtonTheme,

      // Input decoration theme
      inputDecorationTheme: _darkInputDecorationTheme,

      // Card theme
      cardTheme: _darkCardThemeData,

      // Chip theme
      chipTheme: _darkChipTheme,

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme,

      // Divider theme
      dividerTheme: _darkDividerTheme,

      // List tile theme
      listTileTheme: _darkListTileTheme,

      // Switch theme
      switchTheme: _darkSwitchTheme,

      // Checkbox theme
      checkboxTheme: _darkCheckboxTheme,

      // Radio theme
      radioTheme: _darkRadioTheme,

      // Slider theme
      sliderTheme: _darkSliderTheme,

      // Progress indicator theme
      progressIndicatorTheme: _darkProgressIndicatorTheme,

      // Dialog theme
      dialogTheme: _darkDialogThemeData,

      // Bottom sheet theme
      bottomSheetTheme: _darkBottomSheetTheme,

      // Snack bar theme
      snackBarTheme: _darkSnackBarTheme,

      // Tooltip theme
      tooltipTheme: _darkTooltipTheme,

      // Extensions
      extensions: [
        _darkSidebarColors,
        _darkChartColors,
        _darkInteractiveColors,
        _darkSpacingExtension,
        _darkRadiusExtension,
        _darkAnimationExtension,
      ],
    );
  }

  // ============================================================================
  // COLOR SCHEMES
  // ============================================================================

  static ColorScheme get _lightColorScheme {
    return ColorScheme.light(
      primary: DesignTokens.primary,
      onPrimary: DesignTokens.onPrimary,
      primaryContainer: DesignTokens.primaryContainer,
      onPrimaryContainer: DesignTokens.onPrimaryContainer,
      secondary: DesignTokens.success,
      onSecondary: DesignTokens.onSuccess,
      secondaryContainer: DesignTokens.successContainer,
      onSecondaryContainer: DesignTokens.onSuccessContainer,
      tertiary: DesignTokens.warning,
      onTertiary: DesignTokens.onWarning,
      tertiaryContainer: DesignTokens.warningContainer,
      onTertiaryContainer: DesignTokens.onWarningContainer,
      error: DesignTokens.error,
      onError: DesignTokens.onError,
      errorContainer: DesignTokens.errorContainer,
      onErrorContainer: DesignTokens.onErrorContainer,
      surface: DesignTokens.surface,
      onSurface: DesignTokens.onSurface,
      surfaceVariant: DesignTokens.surfaceVariant,
      onSurfaceVariant: DesignTokens.onSurfaceVariant,
      outline: DesignTokens.outline,
      outlineVariant: DesignTokens.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: DesignTokens.onSurface,
      onInverseSurface: DesignTokens.surface,
      inversePrimary: DesignTokens.primary,
      surfaceTint: DesignTokens.primary,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme.dark(
      primary: DesignTokens.darkPrimary,
      onPrimary: DesignTokens.darkOnPrimary,
      primaryContainer: DesignTokens.darkPrimaryContainer,
      onPrimaryContainer: DesignTokens.darkOnPrimaryContainer,
      secondary: DesignTokens.darkSuccess,
      onSecondary: DesignTokens.darkOnSuccess,
      secondaryContainer: DesignTokens.darkSuccessContainer,
      onSecondaryContainer: DesignTokens.darkOnSuccessContainer,
      tertiary: DesignTokens.darkWarning,
      onTertiary: DesignTokens.darkOnWarning,
      tertiaryContainer: DesignTokens.darkWarningContainer,
      onTertiaryContainer: DesignTokens.darkOnWarningContainer,
      error: DesignTokens.darkError,
      onError: DesignTokens.darkOnError,
      errorContainer: DesignTokens.darkErrorContainer,
      onErrorContainer: DesignTokens.darkOnErrorContainer,
      surface: DesignTokens.darkSurface,
      onSurface: DesignTokens.darkOnSurface,
      surfaceVariant: DesignTokens.darkSurfaceVariant,
      onSurfaceVariant: DesignTokens.darkOnSurfaceVariant,
      outline: DesignTokens.darkOutline,
      outlineVariant: DesignTokens.darkOutlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: DesignTokens.darkOnSurface,
      onInverseSurface: DesignTokens.darkSurface,
      inversePrimary: DesignTokens.darkPrimary,
      surfaceTint: DesignTokens.darkPrimary,
    );
  }

  // ============================================================================
  // APP BAR THEMES
  // ============================================================================

  static AppBarTheme get _lightAppBarTheme {
    return AppBarTheme(
      backgroundColor: DesignTokens.surface,
      foregroundColor: DesignTokens.onSurface,
      elevation: DesignTokens.elevation1,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: DesignTokens.primary,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTypography.h5.copyWith(color: DesignTokens.onSurface),
      toolbarTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.onSurface,
      ),
    );
  }

  static AppBarTheme get _darkAppBarTheme {
    return AppBarTheme(
      backgroundColor: DesignTokens.darkSurface,
      foregroundColor: DesignTokens.darkOnSurface,
      elevation: DesignTokens.elevation1,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: DesignTokens.darkPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.h5.copyWith(
        color: DesignTokens.darkOnSurface,
      ),
      toolbarTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.darkOnSurface,
      ),
    );
  }

  // ============================================================================
  // BUTTON THEMES
  // ============================================================================

  static ElevatedButtonThemeData get _lightElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primary,
        foregroundColor: DesignTokens.onPrimary,
        elevation: DesignTokens.elevation2,
        shadowColor: DesignTokens.primary.withOpacity(0.3),
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static ElevatedButtonThemeData get _darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.darkPrimary,
        foregroundColor: DesignTokens.darkOnPrimary,
        elevation: DesignTokens.elevation2,
        shadowColor: DesignTokens.darkPrimary.withOpacity(0.3),
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static FilledButtonThemeData get _lightFilledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DesignTokens.primary,
        foregroundColor: DesignTokens.onPrimary,
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static FilledButtonThemeData get _darkFilledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DesignTokens.darkPrimary,
        foregroundColor: DesignTokens.darkOnPrimary,
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static OutlinedButtonThemeData get _lightOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.primary,
        side: BorderSide(color: DesignTokens.primary, width: 1),
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static OutlinedButtonThemeData get _darkOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.darkPrimary,
        side: BorderSide(color: DesignTokens.darkPrimary, width: 1),
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static TextButtonThemeData get _lightTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.primary,
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  static TextButtonThemeData get _darkTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.darkPrimary,
        padding: DesignTokens.spacingLgAll,
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
        textStyle: AppTypography.buttonLarge,
        minimumSize: const Size(120, 48),
      ),
    );
  }

  // ============================================================================
  // INPUT DECORATION THEMES
  // ============================================================================

  static InputDecorationTheme get _lightInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.error, width: 2),
      ),
      contentPadding: DesignTokens.spacingLgAll,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.onSurfaceVariant,
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.onSurfaceVariant,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(color: DesignTokens.error),
    );
  }

  static InputDecorationTheme get _darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: DesignTokens.radiusMdAll,
        borderSide: BorderSide(color: DesignTokens.darkError, width: 2),
      ),
      contentPadding: DesignTokens.spacingLgAll,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.darkOnSurfaceVariant,
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.darkOnSurfaceVariant,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: DesignTokens.darkError,
      ),
    );
  }

  // ============================================================================
  // CARD THEMES
  // ============================================================================

  static CardThemeData get _lightCardThemeData {
    return CardThemeData(
      color: DesignTokens.surface,
      shadowColor: Colors.black,
      elevation: DesignTokens.elevation2,
      shape: const RoundedRectangleBorder(
        borderRadius: DesignTokens.radiusLgAll,
      ),
      margin: DesignTokens.spacingMdAll,
    );
  }

  static CardThemeData get _darkCardThemeData {
    return CardThemeData(
      color: DesignTokens.darkSurface,
      shadowColor: Colors.black,
      elevation: DesignTokens.elevation2,
      shape: const RoundedRectangleBorder(
        borderRadius: DesignTokens.radiusLgAll,
      ),
      margin: DesignTokens.spacingMdAll,
    );
  }

  // ============================================================================
  // CHIP THEMES
  // ============================================================================

  static ChipThemeData get _lightChipTheme {
    return ChipThemeData(
      backgroundColor: DesignTokens.surfaceVariant,
      selectedColor: DesignTokens.primary,
      disabledColor: DesignTokens.surfaceVariant.withOpacity(0.5),
      labelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.onSurfaceVariant,
      ),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.onPrimary,
      ),
      padding: DesignTokens.spacingSmAll,
      labelPadding: DesignTokens.spacingXsHorizontal,
      side: BorderSide(color: DesignTokens.outline),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusPillAll),
    );
  }

  static ChipThemeData get _darkChipTheme {
    return ChipThemeData(
      backgroundColor: DesignTokens.darkSurfaceVariant,
      selectedColor: DesignTokens.darkPrimary,
      disabledColor: DesignTokens.darkSurfaceVariant.withOpacity(0.5),
      labelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.darkOnSurfaceVariant,
      ),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.darkOnPrimary,
      ),
      padding: DesignTokens.spacingSmAll,
      labelPadding: DesignTokens.spacingXsHorizontal,
      side: BorderSide(color: DesignTokens.darkOutline),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusPillAll),
    );
  }

  // ============================================================================
  // BOTTOM NAVIGATION BAR THEMES
  // ============================================================================

  static BottomNavigationBarThemeData get _lightBottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.surface,
      selectedItemColor: DesignTokens.primary,
      unselectedItemColor: DesignTokens.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: DesignTokens.elevation3,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
    );
  }

  static BottomNavigationBarThemeData get _darkBottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.darkSurface,
      selectedItemColor: DesignTokens.darkPrimary,
      unselectedItemColor: DesignTokens.darkOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: DesignTokens.elevation3,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
    );
  }

  // ============================================================================
  // DIVIDER THEMES
  // ============================================================================

  static DividerThemeData get _lightDividerTheme {
    return DividerThemeData(
      color: DesignTokens.outline,
      thickness: 1,
      space: 1,
    );
  }

  static DividerThemeData get _darkDividerTheme {
    return DividerThemeData(
      color: DesignTokens.darkOutline,
      thickness: 1,
      space: 1,
    );
  }

  // ============================================================================
  // LIST TILE THEMES
  // ============================================================================

  static ListTileThemeData get _lightListTileTheme {
    return ListTileThemeData(
      contentPadding: DesignTokens.spacingLgHorizontal,
      titleTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.onSurface,
      ),
      subtitleTextStyle: AppTypography.bodySmall.copyWith(
        color: DesignTokens.onSurfaceVariant,
      ),
      leadingAndTrailingTextStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.onSurfaceVariant,
      ),
      iconColor: DesignTokens.onSurfaceVariant,
      textColor: DesignTokens.onSurface,
      tileColor: Colors.transparent,
      selectedTileColor: DesignTokens.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
    );
  }

  static ListTileThemeData get _darkListTileTheme {
    return ListTileThemeData(
      contentPadding: DesignTokens.spacingLgHorizontal,
      titleTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.darkOnSurface,
      ),
      subtitleTextStyle: AppTypography.bodySmall.copyWith(
        color: DesignTokens.darkOnSurfaceVariant,
      ),
      leadingAndTrailingTextStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.darkOnSurfaceVariant,
      ),
      iconColor: DesignTokens.darkOnSurfaceVariant,
      textColor: DesignTokens.darkOnSurface,
      tileColor: Colors.transparent,
      selectedTileColor: DesignTokens.darkPrimary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
    );
  }

  // ============================================================================
  // SWITCH THEMES
  // ============================================================================

  static SwitchThemeData get _lightSwitchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.switchThumb;
        }
        return DesignTokens.switchThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.switchTrackActive;
        }
        return DesignTokens.switchTrack;
      }),
    );
  }

  static SwitchThemeData get _darkSwitchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.darkSwitchThumb;
        }
        return DesignTokens.darkSwitchThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.darkSwitchTrackActive;
        }
        return DesignTokens.darkSwitchTrack;
      }),
    );
  }

  // ============================================================================
  // CHECKBOX THEMES
  // ============================================================================

  static CheckboxThemeData get _lightCheckboxTheme {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(DesignTokens.onPrimary),
      side: BorderSide(color: DesignTokens.outline),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusSmAll),
    );
  }

  static CheckboxThemeData get _darkCheckboxTheme {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.darkPrimary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(DesignTokens.darkOnPrimary),
      side: BorderSide(color: DesignTokens.darkOutline),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusSmAll),
    );
  }

  // ============================================================================
  // RADIO THEMES
  // ============================================================================

  static RadioThemeData get _lightRadioTheme {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.primary;
        }
        return DesignTokens.outline;
      }),
    );
  }

  static RadioThemeData get _darkRadioTheme {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DesignTokens.darkPrimary;
        }
        return DesignTokens.darkOutline;
      }),
    );
  }

  // ============================================================================
  // SLIDER THEMES
  // ============================================================================

  static SliderThemeData get _lightSliderTheme {
    return SliderThemeData(
      activeTrackColor: DesignTokens.primary,
      inactiveTrackColor: DesignTokens.outline,
      thumbColor: DesignTokens.primary,
      overlayColor: DesignTokens.primary.withOpacity(0.1),
      valueIndicatorColor: DesignTokens.primary,
      valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.onPrimary,
      ),
    );
  }

  static SliderThemeData get _darkSliderTheme {
    return SliderThemeData(
      activeTrackColor: DesignTokens.darkPrimary,
      inactiveTrackColor: DesignTokens.darkOutline,
      thumbColor: DesignTokens.darkPrimary,
      overlayColor: DesignTokens.darkPrimary.withOpacity(0.1),
      valueIndicatorColor: DesignTokens.darkPrimary,
      valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
        color: DesignTokens.darkOnPrimary,
      ),
    );
  }

  // ============================================================================
  // PROGRESS INDICATOR THEMES
  // ============================================================================

  static ProgressIndicatorThemeData get _lightProgressIndicatorTheme {
    return ProgressIndicatorThemeData(
      color: DesignTokens.primary,
      linearTrackColor: DesignTokens.outline,
      circularTrackColor: DesignTokens.outline,
    );
  }

  static ProgressIndicatorThemeData get _darkProgressIndicatorTheme {
    return ProgressIndicatorThemeData(
      color: DesignTokens.darkPrimary,
      linearTrackColor: DesignTokens.darkOutline,
      circularTrackColor: DesignTokens.darkOutline,
    );
  }

  // ============================================================================
  // DIALOG THEMES
  // ============================================================================

  static DialogThemeData get _lightDialogThemeData {
    return DialogThemeData(
      backgroundColor: DesignTokens.surface,
      surfaceTintColor: DesignTokens.primary,
      elevation: DesignTokens.elevation5,
      shape: const RoundedRectangleBorder(
        borderRadius: DesignTokens.radiusLgAll,
      ),
      titleTextStyle: AppTypography.h4,
      contentTextStyle: AppTypography.bodyMedium,
    );
  }

  static DialogThemeData get _darkDialogThemeData {
    return DialogThemeData(
      backgroundColor: DesignTokens.darkSurface,
      surfaceTintColor: DesignTokens.darkPrimary,
      elevation: DesignTokens.elevation5,
      shape: const RoundedRectangleBorder(
        borderRadius: DesignTokens.radiusLgAll,
      ),
      titleTextStyle: AppTypography.h4,
      contentTextStyle: AppTypography.bodyMedium,
    );
  }

  // ============================================================================
  // BOTTOM SHEET THEMES
  // ============================================================================

  static BottomSheetThemeData get _lightBottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: DesignTokens.surface,
      surfaceTintColor: DesignTokens.primary,
      elevation: DesignTokens.elevation5,
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusLgTop),
      modalBackgroundColor: DesignTokens.surface,
      modalElevation: DesignTokens.elevation5,
    );
  }

  static BottomSheetThemeData get _darkBottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: DesignTokens.darkSurface,
      surfaceTintColor: DesignTokens.darkPrimary,
      elevation: DesignTokens.elevation5,
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusLgTop),
      modalBackgroundColor: DesignTokens.darkSurface,
      modalElevation: DesignTokens.elevation5,
    );
  }

  // ============================================================================
  // SNACK BAR THEMES
  // ============================================================================

  static SnackBarThemeData get _lightSnackBarTheme {
    return SnackBarThemeData(
      backgroundColor: DesignTokens.onSurface,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.surface,
      ),
      actionTextColor: DesignTokens.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
      elevation: DesignTokens.elevation3,
    );
  }

  static SnackBarThemeData get _darkSnackBarTheme {
    return SnackBarThemeData(
      backgroundColor: DesignTokens.darkOnSurface,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.darkSurface,
      ),
      actionTextColor: DesignTokens.darkPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusMdAll),
      elevation: DesignTokens.elevation3,
    );
  }

  // ============================================================================
  // TOOLTIP THEMES
  // ============================================================================

  static TooltipThemeData get _lightTooltipTheme {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: DesignTokens.onSurface,
        borderRadius: DesignTokens.radiusSmAll,
      ),
      textStyle: AppTypography.bodySmall.copyWith(color: DesignTokens.surface),
      padding: DesignTokens.spacingSmAll,
    );
  }

  static TooltipThemeData get _darkTooltipTheme {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: DesignTokens.darkOnSurface,
        borderRadius: DesignTokens.radiusSmAll,
      ),
      textStyle: AppTypography.bodySmall.copyWith(
        color: DesignTokens.darkSurface,
      ),
      padding: DesignTokens.spacingSmAll,
    );
  }

  // ============================================================================
  // THEME EXTENSIONS
  // ============================================================================

  /// Sidebar colors extension
  static const _SidebarColors _lightSidebarColors = _SidebarColors(
    backgroundColor: DesignTokens.sidebarBg,
    activeColor: DesignTokens.sidebarActive,
    inactiveColor: DesignTokens.sidebarInactive,
    hoverColor: DesignTokens.sidebarHover,
  );

  static const _SidebarColors _darkSidebarColors = _SidebarColors(
    backgroundColor: DesignTokens.darkSidebarBg,
    activeColor: DesignTokens.darkSidebarActive,
    inactiveColor: DesignTokens.darkSidebarInactive,
    hoverColor: DesignTokens.darkSidebarHover,
  );

  /// Chart colors extension
  static const _ChartColors _lightChartColors = _ChartColors(
    chart1: DesignTokens.chart1,
    chart2: DesignTokens.chart2,
    chart3: DesignTokens.chart3,
    chart4: DesignTokens.chart4,
    chart5: DesignTokens.chart5,
  );

  static const _ChartColors _darkChartColors = _ChartColors(
    chart1: DesignTokens.chart1,
    chart2: DesignTokens.chart2,
    chart3: DesignTokens.chart3,
    chart4: DesignTokens.chart4,
    chart5: DesignTokens.chart5,
  );

  /// Interactive colors extension
  static const _InteractiveColors _lightInteractiveColors = _InteractiveColors(
    ring: DesignTokens.ring,
    switchThumb: DesignTokens.switchThumb,
    switchTrack: DesignTokens.switchTrack,
    switchTrackActive: DesignTokens.switchTrackActive,
  );

  static const _InteractiveColors _darkInteractiveColors = _InteractiveColors(
    ring: DesignTokens.darkRing,
    switchThumb: DesignTokens.darkSwitchThumb,
    switchTrack: DesignTokens.darkSwitchTrack,
    switchTrackActive: DesignTokens.darkSwitchTrackActive,
  );

  /// Spacing extension
  static const _SpacingExtension _lightSpacingExtension = _SpacingExtension(
    xs: DesignTokens.spacingXs,
    sm: DesignTokens.spacingSm,
    md: DesignTokens.spacingMd,
    lg: DesignTokens.spacingLg,
    xl: DesignTokens.spacingXl,
    xxl: DesignTokens.spacing2xl,
    xxxl: DesignTokens.spacing3xl,
  );

  static const _SpacingExtension _darkSpacingExtension = _SpacingExtension(
    xs: DesignTokens.spacingXs,
    sm: DesignTokens.spacingSm,
    md: DesignTokens.spacingMd,
    lg: DesignTokens.spacingLg,
    xl: DesignTokens.spacingXl,
    xxl: DesignTokens.spacing2xl,
    xxxl: DesignTokens.spacing3xl,
  );

  /// Radius extension
  static const _RadiusExtension _lightRadiusExtension = _RadiusExtension(
    sm: DesignTokens.radiusSm,
    md: DesignTokens.radiusMd,
    lg: DesignTokens.radiusLg,
    pill: DesignTokens.radiusPill,
  );

  static const _RadiusExtension _darkRadiusExtension = _RadiusExtension(
    sm: DesignTokens.radiusSm,
    md: DesignTokens.radiusMd,
    lg: DesignTokens.radiusLg,
    pill: DesignTokens.radiusPill,
  );

  /// Animation extension
  static const _AnimationExtension _lightAnimationExtension =
      _AnimationExtension(
        fast: DesignTokens.animationFast,
        normal: DesignTokens.animationNormal,
        slow: DesignTokens.animationSlow,
        easeIn: DesignTokens.animationEaseIn,
        easeOut: DesignTokens.animationEaseOut,
        easeInOut: DesignTokens.animationEaseInOut,
      );

  static const _AnimationExtension _darkAnimationExtension =
      _AnimationExtension(
        fast: DesignTokens.animationFast,
        normal: DesignTokens.animationNormal,
        slow: DesignTokens.animationSlow,
        easeIn: DesignTokens.animationEaseIn,
        easeOut: DesignTokens.animationEaseOut,
        easeInOut: DesignTokens.animationEaseInOut,
      );
}

// ============================================================================
// THEME EXTENSIONS
// ============================================================================

/// Sidebar colors theme extension
class _SidebarColors extends ThemeExtension<_SidebarColors> {
  const _SidebarColors({
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.hoverColor,
  });

  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color hoverColor;

  @override
  _SidebarColors copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? hoverColor,
  }) {
    return _SidebarColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      hoverColor: hoverColor ?? this.hoverColor,
    );
  }

  @override
  _SidebarColors lerp(ThemeExtension<_SidebarColors>? other, double t) {
    if (other is! _SidebarColors) return this;
    return _SidebarColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
    );
  }
}

/// Chart colors theme extension
class _ChartColors extends ThemeExtension<_ChartColors> {
  const _ChartColors({
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  @override
  _ChartColors copyWith({
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return _ChartColors(
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  @override
  _ChartColors lerp(ThemeExtension<_ChartColors>? other, double t) {
    if (other is! _ChartColors) return this;
    return _ChartColors(
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
    );
  }
}

/// Interactive colors theme extension
class _InteractiveColors extends ThemeExtension<_InteractiveColors> {
  const _InteractiveColors({
    required this.ring,
    required this.switchThumb,
    required this.switchTrack,
    required this.switchTrackActive,
  });

  final Color ring;
  final Color switchThumb;
  final Color switchTrack;
  final Color switchTrackActive;

  @override
  _InteractiveColors copyWith({
    Color? ring,
    Color? switchThumb,
    Color? switchTrack,
    Color? switchTrackActive,
  }) {
    return _InteractiveColors(
      ring: ring ?? this.ring,
      switchThumb: switchThumb ?? this.switchThumb,
      switchTrack: switchTrack ?? this.switchTrack,
      switchTrackActive: switchTrackActive ?? this.switchTrackActive,
    );
  }

  @override
  _InteractiveColors lerp(ThemeExtension<_InteractiveColors>? other, double t) {
    if (other is! _InteractiveColors) return this;
    return _InteractiveColors(
      ring: Color.lerp(ring, other.ring, t)!,
      switchThumb: Color.lerp(switchThumb, other.switchThumb, t)!,
      switchTrack: Color.lerp(switchTrack, other.switchTrack, t)!,
      switchTrackActive: Color.lerp(
        switchTrackActive,
        other.switchTrackActive,
        t,
      )!,
    );
  }
}

/// Spacing theme extension
class _SpacingExtension extends ThemeExtension<_SpacingExtension> {
  const _SpacingExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  @override
  _SpacingExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return _SpacingExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  _SpacingExtension lerp(ThemeExtension<_SpacingExtension>? other, double t) {
    if (other is! _SpacingExtension) return this;
    return _SpacingExtension(
      xs: _lerpDouble(xs, other.xs, t),
      sm: _lerpDouble(sm, other.sm, t),
      md: _lerpDouble(md, other.md, t),
      lg: _lerpDouble(lg, other.lg, t),
      xl: _lerpDouble(xl, other.xl, t),
      xxl: _lerpDouble(xxl, other.xxl, t),
      xxxl: _lerpDouble(xxxl, other.xxxl, t),
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

/// Radius theme extension
class _RadiusExtension extends ThemeExtension<_RadiusExtension> {
  const _RadiusExtension({
    required this.sm,
    required this.md,
    required this.lg,
    required this.pill,
  });

  final double sm;
  final double md;
  final double lg;
  final double pill;

  @override
  _RadiusExtension copyWith({
    double? sm,
    double? md,
    double? lg,
    double? pill,
  }) {
    return _RadiusExtension(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      pill: pill ?? this.pill,
    );
  }

  @override
  _RadiusExtension lerp(ThemeExtension<_RadiusExtension>? other, double t) {
    if (other is! _RadiusExtension) return this;
    return _RadiusExtension(
      sm: _lerpDouble(sm, other.sm, t),
      md: _lerpDouble(md, other.md, t),
      lg: _lerpDouble(lg, other.lg, t),
      pill: _lerpDouble(pill, other.pill, t),
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

/// Animation theme extension
class _AnimationExtension extends ThemeExtension<_AnimationExtension> {
  const _AnimationExtension({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.easeIn,
    required this.easeOut,
    required this.easeInOut,
  });

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve easeIn;
  final Curve easeOut;
  final Curve easeInOut;

  @override
  _AnimationExtension copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Curve? easeIn,
    Curve? easeOut,
    Curve? easeInOut,
  }) {
    return _AnimationExtension(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      easeIn: easeIn ?? this.easeIn,
      easeOut: easeOut ?? this.easeOut,
      easeInOut: easeInOut ?? this.easeInOut,
    );
  }

  @override
  _AnimationExtension lerp(
    ThemeExtension<_AnimationExtension>? other,
    double t,
  ) {
    if (other is! _AnimationExtension) return this;
    return _AnimationExtension(
      fast: Duration(
        milliseconds:
            (fast.inMilliseconds +
                    (other.fast.inMilliseconds - fast.inMilliseconds) * t)
                .round(),
      ),
      normal: Duration(
        milliseconds:
            (normal.inMilliseconds +
                    (other.normal.inMilliseconds - normal.inMilliseconds) * t)
                .round(),
      ),
      slow: Duration(
        milliseconds:
            (slow.inMilliseconds +
                    (other.slow.inMilliseconds - slow.inMilliseconds) * t)
                .round(),
      ),
      easeIn: easeIn,
      easeOut: easeOut,
      easeInOut: easeInOut,
    );
  }
}

// ============================================================================
// EXTENSION GETTERS
// ============================================================================

/// Extension to access theme extensions easily
extension ThemeExtensionGetters on ThemeData {
  _SidebarColors get sidebarColors => extension<_SidebarColors>()!;
  _ChartColors get chartColors => extension<_ChartColors>()!;
  _InteractiveColors get interactiveColors => extension<_InteractiveColors>()!;
  _SpacingExtension get spacing => extension<_SpacingExtension>()!;
  _RadiusExtension get radius => extension<_RadiusExtension>()!;
  _AnimationExtension get animation => extension<_AnimationExtension>()!;
}
