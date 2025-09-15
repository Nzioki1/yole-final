/// Inline progress component for form submits and async operations
///
/// Provides:
/// - Debounced button state to prevent double taps
/// - Inline progress indicator with label
/// - Accessibility support
/// - Consistent styling with design system
library;

import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Inline progress component for form submissions
///
/// Shows a progress indicator with label and prevents double submission
/// by debouncing the button state.
class InlineProgress extends StatefulWidget {
  /// Label text to display next to progress indicator
  final String label;
  
  /// Whether the operation is currently in progress
  final bool isLoading;
  
  /// Callback when the operation should be started
  final VoidCallback? onPressed;
  
  /// Custom progress indicator color
  final Color? progressColor;
  
  /// Size of the progress indicator
  final double size;
  
  /// Debounce duration to prevent double taps
  final Duration debounceDuration;
  
  /// Whether to show the progress indicator
  final bool showProgress;
  
  /// Custom text style for the label
  final TextStyle? labelStyle;

  const InlineProgress({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.progressColor,
    this.size = 16.0,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.showProgress = true,
    this.labelStyle,
  });

  @override
  State<InlineProgress> createState() => _InlineProgressState();
}

class _InlineProgressState extends State<InlineProgress> {
  bool _isDebouncing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final effectiveProgressColor = widget.progressColor ?? 
        (isDark ? DesignTokens.primary : DesignTokens.primary);
    
    final effectiveLabelStyle = widget.labelStyle ?? 
        AppTypography.bodyMedium.copyWith(
          color: isDark 
              ? DesignTokens.onSurface 
              : DesignTokens.onSurface,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showProgress && widget.isLoading) ...[
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: effectiveLabelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  /// Checks if the button should be enabled
  bool get isEnabled => !widget.isLoading && !_isDebouncing;
}

/// Debounced button that prevents double taps during async operations
class DebouncedButton extends StatefulWidget {
  /// Child widget to display in the button
  final Widget child;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is currently loading
  final bool isLoading;
  
  /// Debounce duration to prevent double taps
  final Duration debounceDuration;
  
  /// Button style
  final ButtonStyle? style;
  
  /// Whether to show loading indicator
  final bool showLoadingIndicator;

  const DebouncedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.style,
    this.showLoadingIndicator = true,
  });

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  bool _isDebouncing = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isLoading && !_isDebouncing && widget.onPressed != null;
    
    return ElevatedButton(
      onPressed: isEnabled ? _handlePress : null,
      style: widget.style,
      child: widget.showLoadingIndicator && widget.isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                widget.child,
              ],
            )
          : widget.child,
    );
  }

  void _handlePress() {
    if (_isDebouncing || widget.isLoading) return;
    
    widget.onPressed?.call();
    _startDebounce();
  }

  /// Starts the debounce timer to prevent double taps
  void _startDebounce() {
    setState(() {
      _isDebouncing = true;
    });
    
    Future.delayed(widget.debounceDuration, () {
      if (mounted) {
        setState(() {
          _isDebouncing = false;
        });
      }
    });
  }
}

/// Inline progress with button for form submissions
class InlineProgressButton extends StatelessWidget {
  /// Label text for the progress indicator
  final String label;
  
  /// Whether the operation is currently in progress
  final bool isLoading;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Button text
  final String buttonText;
  
  /// Debounce duration to prevent double taps
  final Duration debounceDuration;

  const InlineProgressButton({
    super.key,
    required this.label,
    required this.buttonText,
    this.isLoading = false,
    this.onPressed,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Progress indicator with label
        InlineProgress(
          label: label,
          isLoading: isLoading,
          showProgress: true,
        ),
        
        const SizedBox(height: 16),
        
        // Debounced button
        DebouncedButton(
          isLoading: isLoading,
          debounceDuration: debounceDuration,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? DesignTokens.primary : DesignTokens.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
