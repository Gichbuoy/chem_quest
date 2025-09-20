import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? mascotText;
  final Widget? interactiveDemo;
  final bool showSkip;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool isLastPage;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.mascotText,
    this.interactiveDemo,
    this.showSkip = true,
    this.onNext,
    this.onSkip,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Skip button
            if (showSkip && !isLastPage)
              Positioned(
                top: 2.h,
                right: 4.w,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),

            // Main content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                children: [
                  SizedBox(height: 4.h),

                  // Main illustration
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 80.w,
                      child: CustomImageWidget(
                        imageUrl: imageUrl,
                        width: 80.w,
                        height: 35.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Interactive demo section
                  if (interactiveDemo != null)
                    Container(
                      height: 15.h,
                      width: 85.w,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      child: interactiveDemo,
                    ),

                  // Text content
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Description
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 14.sp,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),

                        // Mascot speech bubble
                        if (mascotText != null) ...[
                          SizedBox(height: 3.h),
                          Container(
                            padding: EdgeInsets.all(4.w),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'pets',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 4.w,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    mascotText!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      fontSize: 12.sp,
                                      fontStyle: FontStyle.italic,
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Next button
                  Container(
                    width: double.infinity,
                    height: 6.h,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isLastPage ? 'Get Started' : 'Next',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
