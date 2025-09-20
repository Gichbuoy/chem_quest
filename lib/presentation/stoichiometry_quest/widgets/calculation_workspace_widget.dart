import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CalculationWorkspaceWidget extends StatefulWidget {
  final bool isExpanded;
  final Map<String, dynamic> currentProblem;
  final VoidCallback onToggle;
  final Function(String) onStepCompleted;

  const CalculationWorkspaceWidget({
    Key? key,
    required this.isExpanded,
    required this.currentProblem,
    required this.onToggle,
    required this.onStepCompleted,
  }) : super(key: key);

  @override
  State<CalculationWorkspaceWidget> createState() =>
      _CalculationWorkspaceWidgetState();
}

class _CalculationWorkspaceWidgetState extends State<CalculationWorkspaceWidget>
    with TickerProviderStateMixin {
  late AnimationController _expansionController;
  late Animation<double> _expansionAnimation;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _expansionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(CalculationWorkspaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expansionController.forward();
      } else {
        _expansionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expansionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expansionAnimation,
      builder: (context, child) {
        return Container(
          height: _expansionAnimation.value * 50.h,
          child:
              _expansionAnimation.value > 0 ? _buildWorkspaceContent() : null,
        );
      },
    );
  }

  Widget _buildWorkspaceContent() {
    return Container(
      width: double.infinity,
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
        children: [
          _buildWorkspaceHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: _buildStepByStepGuide(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
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
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Step-by-Step Solution',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onToggle,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepByStepGuide() {
    final steps = _getCalculationSteps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Problem: ${widget.currentProblem['description'] ?? 'Balance the chemical equation'}',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 3.h),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return _buildStepCard(index, step);
        }).toList(),
      ],
    );
  }

  Widget _buildStepCard(int index, Map<String, dynamic> step) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final isLocked = index > currentStep;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : isCurrent
                ? AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppTheme.lightTheme.colorScheme.tertiary
              : isCurrent
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
          width: isCompleted || isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : isCurrent
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  step['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isLocked
                        ? AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5)
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            step['description'] as String,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: isLocked
                  ? AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5)
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
            ),
          ),
          if (step['formula'] != null) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                step['formula'] as String,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (isCurrent && !isCompleted) ...[
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep++;
                });
                widget.onStepCompleted(step['id'] as String);
              },
              child: Text('Complete Step'),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getCalculationSteps() {
    return [
      {
        'id': 'step1',
        'title': 'Identify the Reaction Type',
        'description':
            'Determine what type of chemical reaction this is and identify the reactants and products.',
        'formula': null,
      },
      {
        'id': 'step2',
        'title': 'Count Atoms on Each Side',
        'description':
            'Count the number of atoms of each element on both the reactant and product sides.',
        'formula': null,
      },
      {
        'id': 'step3',
        'title': 'Start with Complex Molecules',
        'description':
            'Begin balancing with the most complex molecule or the one with the most elements.',
        'formula': null,
      },
      {
        'id': 'step4',
        'title': 'Balance One Element at a Time',
        'description':
            'Work through each element systematically, adjusting coefficients as needed.',
        'formula': 'aA + bB → cC + dD',
      },
      {
        'id': 'step5',
        'title': 'Verify the Balance',
        'description':
            'Double-check that the number of atoms of each element is equal on both sides.',
        'formula': null,
      },
    ];
  }
}