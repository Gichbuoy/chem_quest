import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicatorWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: AppTheme.normalAnimation,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: index == currentPage ? 8.w : 4.w,
          height: 1.h,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
