import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievements_widget.dart';
import './widgets/overall_progress_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/streak_tracking_widget.dart';
import './widgets/topic_mastery_widget.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({Key? key}) : super(key: key);

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;
  late TabController _tabController;

  final List<String> _viewOptions = ['Weekly', 'Monthly'];
  int _selectedViewIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text('Progress data updated successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    _buildViewToggle(),
                    SizedBox(height: 2.h),
                    const OverallProgressWidget(),
                    SizedBox(height: 2.h),
                    const StreakTrackingWidget(),
                    SizedBox(height: 2.h),
                    const TopicMasteryWidget(),
                    SizedBox(height: 2.h),
                    const RecentActivityWidget(),
                    SizedBox(height: 2.h),
                    const AchievementsWidget(),
                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimaryLight,
          size: 6.w,
        ),
      ),
      title: Text(
        'Progress Tracking',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryLight,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showProgressInsights,
          icon: CustomIconWidget(
            iconName: 'insights',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: _showShareProgress,
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.textSecondaryLight,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: Row(
        children: _viewOptions.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          bool isSelected = index == _selectedViewIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedViewIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: AppTheme.normalAnimation,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color:
                        isSelected ? Colors.white : AppTheme.textSecondaryLight,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('Dashboard', 'dashboard', false, '/main-dashboard'),
              _buildNavItem(
                  'pH Game', 'science', false, '/p-h-indicator-mini-game'),
              _buildNavItem(
                  'Stoichiometry', 'calculate', false, '/stoichiometry-quest'),
              _buildNavItem(
                  'Progress', 'trending_up', true, '/progress-tracking'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String label, String iconName, bool isActive, String route) {
    return GestureDetector(
      onTap: isActive ? null : () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressInsights() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.largeRadius),
            topRight: Radius.circular(AppTheme.largeRadius),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Insights',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildInsightCard(
                    'Strongest Topic',
                    'pH Indicators',
                    '85% mastery',
                    'science',
                    AppTheme.successLight,
                  ),
                  SizedBox(height: 2.h),
                  _buildInsightCard(
                    'Needs Improvement',
                    'Organic Chemistry',
                    '64% mastery',
                    'hub',
                    AppTheme.warningLight,
                  ),
                  SizedBox(height: 2.h),
                  _buildInsightCard(
                    'Best Learning Time',
                    'Evening Sessions',
                    '92% avg accuracy',
                    'schedule',
                    AppTheme.lightTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String subtitle, String value,
      String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: Colors.white,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareProgress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Share Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Share your chemistry learning progress with friends and family!',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Progress shared successfully!'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }
}
