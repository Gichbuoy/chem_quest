import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class ChemicalEquationWidget extends StatelessWidget {
  final Map<String, dynamic> equation;
  final Map<String, String> userInputs;
  final Function(String, String) onCoefficientChanged;
  final Map<String, bool> validationResults;
  final String? selectedCompoundId;

  const ChemicalEquationWidget({
    Key? key,
    required this.equation,
    required this.userInputs,
    required this.onCoefficientChanged,
    required this.validationResults,
    this.selectedCompoundId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Balance the Chemical Equation',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'touch_app',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Tap to select',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildEquationDisplay(),
          SizedBox(height: 2.h),
          Text(
            equation['description'] as String? ??
                'Complete the stoichiometric calculation',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquationDisplay() {
    final reactants = equation['reactants'] as List<dynamic>? ?? [];
    final products = equation['products'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._buildCompounds(reactants, true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          ..._buildCompounds(products, false),
        ],
      ),
    );
  }

  List<Widget> _buildCompounds(List<dynamic> compounds, bool isReactant) {
    List<Widget> widgets = [];

    for (int i = 0; i < compounds.length; i++) {
      final compound = compounds[i] as Map<String, dynamic>;
      final compoundId = compound['id'] as String;

      if (i > 0) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              '+',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        );
      }

      widgets.add(_buildCompoundWithCoefficient(compound, compoundId));
    }

    return widgets;
  }

  Widget _buildCompoundWithCoefficient(
      Map<String, dynamic> compound, String compoundId) {
    final needsCoefficient = compound['needsCoefficient'] as bool? ?? false;
    final formula = compound['formula'] as String? ?? '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (needsCoefficient) ...[
          _buildClickableCoefficientInput(compoundId),
          SizedBox(width: 1.w),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            formula,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClickableCoefficientInput(String compoundId) {
    final currentValue = userInputs[compoundId] ?? '';
    final isValid = validationResults[compoundId];
    final isSelected = selectedCompoundId == compoundId;

    Color borderColor = AppTheme.lightTheme.colorScheme.outline;
    Color backgroundColor = AppTheme.lightTheme.colorScheme.surface;

    if (isSelected) {
      borderColor = AppTheme.lightTheme.primaryColor;
      backgroundColor = AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1);
    } else if (isValid == true) {
      borderColor = AppTheme.lightTheme.colorScheme.tertiary;
      backgroundColor =
          AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
    } else if (isValid == false) {
      borderColor = AppTheme.lightTheme.colorScheme.error;
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
    } else if (currentValue.isNotEmpty) {
      borderColor = AppTheme.lightTheme.colorScheme.secondary;
      backgroundColor =
          AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: () {
        // Add haptic feedback for better user experience
        HapticFeedback.selectionClick();
        // Trigger the callback to select this coefficient input
        onCoefficientChanged(compoundId, currentValue);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                currentValue.isEmpty ? '?' : currentValue,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: currentValue.isEmpty
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5)
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isSelected)
              Positioned(
                top: 0.5.h,
                right: 1.w,
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: Colors.white,
                    size: 8,
                  ),
                ),
              ),
            if (currentValue.isEmpty && !isSelected)
              Positioned(
                bottom: 0.5.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'TAP',
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
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
