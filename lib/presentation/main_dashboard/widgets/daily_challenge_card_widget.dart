import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyChallengeCardWidget extends StatelessWidget {
  final Map<String, dynamic> challengeData;
  final VoidCallback onTap;

  const DailyChallengeCardWidget({
    Key? key,
    required this.challengeData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = challengeData['title'] as String? ?? 'Daily Challenge';
    final String description = challengeData['description'] as String? ??
        'Complete today\'s chemistry challenge';
    final String imageUrl = challengeData['imageUrl'] as String? ?? '';
    final int reward = challengeData['reward'] as int? ?? 0;
    final String difficulty =
        challengeData['difficulty'] as String? ?? 'Medium';
    final bool isCompleted = challengeData['isCompleted'] as bool? ?? false;

    Color _getDifficultyColor() {
      switch (difficulty.toLowerCase()) {
        case 'easy':
          return AppTheme.lightTheme.colorScheme.tertiary;
        case 'hard':
          return AppTheme.lightTheme.colorScheme.error;
        default:
          return AppTheme.lightTheme.colorScheme.secondary;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.mediumRadius),
                  topRight: Radius.circular(AppTheme.mediumRadius),
                ),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            borderRadius:
                                BorderRadius.circular(AppTheme.smallRadius),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color:
                                    AppTheme.lightTheme.colorScheme.onTertiary,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Completed',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor().withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppTheme.smallRadius),
                        ),
                        child: Text(
                          difficulty,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getDifficultyColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
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
                              iconName: 'stars',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '+$reward XP',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
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
      ),
    );
  }
}
