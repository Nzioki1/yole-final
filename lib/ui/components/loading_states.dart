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

  /// Chart skeleton with bars
  chart,
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
    /// [shimmer] - Whether to enable shimmer effect
    /// [shimmerDuration] - Duration of shimmer animation
    /// [reducedMotion] - Whether to disable shimmer for accessibility
    /// [animate] - Whether to animate the shimmer (false for golden tests)
    /// [constrained] - Whether to apply size constraints
    const LoadingStates({
      super.key,
      this.type = SkeletonType.list,
      this.itemCount = 3,
      this.showLabel = false,
      this.label = 'Loading...',
      this.shimmer = true,
      this.shimmerDuration = const Duration(milliseconds: 1200),
      this.reducedMotion = false,
      this.animate = true,
      this.constrained = true,
    });

  /// The type of skeleton to display
  final SkeletonType type;

  /// Number of skeleton items to show
  final int itemCount;

  /// Whether to show a loading label
  final bool showLabel;

  /// Custom loading label text
  final String label;

  /// Whether to enable shimmer effect
  final bool shimmer;

  /// Duration of shimmer animation
  final Duration shimmerDuration;

  /// Whether to disable shimmer for accessibility
  final bool reducedMotion;

  /// Whether to animate the shimmer (false for golden tests)
  final bool animate;

  /// Whether to apply size constraints
  final bool constrained;

  /// Create a list skeleton widget
  static Widget listSkeleton({
    int itemHeight = 72,
    int count = 6,
    bool shimmer = true,
    Duration shimmerDuration = const Duration(milliseconds: 1200),
    bool reducedMotion = false,
    bool animate = true,
    bool constrained = true,
  }) {
    return LoadingStates(
      type: SkeletonType.list,
      itemCount: count,
      shimmer: shimmer,
      shimmerDuration: shimmerDuration,
      reducedMotion: reducedMotion,
      animate: animate,
      constrained: constrained,
    );
  }

  /// Create a tile skeleton widget
  static Widget tileSkeleton({
    bool shimmer = true,
    Duration shimmerDuration = const Duration(milliseconds: 1200),
    bool reducedMotion = false,
    bool animate = true,
    bool constrained = true,
  }) {
    return LoadingStates(
      type: SkeletonType.tile,
      itemCount: 1,
      shimmer: shimmer,
      shimmerDuration: shimmerDuration,
      reducedMotion: reducedMotion,
      animate: animate,
      constrained: constrained,
    );
  }

  /// Create a card skeleton widget
  static Widget cardSkeleton({
    bool shimmer = true,
    Duration shimmerDuration = const Duration(milliseconds: 1200),
    bool reducedMotion = false,
    bool animate = true,
    bool constrained = true,
  }) {
    return LoadingStates(
      type: SkeletonType.card,
      itemCount: 1,
      shimmer: shimmer,
      shimmerDuration: shimmerDuration,
      reducedMotion: reducedMotion,
      animate: animate,
      constrained: constrained,
    );
  }

  /// Create a chart skeleton widget
  static Widget chartSkeleton({
    int bars = 5,
    bool shimmer = true,
    Duration shimmerDuration = const Duration(milliseconds: 1200),
    bool reducedMotion = false,
    bool animate = true,
    bool constrained = true,
  }) {
    return LoadingStates(
      type: SkeletonType.chart,
      itemCount: bars,
      shimmer: shimmer,
      shimmerDuration: shimmerDuration,
      reducedMotion: reducedMotion,
      animate: animate,
      constrained: constrained,
    );
  }

  /// Create a progress indicator widget
  static Widget progress({String? label, bool animate = true}) {
    return LoadingStates(
      type: SkeletonType.list,
      itemCount: 1,
      showLabel: true,
      label: label ?? 'Loading...',
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = Column(
      children: [
        if (showLabel) ...[
          _buildLoadingLabel(isDark),
          const SizedBox(height: 16),
        ],
        _buildSkeletonContent(isDark),
      ],
    );

    // Apply constraints if requested
    if (constrained) {
      switch (type) {
        case SkeletonType.list:
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: content,
          );
        case SkeletonType.tile:
        case SkeletonType.card:
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: content,
          );
        case SkeletonType.chart:
          return content;
      }
    }

    return content;
  }

  /// Builds the loading label
  Widget _buildLoadingLabel(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: animate
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
                  ),
                )
              : Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
                    shape: BoxShape.circle,
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
      case SkeletonType.chart:
        return _buildChartSkeleton(isDark);
    }
  }

  /// Builds a list skeleton
  Widget _buildListSkeleton(bool isDark) {
    final skeletonItems = List.generate(itemCount, (index) {
      return Padding(
        padding: DesignTokens.spacingSmVertical,
        child: SizedBox(
          height: 72, // Fixed height for list items
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      );
    });

    // Use scrollable content for large counts to prevent overflow
    if (itemCount > 8) {
      return SizedBox(
        height: 600, // Fixed height for scrollable content
        child: ListView(
          children: skeletonItems,
        ),
      );
    } else {
      return Column(children: skeletonItems);
    }
  }

  /// Builds a tile skeleton
  Widget _buildTileSkeleton(bool isDark) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Column(
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
      ),
    );
  }

  /// Builds a card skeleton
  Widget _buildCardSkeleton(bool isDark) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Column(
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
      ),
    );
  }

  /// Builds a chart skeleton
  Widget _buildChartSkeleton(bool isDark) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title
          _buildSkeletonBox(
            width: 120,
            height: 16,
            borderRadius: DesignTokens.radiusSmAll,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          
          // Chart area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final barWidth = (availableWidth / itemCount).clamp(16.0, 32.0);
                
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(itemCount, (index) {
                    final height = (40 + (index * 20) + ((index % 3) * 15)).toDouble().clamp(20.0, constraints.maxHeight * 0.8);
                    return _buildSkeletonBox(
                      width: barWidth,
                      height: height,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      isDark: isDark,
                    );
                  }),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Row(
                children: [
                  _buildSkeletonBox(
                    width: 8,
                    height: 8,
                    borderRadius: BorderRadius.circular(4),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildSkeletonBox(
                    width: 40,
                    height: 12,
                    borderRadius: DesignTokens.radiusSmAll,
                    isDark: isDark,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds a skeleton box with shimmer effect
  Widget _buildSkeletonBox({
    required double width,
    required double height,
    required BorderRadius borderRadius,
    required bool isDark,
  }) {
    final shouldShimmer = shimmer && !reducedMotion && animate;
    
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark
              ? DesignTokens.darkSurfaceVariant
              : DesignTokens.surfaceVariant,
          borderRadius: borderRadius,
        ),
        child: shouldShimmer
            ? _ShimmerEffect(
                duration: shimmerDuration,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant,
                    borderRadius: borderRadius,
                  ),
                ),
              )
            : animate && shimmer
                ? _StaticShimmerEffect(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? DesignTokens.darkSurfaceVariant
                            : DesignTokens.surfaceVariant,
                        borderRadius: borderRadius,
                      ),
                    ),
                  )
                : Container(
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
  const _ShimmerEffect({
    required this.child,
    required this.duration,
  });

  final Widget child;
  final Duration duration;

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
      duration: widget.duration,
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
                    .withValues(alpha: 0.3),
                (isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant)
                    .withValues(alpha: 0.6),
                (isDark
                        ? DesignTokens.darkSurfaceVariant
                        : DesignTokens.surfaceVariant)
                    .withValues(alpha: 0.3),
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

/// Static shimmer effect widget for golden tests (no animation)
class _StaticShimmerEffect extends StatelessWidget {
  const _StaticShimmerEffect({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            (isDark
                    ? DesignTokens.darkSurfaceVariant
                    : DesignTokens.surfaceVariant)
                .withValues(alpha: 0.3),
            (isDark
                    ? DesignTokens.darkSurfaceVariant
                    : DesignTokens.surfaceVariant)
                .withValues(alpha: 0.6),
            (isDark
                    ? DesignTokens.darkSurfaceVariant
                    : DesignTokens.surfaceVariant)
                .withValues(alpha: 0.3),
          ],
          stops: const [0.2, 0.5, 0.8], // Static gradient position
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
