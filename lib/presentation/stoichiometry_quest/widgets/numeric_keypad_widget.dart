import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class NumericKeypadWidget extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onDecimalPressed;

  const NumericKeypadWidget({
    Key? key,
    required this.onNumberPressed,
    required this.onClearPressed,
    required this.onDeletePressed,
    required this.onDecimalPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          _buildKeypadGrid(),
        ],
      ),
    );
  }

  Widget _buildKeypadGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildNumberKey('1'),
            _buildNumberKey('2'),
            _buildNumberKey('3'),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildNumberKey('4'),
            _buildNumberKey('5'),
            _buildNumberKey('6'),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildNumberKey('7'),
            _buildNumberKey('8'),
            _buildNumberKey('9'),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildActionKey(
              icon: 'clear',
              onPressed: onClearPressed,
              color: AppTheme.lightTheme.colorScheme.error,
            ),
            _buildNumberKey('0'),
            _buildActionKey(
              icon: 'backspace',
              onPressed: onDeletePressed,
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildDecimalKey(),
            _buildHintKey(),
            _buildSubmitKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberKey(String number) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onNumberPressed(number),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required String icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecimalKey() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDecimalPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '.',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintKey() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Hint functionality can be implemented
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'lightbulb',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitKey() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Submit functionality handled by parent
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.secondary,
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}