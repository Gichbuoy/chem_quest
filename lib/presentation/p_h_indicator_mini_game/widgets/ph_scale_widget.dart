import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PHScaleWidget extends StatelessWidget {
  final Function(double) onDropAccepted;
  final double? highlightedPosition;

  const PHScaleWidget({
    Key? key,
    required this.onDropAccepted,
    this.highlightedPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 12.h,
      margin: EdgeInsets.symmetric(horizontal: 7.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // pH Scale Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF0000), // Red (Acidic)
                    Color(0xFFFF4500),
                    Color(0xFFFF8C00),
                    Color(0xFFFFD700),
                    Color(0xFFFFFF00), // Yellow (Fixed)
                    Color(0xFFADFF2F),
                    Color(0xFF00FF00), // Green (Neutral)
                    Color(0xFF00CED1),
                    Color(0xFF0080FF),
                    Color(0xFF4169E1),
                    Color(0xFF8A2BE2),
                    Color(0xFF9400D3),
                    Color(0xFF4B0082),
                    Color(0xFF800080),
                    Color(0xFF000080), // Blue (Basic)
                  ],
                  stops: [
                    0.0, 0.07, 0.14, 0.21, 0.28, 0.35, 0.42, 0.49, 0.56, 0.63, 0.70, 0.77, 0.84, 0.91, 1.0
                  ],
                ),
              ),
            ),
            // pH Scale Numbers and Labels
            Positioned.fill(
              child: Row(
                children: List.generate(15, (index) {
                  final isHighlighted = highlightedPosition != null && 
                      (highlightedPosition! - index).abs() < 0.5;
                  
                  return Expanded(
                    child: DragTarget<Map<String, dynamic>>(
                      onAcceptWithDetails: (data) => onDropAccepted(index.toDouble()),
                      onWillAcceptWithDetails: (data) => true,
                      builder: (context, candidateData, rejectedData) {
                        final isHovering = candidateData.isNotEmpty;
                        
                        return Container(
                          decoration: BoxDecoration(
                            border: isHighlighted || isHovering
                                ? Border.all(
                                    color: AppTheme.lightTheme.colorScheme.primary,
                                    width: 3,
                                  )
                                : null,
                            color: isHovering
                                ? Colors.white.withValues(alpha: 0.3)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$index',
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.7),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              if (index == 0) ...[
                                SizedBox(height: 0.5.h),
                                Text(
                                  'ACIDIC',
                                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ] else if (index == 7) ...[
                                SizedBox(height: 0.5.h),
                                Text(
                                  'NEUTRAL',
                                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ] else if (index == 14) ...[
                                SizedBox(height: 0.5.h),
                                Text(
                                  'BASIC',
                                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}