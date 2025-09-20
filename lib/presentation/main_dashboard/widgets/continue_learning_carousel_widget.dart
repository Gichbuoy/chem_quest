import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContinueLearningCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lessons;
  final Function(Map<String, dynamic>) onLessonTap;

  const ContinueLearningCarouselWidget({
    Key? key,
    required this.lessons,
    required this.onLessonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'play_circle_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Continue Learning',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return _buildLessonCard(lesson, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson, int index) {
    final String title = lesson['title'] as String? ?? 'Chemistry Lesson';
    final String description =
        lesson['description'] as String? ?? 'Learn chemistry concepts';
    final String thumbnailUrl = lesson['thumbnailUrl'] as String? ?? '';
    final double progress = (lesson['progress'] as num?)?.toDouble() ?? 0.0;
    final String duration = lesson['duration'] as String? ?? '5 min';
    final String topic = lesson['topic'] as String? ?? 'General';

    Color _getTopicColor() {
      switch (topic.toLowerCase()) {
        case 'ph indicators':
          return const Color(0xFF4CAF50);
        case 'stoichiometry':
          return const Color(0xFF2196F3);
        case 'organic chemistry':
          return const Color(0xFFFF9800);
        default:
          return AppTheme.lightTheme.colorScheme.primary;
      }
    }

    return GestureDetector(
      onTap: () => onLessonTap(lesson),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: index < lessons.length - 1 ? 3.w : 0),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.mediumRadius),
                    topRight: Radius.circular(AppTheme.mediumRadius),
                  ),
                  child: thumbnailUrl.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: thumbnailUrl,
                          width: double.infinity,
                          height: 12.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 12.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getTopicColor().withValues(alpha: 0.3),
                                _getTopicColor().withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'science',
                              color: _getTopicColor(),
                              size: 32,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 1.h,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          duration,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (progress > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getTopicColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getTopicColor().withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Text(
                        topic,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getTopicColor(),
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Expanded(
                            child: Text(
                              description,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (progress > 0)
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: _getTopicColor(),
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${progress.toInt()}% complete',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getTopicColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
