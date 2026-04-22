import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/shadows.dart';
import 'app_card.dart';

/// Jago POS Design System - Skeleton Loading
///
/// Shimmer loading effect that mimics content layout.
/// Better UX than circular progress indicator.

class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
    this.color,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isCircle;
  final Color? color;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.isCircle
        ? (widget.width ?? widget.height ?? 40) / 2
        : (widget.borderRadius ?? AppRadius.sm);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: widget.color ?? AppColors.neutral200,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                (widget.color ?? AppColors.neutral200).withValues(alpha: 0.5),
                widget.color ?? AppColors.neutral200,
                (widget.color ?? AppColors.neutral200).withValues(alpha: 0.5),
              ],
              stops: [
                _animation.value - 0.5,
                _animation.value,
                _animation.value + 0.5,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton for product card
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.allSm,
      child: Row(
        children: [
          const Skeleton(width: 56, height: 56, borderRadius: 12),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Skeleton(width: double.infinity, height: 16),
                AppSpacing.vGapSm,
                const Skeleton(width: 80, height: 12),
              ],
            ),
          ),
          AppSpacing.hGapMd,
          const Skeleton(width: 80, height: 18),
        ],
      ),
    );
  }
}

/// Skeleton for stat card
class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Skeleton(width: 40, height: 40, borderRadius: 8),
              AppSpacing.hGapMd,
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 60, height: 12),
                    SizedBox(height: 8),
                    Skeleton(width: 100, height: 24),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// List of skeleton product cards
class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppSpacing.vGapSm,
      itemBuilder: (_, _) => const ProductCardSkeleton(),
    );
  }
}

/// Skeleton for login form
class LoginFormSkeleton extends StatelessWidget {
  const LoginFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton(width: 80, height: 12),
        AppSpacing.vGapXs,
        const Skeleton(width: double.infinity, height: 48, borderRadius: 12),
        AppSpacing.vGapLg,
        const Skeleton(width: 80, height: 12),
        AppSpacing.vGapXs,
        const Skeleton(width: double.infinity, height: 48, borderRadius: 12),
        AppSpacing.vGapXl,
        const Skeleton(width: double.infinity, height: 52, borderRadius: 12),
      ],
    );
  }
}

/// Grid of skeleton stat cards
class StatGridSkeleton extends StatelessWidget {
  const StatGridSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.screenPadding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => const StatCardSkeleton(),
    );
  }
}

/// Shimmer effect wrapper for custom content
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child, this.isLoading = true});

  final Widget child;
  final bool isLoading;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlideGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * 2 * (percent - 0.5), 0, 0);
  }
}
