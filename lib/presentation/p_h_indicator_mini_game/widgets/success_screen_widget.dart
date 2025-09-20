import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuccessScreenWidget extends StatefulWidget {
  final int score;
  final double accuracy;
  final int timeCompleted;
  final List<String> earnedBadges;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToDashboard;
  final VoidCallback onShare;

  const SuccessScreenWidget({
    Key? key,
    required this.score,
    required this.accuracy,
    required this.timeCompleted,
    required this.earnedBadges,
    required this.onPlayAgain,
    required this.onBackToDashboard,
    required this.onShare,
  }) : super(key: key);

  @override
  State<SuccessScreenWidget> createState() => _SuccessScreenWidgetState();
}

class _SuccessScreenWidgetState extends State<SuccessScreenWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _badgeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _badgeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _badgeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _badgeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = widget.timeCompleted ~/ 60;
    final seconds = widget.timeCompleted % 60;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              // Success Icon and Title
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'emoji_events',
                  color: Colors.white,
                  size: 48,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Congratulations!',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'You completed the pH Indicator Mini-Game!',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: 'stars',
                      title: 'Score',
                      value: '${widget.score}',
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildStatCard(
                      icon: 'target',
                      title: 'Accuracy',
                      value: '${widget.accuracy.toStringAsFixed(1)}%',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              _buildStatCard(
                icon: 'timer',
                title: 'Time Completed',
                value:
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                color: Colors.green,
                isFullWidth: true,
              ),
              SizedBox(height: 4.h),
              // Earned Badges
              if (widget.earnedBadges.isNotEmpty) ...[
                Text(
                  'Earned Badges',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                AnimatedBuilder(
                  animation: _badgeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _badgeAnimation.value,
                      child: Wrap(
                        spacing: 3.w,
                        runSpacing: 2.h,
                        alignment: WrapAlignment.center,
                        children: widget.earnedBadges
                            .map((badge) => _buildBadge(badge))
                            .toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
              ],
              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Play Again',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onShare,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBackToDashboard,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onSurface,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'home',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Dashboard'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String badgeName) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: _getBadgeIcon(badgeName),
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            badgeName,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getBadgeIcon(String badgeName) {
    switch (badgeName.toLowerCase()) {
      case 'speed demon':
        return 'flash_on';
      case 'perfectionist':
        return 'star';
      case 'streak master':
        return 'local_fire_department';
      case 'chemistry expert':
        return 'science';
      default:
        return 'emoji_events';
    }
  }
}
