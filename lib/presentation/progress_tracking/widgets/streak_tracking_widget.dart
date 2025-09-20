import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StreakTrackingWidget extends StatefulWidget {
  const StreakTrackingWidget({Key? key}) : super(key: key);

  @override
  State<StreakTrackingWidget> createState() => _StreakTrackingWidgetState();
}

class _StreakTrackingWidgetState extends State<StreakTrackingWidget>
    with TickerProviderStateMixin {
  late AnimationController _flameAnimationController;
  late Animation<double> _flameAnimation;
  late AnimationController _catAnimationController;
  late Animation<double> _catBounceAnimation;

  final int _currentStreak = 22;
  final int _longestStreak = 45;
  final bool _todayCompleted = true;

  final List<Map<String, dynamic>> _weeklyProgress = [
    {
      "day": "Mon",
      "completed": true,
      "date": DateTime.now().subtract(const Duration(days: 6))
    },
    {
      "day": "Tue",
      "completed": true,
      "date": DateTime.now().subtract(const Duration(days: 5))
    },
    {
      "day": "Wed",
      "completed": true,
      "date": DateTime.now().subtract(const Duration(days: 4))
    },
    {
      "day": "Thu",
      "completed": false,
      "date": DateTime.now().subtract(const Duration(days: 3))
    },
    {
      "day": "Fri",
      "completed": true,
      "date": DateTime.now().subtract(const Duration(days: 2))
    },
    {
      "day": "Sat",
      "completed": true,
      "date": DateTime.now().subtract(const Duration(days: 1))
    },
    {"day": "Sun", "completed": true, "date": DateTime.now()},
  ];

  @override
  void initState() {
    super.initState();

    _flameAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _flameAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _flameAnimationController,
      curve: Curves.easeInOut,
    ));

    _catAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _catBounceAnimation = Tween<double>(
      begin: 0.0,
      end: -8.0,
    ).animate(CurvedAnimation(
      parent: _catAnimationController,
      curve: Curves.elasticOut,
    ));

    _flameAnimationController.repeat(reverse: true);

    // Trigger cat animation occasionally
    _startCatAnimation();
  }

  void _startCatAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _catAnimationController.forward().then((_) {
          _catAnimationController.reverse().then((_) {
            Future.delayed(const Duration(seconds: 8), () {
              if (mounted) _startCatAnimation();
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _flameAnimationController.dispose();
    _catAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.errorLight.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStreakHeader(),
          SizedBox(height: 3.h),
          _buildWeeklyProgress(),
          SizedBox(height: 3.h),
          _buildMotivationalMessage(),
        ],
      ),
    );
  }

  Widget _buildStreakHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learning Streak',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _flameAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _flameAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppTheme.errorLight.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'local_fire_department',
                            color: Colors.white,
                            size: 8.w,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_currentStreak Days',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.errorLight,
                        ),
                      ),
                      Text(
                        'Current streak',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _catBounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _catBounceAnimation.value),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'pets',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 10.w,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'This Week',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Best: $_longestStreak days',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.successLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              _weeklyProgress.map((day) => _buildDayIndicator(day)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayIndicator(Map<String, dynamic> dayData) {
    final isCompleted = dayData["completed"] as bool;
    final isToday = _isToday(dayData["date"]);

    return Column(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.successLight
                : isToday
                    ? AppTheme.warningLight.withValues(alpha: 0.3)
                    : AppTheme.textSecondaryLight.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(
                    color: AppTheme.warningLight,
                    width: 2,
                  )
                : null,
            boxShadow: isCompleted
                ? [
                    BoxShadow(
                      color: AppTheme.successLight.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 5.w,
                  )
                : isToday
                    ? CustomIconWidget(
                        iconName: 'today',
                        color: AppTheme.warningLight,
                        size: 5.w,
                      )
                    : null,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          dayData["day"],
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            color:
                isToday ? AppTheme.warningLight : AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalMessage() {
    String message;
    String emoji;
    Color messageColor;

    if (_currentStreak >= 30) {
      message = "Incredible dedication! You're a chemistry champion! 🏆";
      emoji = "🏆";
      messageColor = AppTheme.successLight;
    } else if (_currentStreak >= 14) {
      message = "Amazing streak! Keep the momentum going! 🚀";
      emoji = "🚀";
      messageColor = AppTheme.lightTheme.primaryColor;
    } else if (_currentStreak >= 7) {
      message = "Great job! One week strong! 💪";
      emoji = "💪";
      messageColor = AppTheme.warningLight;
    } else if (_currentStreak >= 3) {
      message = "Building good habits! Keep it up! 😸";
      emoji = "😸";
      messageColor = AppTheme.lightTheme.colorScheme.secondary;
    } else {
      message = "Every day counts! Let's learn together! 🐱";
      emoji = "🐱";
      messageColor = AppTheme.textPrimaryLight;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: messageColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 6.w),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: messageColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
