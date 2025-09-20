import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopicMasteryWidget extends StatefulWidget {
  const TopicMasteryWidget({Key? key}) : super(key: key);

  @override
  State<TopicMasteryWidget> createState() => _TopicMasteryWidgetState();
}

class _TopicMasteryWidgetState extends State<TopicMasteryWidget> {
  bool _isExpanded = false;
  int? _selectedTopicIndex;

  final List<Map<String, dynamic>> _topicData = [
    {
      "topic": "pH Indicators",
      "completion": 85,
      "timeSpent": "12h 30m",
      "accuracy": 92,
      "improvement": "+15%",
      "color": AppTheme.lightTheme.primaryColor,
      "difficulty": "Intermediate"
    },
    {
      "topic": "Stoichiometry",
      "completion": 72,
      "timeSpent": "8h 45m",
      "accuracy": 88,
      "improvement": "+8%",
      "color": AppTheme.lightTheme.colorScheme.secondary,
      "difficulty": "Advanced"
    },
    {
      "topic": "Organic Chemistry",
      "completion": 64,
      "timeSpent": "6h 15m",
      "accuracy": 76,
      "improvement": "+12%",
      "color": AppTheme.warningLight,
      "difficulty": "Beginner"
    }
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
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: CustomIconWidget(
                iconName: 'bar_chart',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topic Mastery',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Track your progress across chemistry topics',
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
          _buildTopicBars(),
          if (_selectedTopicIndex != null) _buildDetailedBreakdown(),
        ],
      ),
    );
  }

  Widget _buildTopicBars() {
    return Column(
      children: _topicData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> topic = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      topic["topic"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(topic["difficulty"])
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      topic["difficulty"],
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getDifficultyColor(topic["difficulty"]),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${topic["completion"]}%',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: topic["color"],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTopicIndex =
                        _selectedTopicIndex == index ? null : index;
                  });
                },
                child: Container(
                  height: 1.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: AppTheme.normalAnimation,
                        width: (topic["completion"] / 100) * 82.w,
                        decoration: BoxDecoration(
                          color: topic["color"],
                          borderRadius:
                              BorderRadius.circular(AppTheme.smallRadius),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedBreakdown() {
    if (_selectedTopicIndex == null) return const SizedBox.shrink();

    final selectedTopic = _topicData[_selectedTopicIndex!];

    return AnimatedContainer(
      duration: AppTheme.normalAnimation,
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: selectedTopic["color"].withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: selectedTopic["color"].withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedTopic["topic"]} Details',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: selectedTopic["color"],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Time Spent',
                  selectedTopic["timeSpent"],
                  'access_time',
                  selectedTopic["color"],
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Accuracy',
                  '${selectedTopic["accuracy"]}%',
                  'target',
                  selectedTopic["color"],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Improvement',
                  selectedTopic["improvement"],
                  'trending_up',
                  AppTheme.successLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Completion',
                  '${selectedTopic["completion"]}%',
                  'check_circle',
                  selectedTopic["color"],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successLight;
      case 'intermediate':
        return AppTheme.warningLight;
      case 'advanced':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
