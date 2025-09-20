import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CatMascotWidget extends StatefulWidget {
  final String emotion;
  final String message;

  const CatMascotWidget({
    Key? key,
    this.emotion = 'neutral',
    this.message = '',
  }) : super(key: key);

  @override
  State<CatMascotWidget> createState() => _CatMascotWidgetState();
}

class _CatMascotWidgetState extends State<CatMascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(CatMascotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.emotion != oldWidget.emotion && widget.emotion == 'happy') {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.h,
      left: 4.w,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Speech Bubble
                  if (widget.message.isNotEmpty) ...[
                    Container(
                      constraints: BoxConstraints(maxWidth: 40.w),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                  // Cat Character
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Cat Face
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Cat Ears
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              // Cat Eyes
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 1.5.w,
                                    height: 1.5.w,
                                    decoration: BoxDecoration(
                                      color: _getEyeColor(),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 1.5.w,
                                    height: 1.5.w,
                                    decoration: BoxDecoration(
                                      color: _getEyeColor(),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              // Cat Mouth
                              Container(
                                width: 2.w,
                                height: 1.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Lab Goggles
                        Positioned(
                          top: 2.w,
                          left: 1.w,
                          right: 1.w,
                          child: Container(
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getEyeColor() {
    switch (widget.emotion) {
      case 'happy':
        return Colors.green;
      case 'sad':
        return Colors.blue;
      case 'excited':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
