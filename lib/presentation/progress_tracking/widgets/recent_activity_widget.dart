import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({Key? key}) : super(key: key);

  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "gameType": "pH Indicators",
      "icon": "science",
      "score": 850,
      "accuracy": 94,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "duration": "8 min",
      "achievement": "Perfect Score!",
      "color": AppTheme.lightTheme.primaryColor,
    },
    {
      "id": 2,
      "gameType": "Stoichiometry Quest",
      "icon": "calculate",
      "score": 720,
      "accuracy": 88,
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "duration": "12 min",
      "achievement": "Speed Master",
      "color": AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      "id": 3,
      "gameType": "Molecule Builder",
      "icon": "hub",
      "score": 650,
      "accuracy": 82,
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      "duration": "15 min",
      "achievement": null,
      "color": AppTheme.warningLight,
    },
    {
      "id": 4,
      "gameType": "pH Indicators",
      "icon": "science",
      "score": 780,
      "accuracy": 91,
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      "duration": "10 min",
      "achievement": "Streak Builder",
      "color": AppTheme.lightTheme.primaryColor,
    },
    {
      "id": 5,
      "gameType": "Stoichiometry Quest",
      "icon": "calculate",
      "score": 590,
      "accuracy": 76,
      "timestamp": DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      "duration": "18 min",
      "achievement": null,
      "color": AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      "id": 6,
      "gameType": "Molecule Builder",
      "icon": "hub",
      "score": 820,
      "accuracy": 95,
      "timestamp": DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      "duration": "11 min",
      "achievement": "Chemistry Master",
      "color": AppTheme.warningLight,
    },
    {
      "id": 7,
      "gameType": "pH Indicators",
      "icon": "science",
      "score": 710,
      "accuracy": 86,
      "timestamp": DateTime.now().subtract(const Duration(days: 4, hours: 1)),
      "duration": "9 min",
      "achievement": null,
      "color": AppTheme.lightTheme.primaryColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
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
          _buildHeader(),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Last 7 days of learning sessions',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: AppTheme.normalAnimation,
              child: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.textSecondaryLight,
                size: 6.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return AnimatedContainer(
      duration: AppTheme.normalAnimation,
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        children: [
          _buildActivityTimeline(),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    return Container(
      constraints: BoxConstraints(maxHeight: 50.h),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _recentActivities.length,
        itemBuilder: (context, index) {
          final activity = _recentActivities[index];
          final isLast = index == _recentActivities.length - 1;

          return _buildActivityItem(activity, isLast);
        },
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: activity["color"],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activity["color"].withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: activity["icon"],
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 6.h,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: activity["color"].withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                border: Border.all(
                  color: activity["color"].withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity["gameType"],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: activity["color"],
                          ),
                        ),
                      ),
                      Text(
                        _formatTimestamp(activity["timestamp"]),
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildScoreChip(activity["score"], activity["color"]),
                      SizedBox(width: 2.w),
                      _buildAccuracyChip(activity["accuracy"]),
                      SizedBox(width: 2.w),
                      _buildDurationChip(activity["duration"]),
                    ],
                  ),
                  if (activity["achievement"] != null) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'emoji_events',
                            color: AppTheme.successLight,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            activity["achievement"],
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(int score, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'stars',
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            score.toString(),
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyChip(int accuracy) {
    Color accuracyColor = accuracy >= 90
        ? AppTheme.successLight
        : accuracy >= 80
            ? AppTheme.warningLight
            : AppTheme.errorLight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: accuracyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'target',
            color: accuracyColor,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            '$accuracy%',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: accuracyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip(String duration) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.textSecondaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: AppTheme.textSecondaryLight,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            duration,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
