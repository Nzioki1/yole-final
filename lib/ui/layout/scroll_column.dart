/// Scrollable column with consistent spacing
///
/// Provides a column layout with consistent gaps between children
/// and proper handling of different content sizes.
library;

import 'package:flutter/material.dart';

/// A column widget with consistent spacing between children
class ScrollColumn extends StatelessWidget {
  /// The children widgets to display in the column
  final List<Widget> children;

  /// Cross-axis alignment for the column
  final CrossAxisAlignment crossAxisAlignment;

  /// Gap between children
  final double gap;

  const ScrollColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.gap = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    // For single child, no need for gaps
    if (children.length == 1) {
      return Column(crossAxisAlignment: crossAxisAlignment, children: children);
    }

    // Interleave children with SizedBox gaps
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: gap));
      }
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: spacedChildren,
    );
  }
}

