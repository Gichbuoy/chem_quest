import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PauseMenuWidget extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final VoidCallback onShowHints;

  const PauseMenuWidget({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
    required this.onShowHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: 80.w,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Game Paused',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              // Menu Options
              _buildMenuButton(
                icon: 'play_arrow',
                label: 'Resume Game',
                onTap: onResume,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              _buildMenuButton(
                icon: 'lightbulb',
                label: 'Show Hints',
                onTap: onShowHints,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              SizedBox(height: 2.h),
              _buildMenuButton(
                icon: 'refresh',
                label: 'Restart Game',
                onTap: onRestart,
                color: Colors.orange,
              ),
              SizedBox(height: 2.h),
              _buildMenuButton(
                icon: 'exit_to_app',
                label: 'Quit Game',
                onTap: onQuit,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              SizedBox(height: 4.h),
              // Game Rules Section
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Rules:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildRuleItem('Drag liquids to their correct pH position'),
                    _buildRuleItem('Red zone (0-6): Acidic substances'),
                    _buildRuleItem('Green zone (7): Neutral substances'),
                    _buildRuleItem('Blue zone (8-14): Basic substances'),
                    _buildRuleItem('Build streaks for bonus points!'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.only(top: 1.h, right: 2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
