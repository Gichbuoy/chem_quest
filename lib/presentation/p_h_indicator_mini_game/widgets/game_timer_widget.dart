import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isRunning;

  const GameTimerWidget({
    Key? key,
    required this.remainingSeconds,
    this.isRunning = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final isLowTime = remainingSeconds <= 30;

    return Positioned(
      top: 6.h,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isLowTime
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.9)
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLowTime
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'timer',
              color: isLowTime
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isLowTime
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: isLowTime ? 16.sp : 14.sp,
                  ) ??
                  const TextStyle(),
              child: Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
