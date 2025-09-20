import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CelebrationAnimationWidget extends StatefulWidget {
  final bool isVisible;
  final String message;
  final VoidCallback? onAnimationComplete;

  const CelebrationAnimationWidget({
    Key? key,
    required this.isVisible,
    this.message = 'Great Job!',
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<CelebrationAnimationWidget> createState() =>
      _CelebrationAnimationWidgetState();
}

class _CelebrationAnimationWidgetState extends State<CelebrationAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void didUpdateWidget(CelebrationAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _scaleController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _scaleController.reverse().then((_) {
          widget.onAnimationComplete?.call();
        });
      });
    });
    _particleController.forward().then((_) {
      _particleController.reset();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _particleController]),
        builder: (context, child) {
          return Stack(
            children: [
              // Particle Effects
              ..._buildParticles(),
              // Main Celebration Message
              Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: 1.0 - _fadeAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: Colors.yellow,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.message,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Keep it up!',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final particleProgress = _particleController.value;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30.0) * (3.14159 / 180.0);
      final distance = 100 * particleProgress;
      final x = 50.w + (distance * cos(angle));
      final y = 50.h + (distance * sin(angle));

      particles.add(
        Positioned(
          left: x - 2.w,
          top: y - 2.w,
          child: Opacity(
            opacity: 1.0 - particleProgress,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: i % 2 == 0
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    return particles;
  }

  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);
}

// Import math for trigonometric functions
