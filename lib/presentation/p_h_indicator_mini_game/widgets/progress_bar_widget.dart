import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressBarWidget extends StatelessWidget {
  final int completedItems;
  final int totalItems;
  final int streak;

  const ProgressBarWidget({
    Key? key,
    required this.completedItems,
    required this.totalItems,
    this.streak = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;
    final remainingItems = totalItems - completedItems;

    return Positioned(
      top: 12.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
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
            // Progress Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress: $completedItems/$totalItems',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                if (streak > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '$streak',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            // Progress Bar
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Progress Fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: (92.w - 6.w) * progress,
                    height: 1.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Progress Indicator
                  if (progress > 0)
                    Positioned(
                      left: ((92.w - 6.w) * progress) - 1.w,
                      top: -0.5.h,
                      child: Container(
                        width: 2.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            // Remaining Items
            Text(
              remainingItems > 0
                  ? '$remainingItems items remaining'
                  : 'All items completed!',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
