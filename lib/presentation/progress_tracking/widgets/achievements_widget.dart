import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementsWidget extends StatefulWidget {
  const AchievementsWidget({Key? key}) : super(key: key);

  @override
  State<AchievementsWidget> createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  bool _isExpanded = false;
  int? _selectedBadgeIndex;

  final List<Map<String, dynamic>> _achievements = [
    {
      "id": 1,
      "title": "pH Master",
      "description": "Complete 50 pH indicator challenges with 90%+ accuracy",
      "icon": "science",
      "color": AppTheme.lightTheme.primaryColor,
      "earned": true,
      "progress": 100,
      "earnedDate": DateTime.now().subtract(const Duration(days: 5)),
      "category": "pH Indicators",
      "rarity": "Epic"
    },
    {
      "id": 2,
      "title": "Speed Demon",
      "description":
          "Complete any mini-game in under 3 minutes with perfect score",
      "icon": "flash_on",
      "color": AppTheme.lightTheme.colorScheme.secondary,
      "earned": true,
      "progress": 100,
      "earnedDate": DateTime.now().subtract(const Duration(days: 12)),
      "category": "Speed",
      "rarity": "Legendary"
    },
    {
      "id": 3,
      "title": "Molecule Architect",
      "description": "Build 25 complex organic molecules correctly",
      "icon": "hub",
      "color": AppTheme.warningLight,
      "earned": true,
      "progress": 100,
      "earnedDate": DateTime.now().subtract(const Duration(days: 18)),
      "category": "Organic Chemistry",
      "rarity": "Rare"
    },
    {
      "id": 4,
      "title": "Streak Master",
      "description": "Maintain a 30-day learning streak",
      "icon": "local_fire_department",
      "color": AppTheme.errorLight,
      "earned": false,
      "progress": 73,
      "earnedDate": null,
      "category": "Consistency",
      "rarity": "Epic"
    },
    {
      "id": 5,
      "title": "Chemistry Scholar",
      "description": "Complete all lesson modules with 95%+ comprehension",
      "icon": "school",
      "color": AppTheme.successLight,
      "earned": false,
      "progress": 68,
      "earnedDate": null,
      "category": "Learning",
      "rarity": "Rare"
    },
    {
      "id": 6,
      "title": "Perfect Balance",
      "description": "Balance 100 chemical equations without mistakes",
      "icon": "balance",
      "color": AppTheme.infoLight,
      "earned": false,
      "progress": 45,
      "earnedDate": null,
      "category": "Stoichiometry",
      "rarity": "Common"
    },
    {
      "id": 7,
      "title": "Cat Whisperer",
      "description": "Unlock all cat mascot animations and interactions",
      "icon": "pets",
      "color": Color(0xFFFF69B4),
      "earned": true,
      "progress": 100,
      "earnedDate": DateTime.now().subtract(const Duration(days: 3)),
      "category": "Fun",
      "rarity": "Special"
    },
    {
      "id": 8,
      "title": "Lab Safety Expert",
      "description": "Complete safety quiz with 100% score 5 times",
      "icon": "security",
      "color": AppTheme.lightTheme.primaryColor,
      "earned": false,
      "progress": 80,
      "earnedDate": null,
      "category": "Safety",
      "rarity": "Common"
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
    final earnedCount = _achievements
        .where((achievement) => achievement["earned"] == true)
        .length;

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
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.successLight,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$earnedCount of ${_achievements.length} badges earned',
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
          _buildAchievementGrid(),
          if (_selectedBadgeIndex != null) _buildBadgeDetails(),
        ],
      ),
    );
  }

  Widget _buildAchievementGrid() {
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.8,
        ),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          return _buildAchievementBadge(achievement, index);
        },
      ),
    );
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement, int index) {
    final isEarned = achievement["earned"] as bool;
    final progress = achievement["progress"] as int;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBadgeIndex = _selectedBadgeIndex == index ? null : index;
        });
      },
      onLongPress: isEarned ? () => _showShareDialog(achievement) : null,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: isEarned
                      ? achievement["color"]
                      : AppTheme.textSecondaryLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  boxShadow: isEarned
                      ? [
                          BoxShadow(
                            color: achievement["color"].withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: achievement["icon"],
                    color:
                        isEarned ? Colors.white : AppTheme.textSecondaryLight,
                    size: 7.w,
                  ),
                ),
              ),
              if (!isEarned)
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 2,
                    backgroundColor:
                        AppTheme.textSecondaryLight.withValues(alpha: 0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(achievement["color"]),
                  ),
                ),
              if (isEarned)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: AppTheme.successLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            achievement["title"],
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isEarned
                  ? AppTheme.textPrimaryLight
                  : AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeDetails() {
    if (_selectedBadgeIndex == null) return const SizedBox.shrink();

    final selectedBadge = _achievements[_selectedBadgeIndex!];
    final isEarned = selectedBadge["earned"] as bool;

    return AnimatedContainer(
      duration: AppTheme.normalAnimation,
      margin: EdgeInsets.only(top: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: selectedBadge["color"].withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: selectedBadge["color"].withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isEarned
                      ? selectedBadge["color"]
                      : AppTheme.textSecondaryLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: selectedBadge["icon"],
                    color:
                        isEarned ? Colors.white : AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedBadge["title"],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: selectedBadge["color"],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getRarityColor(selectedBadge["rarity"])
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            selectedBadge["rarity"],
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getRarityColor(selectedBadge["rarity"]),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      selectedBadge["category"],
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            selectedBadge["description"],
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 2.h),
          if (isEarned) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.successLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Earned on ${_formatDate(selectedBadge["earnedDate"])}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: selectedBadge["progress"] / 100,
                    backgroundColor:
                        AppTheme.textSecondaryLight.withValues(alpha: 0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(selectedBadge["color"]),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  '${selectedBadge["progress"]}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: selectedBadge["color"],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showShareDialog(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Achievement'),
          content:
              Text('Share your "${achievement["title"]}" badge with friends?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement sharing functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Achievement shared successfully!'),
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

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return AppTheme.textSecondaryLight;
      case 'rare':
        return AppTheme.infoLight;
      case 'epic':
        return AppTheme.lightTheme.primaryColor;
      case 'legendary':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'special':
        return Color(0xFFFF69B4);
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}
