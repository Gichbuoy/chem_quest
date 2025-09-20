import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InteractiveDemoWidget extends StatefulWidget {
  final String demoType;

  const InteractiveDemoWidget({
    Key? key,
    required this.demoType,
  }) : super(key: key);

  @override
  State<InteractiveDemoWidget> createState() => _InteractiveDemoWidgetState();
}

class _InteractiveDemoWidgetState extends State<InteractiveDemoWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDragging = false;
  Offset _dragPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.normalAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startDemo();
  }

  void _startDemo() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _animationController.forward().then((_) {
          _animationController.reverse().then((_) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) _startDemo();
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.demoType) {
      case 'drag_drop':
        return _buildDragDropDemo();
      case 'badge_system':
        return _buildBadgeSystemDemo();
      default:
        return Container();
    }
  }

  Widget _buildDragDropDemo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          // pH Scale background
          Positioned(
            left: 10.w,
            top: 2.h,
            child: Container(
              width: 70.w,
              height: 3.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  7,
                  (index) => Text(
                    '${index * 2}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Draggable liquid sample
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideAnimation.value * 100,
                child: Positioned(
                  left: 15.w,
                  bottom: 2.h,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: GestureDetector(
                          onPanStart: (details) {
                            setState(() => _isDragging = true);
                          },
                          onPanEnd: (details) {
                            setState(() => _isDragging = false);
                          },
                          child: Container(
                            width: 12.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.colorScheme.shadow,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'science',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 4.w,
                                ),
                                Text(
                                  'H₂O',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Instruction text
          Positioned(
            bottom: 0.5.h,
            left: 0,
            right: 0,
            child: Text(
              'Drag the liquid to test its pH level!',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeSystemDemo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge showcase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBadge('pH Master', 'science', true),
              _buildBadge('Molecule Builder', 'build', false),
              _buildBadge('Speed Demon', 'flash_on', false),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Container(
            width: 70.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.3 + (_animationController.value * 0.4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Level 3 - Chemistry Apprentice',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, String iconName, bool isEarned) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isEarned ? _scaleAnimation.value : 1.0,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isEarned
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  boxShadow: isEarned
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isEarned
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.outline,
                  size: 6.w,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 8.sp,
            color: isEarned
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            fontWeight: isEarned ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
