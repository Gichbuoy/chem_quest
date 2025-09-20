import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LiquidContainerWidget extends StatelessWidget {
  final Map<String, dynamic> liquidData;
  final bool isDragging;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  const LiquidContainerWidget({
    Key? key,
    required this.liquidData,
    this.isDragging = false,
    this.onDragStarted,
    this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, dynamic>>(
      data: liquidData,
      onDragStarted: onDragStarted,
      onDragEnd: (_) => onDragEnd?.call(),
      feedback: _buildContainer(context, isFloating: true),
      childWhenDragging: _buildContainer(context, isDragging: true),
      child: _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context,
      {bool isFloating = false, bool isDragging = false}) {
    final opacity = isDragging ? 0.5 : 1.0;
    final scale = isFloating ? 1.1 : 1.0;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 18.w,
          height: 18.w,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: isFloating ? 12 : 6,
                offset: Offset(0, isFloating ? 6 : 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Container Background
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                ),
              ),
              // Liquid Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                    imageUrl: liquidData['image'] as String,
                    width: 18.w,
                    height: 18.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Liquid Color Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _getLiquidColor().withValues(alpha: 0.3),
                  ),
                ),
              ),
              // Label
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    liquidData['name'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLiquidColor() {
    final ph = liquidData['ph'] as double;
    if (ph < 3) return Colors.red;
    if (ph < 5) return Colors.orange;
    if (ph < 6) return Colors.yellow;
    if (ph < 8) return Colors.green;
    if (ph < 10) return Colors.lightBlue;
    if (ph < 12) return Colors.blue;
    return Colors.purple;
  }
}
