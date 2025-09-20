import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameModeTileWidget extends StatelessWidget {
  final Map<String, dynamic> gameData;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GameModeTileWidget({
    Key? key,
    required this.gameData,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = gameData['title'] as String? ?? 'Game Mode';
    final String description =
        gameData['description'] as String? ?? 'Learn chemistry concepts';
    final String iconName = gameData['iconName'] as String? ?? 'science';
    final double completionPercentage =
        (gameData['completionPercentage'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> badges = gameData['badges'] as List<dynamic>? ?? [];
    final String difficulty = gameData['difficulty'] as String? ?? 'Beginner';
    final Color primaryColor = gameData['primaryColor'] != null
        ? Color(gameData['primaryColor'] as int)
        : AppTheme.lightTheme.colorScheme.primary;

    Color _getDifficultyColor() {
      switch (difficulty.toLowerCase()) {
        case 'beginner':
          return AppTheme.lightTheme.colorScheme.tertiary;
        case 'intermediate':
          return AppTheme.lightTheme.colorScheme.secondary;
        case 'advanced':
          return AppTheme.lightTheme.colorScheme.error;
        default:
          return AppTheme.lightTheme.colorScheme.primary;
      }
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
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
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                  ),
                  child: Text(
                    difficulty,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getDifficultyColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${completionPercentage.toInt()}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      LinearPercentIndicator(
                        width: 60.w,
                        lineHeight: 6,
                        percent: completionPercentage / 100,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        progressColor: primaryColor,
                        barRadius: const Radius.circular(3),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                if (badges.isNotEmpty)
                  Row(
                    children: [
                      for (int i = 0;
                          i < (badges.length > 3 ? 3 : badges.length);
                          i++)
                        Container(
                          margin: EdgeInsets.only(left: i > 0 ? 1.w : 0),
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'emoji_events',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 12,
                            ),
                          ),
                        ),
                      if (badges.length > 3)
                        Container(
                          margin: EdgeInsets.only(left: 1.w),
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '+${badges.length - 3}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
