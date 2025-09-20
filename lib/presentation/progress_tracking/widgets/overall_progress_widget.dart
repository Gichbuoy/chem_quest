import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OverallProgressWidget extends StatefulWidget {
  const OverallProgressWidget({Key? key}) : super(key: key);

  @override
  State<OverallProgressWidget> createState() => _OverallProgressWidgetState();
}

class _OverallProgressWidgetState extends State<OverallProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  late AnimationController _catAnimationController;
  late Animation<double> _catScaleAnimation;

  final double _overallMastery = 74.0;
  final int _totalLessonsCompleted = 45;
  final int _totalLessons = 60;
  final int _totalMinigamesPlayed = 128;
  final double _averageAccuracy = 87.5;

  @override
  void initState() {
    super.initState();

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: _overallMastery / 100,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _catAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _catScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _catAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _progressAnimationController.forward();

    // Animate cat based on progress level
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _catAnimationController.forward().then((_) {
          _catAnimationController.reverse();
        });
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
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
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProgressHeader(),
          SizedBox(height: 4.h),
          _buildCircularProgress(),
          SizedBox(height: 4.h),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chemistry Mastery',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Your overall progress across all topics',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        AnimatedBuilder(
          animation: _catScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _catScaleAnimation.value,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getCatMoodColor().withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'pets',
                  color: _getCatMoodColor(),
                  size: 8.w,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircularProgress() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(_overallMastery),
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _getProgressColor(_overallMastery),
                    ),
                  );
                },
              ),
              Text(
                'Complete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Lessons',
            '$_totalLessonsCompleted/$_totalLessons',
            'menu_book',
            AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            'Games Played',
            _totalMinigamesPlayed.toString(),
            'sports_esports',
            AppTheme.lightTheme.colorScheme.secondary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            'Avg Accuracy',
            '${_averageAccuracy.toInt()}%',
            'target',
            AppTheme.successLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 5.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) {
      return AppTheme.successLight;
    } else if (progress >= 60) {
      return AppTheme.lightTheme.primaryColor;
    } else if (progress >= 40) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  Color _getCatMoodColor() {
    if (_overallMastery >= 80) {
      return AppTheme.successLight; // Happy cat
    } else if (_overallMastery >= 60) {
      return AppTheme.lightTheme.primaryColor; // Proud cat
    } else if (_overallMastery >= 40) {
      return AppTheme.warningLight; // Encouraging cat
    } else {
      return AppTheme.lightTheme.colorScheme.secondary; // Motivating cat
    }
  }
}
