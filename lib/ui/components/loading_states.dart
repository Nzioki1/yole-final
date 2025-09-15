/// Loading states component for showing skeleton and progress indicators
///
/// This component provides various loading states including skeleton
/// loaders for lists, tiles, and cards, as well as progress indicators.
library;

import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Types of skeleton loaders
enum SkeletonType {
  /// List skeleton with multiple lines
  list,

  /// Tile skeleton with icon and content
  tile,

  /// Card skeleton with header and content
  card,
}

/// Loading states component for showing skeleton and progress indicators
///
/// This component provides various loading states that can be used
/// throughout the application to indicate loading content.
class LoadingStates extends StatelessWidget {
  /// Creates a loading states component
  ///
  /// [type] - The type of skeleton to display
  /// [itemCount] - Number of skeleton items to show
  /// [showLabel] - Whether to show a loading label
  /// [label] - Custom loading label text
  const LoadingStates({
    super.key,
    this.type = SkeletonType.list,
    this.itemCount = 3,
    this.showLabel = false,
    this.label = 'Loading...',
  });

  /// The type of skeleton to display
  final SkeletonType type;

  /// Number of skeleton items to show
  final int itemCount;

  /// Whether to show a loading label
  final bool showLabel;

  /// Custom loading label text
  final String label;

  /// Create a list skeleton widget
  static Widget listSkeleton({int itemCount = 3}) {
    return LoadingStates(type: SkeletonType.list, itemCount: itemCount);
  }

  /// Create a tile skeleton widget
  static Widget tileSkeleton({bool showIcon = true, bool showSubtitle = true}) {
    return LoadingStates(type: SkeletonType.tile, itemCount: 1);
  }

  /// Create a card skeleton widget
  static Widget cardSkeleton({bool showIcon = true, bool showSubtitle = true}) {
    return LoadingStates(type: SkeletonType.card, itemCount: 1);
  }

  /// Create a progress indicator widget
  static Widget progress({String? label}) {
    return LoadingStates(
      type: SkeletonType.list,
      itemCount: 1,
      showLabel: true,
      label: label ?? 'Loading...',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        if (showLabel) ...[
          _buildLoadingLabel(isDark),
          const SizedBox(height: 16),
        ],
        _buildSkeletonContent(isDark),
      ],
    );
  }

  /// Builds the loading label
  Widget _buildLoadingLabel(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? DesignTokens.darkOnSurfaceVariant
                  : DesignTokens.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Builds the skeleton content based on type
  Widget _buildSkeletonContent(bool isDark) {
    switch (type) {
      case SkeletonType.list:
        return _buildListSkeleton(isDark);
      case SkeletonType.tile:
        return _buildTileSkeleton(isDark);
      case SkeletonType.card:
        return _buildCardSkeleton(isDark);
    }
  }

  /// Builds a list skeleton
  Widget _buildListSkeleton(bool isDark) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: DesignTokens.spacingSmVertical,
          child: Row(
            children: [
              // Icon skeleton
              _buildSkeletonBox(
                width: 40,
                height: 40,
                borderRadius: DesignTokens.radiusMdAll,
                isDark: isDark,
              ),
              const SizedBox(width: 12),

              // Content skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 16,
                      borderRadius: DesignTokens.radiusSmAll,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(
                      width: 200,
                      height: 12,
                      borderRadius: DesignTokens.radiusSmAll,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Amount skeleton
              _buildSkeletonBox(
                width: 80,
                height: 16,
                borderRadius: DesignTokens.radiusSmAll,
                isDark: isDark,
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Builds a tile skeleton
  Widget _buildTileSkeleton(bool isDark) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Card(
          margin: DesignTokens.spacingSmAll,
          child: Padding(
            padding: DesignTokens.spacingLgAll,
            child: Row(
              children: [
                // Icon skeleton
                _buildSkeletonBox(
                  width: 48,
                  height: 48,
                  borderRadius: DesignTokens.radiusMdAll,
                  isDark: isDark,
                ),
                const SizedBox(width: 16),

                // Content skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSkeletonBox(
                        width: double.infinity,
                        height: 18,
                        borderRadius: DesignTokens.radiusSmAll,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildSkeletonBox(
                        width: 150,
                        height: 14,
                        borderRadius: DesignTokens.radiusSmAll,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 4),
                      _buildSkeletonBox(
                        width: 100,
                        height: 12,
                        borderRadius: DesignTokens.radiusSmAll,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Action skeleton
                _buildSkeletonBox(
                  width: 24,
                  height: 24,
                  borderRadius: DesignTokens.radiusSmAll,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Builds a card skeleton
  Widget _buildCardSkeleton(bool isDark) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Card(
          margin: DesignTokens.spacingSmAll,
          child: Padding(
            padding: DesignTokens.spacingLgAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header skeleton
                Row(
                  children: [
                    _buildSkeletonBox(
                      width: 40,
                      height: 40,
                      borderRadius: DesignTokens.radiusMdAll,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSkeletonBox(
                        width: double.infinity,
                        height: 16,
                        borderRadius: DesignTokens.radiusSmAll,
                        isDark: isDark,
                      ),
                    ),
                    _buildSkeletonBox(
                      width: 60,
                      height: 16,
                      borderRadius: DesignTokens.radiusSmAll,
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Content skeleton
                _buildSkeletonBox(
                  width: double.infinity,
                  height: 14,
                  borderRadius: DesignTokens.radiusSmAll,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _buildSkeletonBox(
                  width: 200,
                  height: 14,
                  borderRadius: DesignTokens.radiusSmAll,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _buildSkeletonBox(
                  width: 150,
                  height: 14,
                  borderRadius: DesignTokens.radiusSmAll,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                // Footer skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonBox(
                      width: 80,
                      height: 12,
                      borderRadius: DesignTokens.radiusSmAll,
                      isDark: isDark,
                    ),
                    _buildSkeletonBox(
                      width: 100,
                      height: 12,
                      borderRadius: DesignTokens.radiusSmAll,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Builds a skeleton box with shimmer effect
  Widget _buildSkeletonBox({
    required double width,
    required double height,
    required BorderRadius borderRadius,
    required bool isDark,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? DesignTokens.darkSurfaceVariant
            : DesignTokens.surfaceVariant,
        borderRadius: borderRadius,
      ),
      child: _ShimmerEffect(
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? DesignTokens.darkSurfaceVariant
                : DesignTokens.surfaceVariant,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

/// Shimmer effect widget for skeleton loading
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect({required this.child});

  final Widget child;

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                (isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant)
                    .withOpacity(0.3),
                (isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant)
                    .withOpacity(0.6),
                (isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant)
                    .withOpacity(0.3),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
