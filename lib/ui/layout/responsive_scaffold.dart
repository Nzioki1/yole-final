/// Responsive scaffold that handles keyboard and overflow issues
///
/// Provides a keyboard-safe scaffold with proper scrolling behavior
/// and responsive layout for different screen sizes and text scales.
library;

import 'package:flutter/material.dart';

/// A responsive scaffold that handles keyboard, overflow, and different screen sizes
class ResponsiveScaffold extends StatelessWidget {
  /// The main content of the scaffold
  final Widget body;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional bottom widget (typically a CTA button)
  final Widget? bottom;

  /// Padding for the body content
  final EdgeInsetsGeometry? padding;

  /// Whether to make the scaffold keyboard-safe
  final bool keyboardSafe;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottom,
    this.padding,
    this.keyboardSafe = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: keyboardSafe,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(child: _buildBody(context, constraints)),
                if (bottom != null) _buildBottom(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BoxConstraints constraints) {
    final bodyPadding = padding ?? const EdgeInsets.all(16.0);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, overscroll: false),
      child: SingleChildScrollView(padding: bodyPadding, child: body),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [bottom!]),
    );
  }
}
