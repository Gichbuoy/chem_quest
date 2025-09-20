import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CatMascotWidget extends StatefulWidget {
  final int streakCount;
  final int experiencePoints;
  final String mood;

  const CatMascotWidget({
    Key? key,
    required this.streakCount,
    required this.experiencePoints,
    required this.mood,
  }) : super(key: key);

  @override
  State<CatMascotWidget> createState() => _CatMascotWidgetState();
}

class _CatMascotWidgetState extends State<CatMascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getCatImageUrl() {
    switch (widget.mood) {
      case 'happy':
        return 'https://images.pexels.com/photos/1170986/pexels-photo-1170986.jpeg?auto=compress&cs=tinysrgb&w=400';
      case 'excited':
        return 'https://images.pexels.com/photos/2071882/pexels-photo-2071882.jpeg?auto=compress&cs=tinysrgb&w=400';
      case 'sleepy':
        return 'https://images.pexels.com/photos/1741205/pexels-photo-1741205.jpeg?auto=compress&cs=tinysrgb&w=400';
      default:
        return 'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=400';
    }
  }

  Color _getMoodColor() {
    switch (widget.mood) {
      case 'happy':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'excited':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'sleepy':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getMoodColor().withValues(alpha: 0.1),
            _getMoodColor().withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getMoodColor(),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: _getCatImageUrl(),
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Chemistry Explorer!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: _getMoodColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'local_fire_department',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.streakCount} day streak',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'stars',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.experiencePoints} XP',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
