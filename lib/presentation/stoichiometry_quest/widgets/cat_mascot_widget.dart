import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CatMascotWidget extends StatefulWidget {
  final String mood;
  final String message;
  final bool isVisible;

  const CatMascotWidget({
    Key? key,
    required this.mood,
    required this.message,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<CatMascotWidget> createState() => _CatMascotWidgetState();
}

class _CatMascotWidgetState extends State<CatMascotWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _showMascot();
    }
  }

  @override
  void didUpdateWidget(CatMascotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _showMascot();
      } else {
        _hideMascot();
      }
    }
    if (widget.mood != oldWidget.mood && widget.isVisible) {
      _bounceController.forward(from: 0);
    }
  }

  void _showMascot() {
    _fadeController.forward();
    _bounceController.forward();
  }

  void _hideMascot() {
    _fadeController.reverse();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return SizedBox.shrink();

    return Positioned(
      top: 15.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: _buildMascotContainer(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMascotContainer() {
    return Container(
      constraints: BoxConstraints(maxWidth: 60.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.message.isNotEmpty) _buildSpeechBubble(),
          SizedBox(height: 1.h),
          _buildCatAvatar(),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      padding: EdgeInsets.all(3.w),
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.message,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomPath(
              color: AppTheme.lightTheme.colorScheme.surface,
              size: Size(3.w, 2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatAvatar() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _getCatColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cat ears
          Positioned(
            top: 2.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEar(),
                SizedBox(width: 4.w),
                _buildEar(),
              ],
            ),
          ),
          // Cat face
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Eyes
                Positioned(
                  top: 4.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildEye(),
                      SizedBox(width: 2.w),
                      _buildEye(),
                    ],
                  ),
                ),
                // Nose
                Positioned(
                  top: 7.w,
                  child: Container(
                    width: 1.w,
                    height: 1.w,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Mouth
                Positioned(
                  top: 8.w,
                  child: CustomIconWidget(
                    iconName: _getMouthIcon(),
                    color: Colors.black87,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEar() {
    return Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        color: _getCatColors().first,
        borderRadius: BorderRadius.circular(2.w),
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: 2.w,
      height: 2.w,
      decoration: BoxDecoration(
        color: _getEyeColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  List<Color> _getCatColors() {
    switch (widget.mood) {
      case 'happy':
        return [AppTheme.lightTheme.colorScheme.tertiary, Colors.lightGreen];
      case 'excited':
        return [AppTheme.lightTheme.colorScheme.secondary, Colors.orange];
      case 'thinking':
        return [Colors.blue, Colors.lightBlue];
      case 'encouraging':
        return [Colors.purple, Colors.purpleAccent];
      default:
        return [AppTheme.lightTheme.primaryColor, Colors.teal];
    }
  }

  Color _getEyeColor() {
    switch (widget.mood) {
      case 'happy':
      case 'excited':
        return Colors.black87;
      case 'thinking':
        return Colors.blue[800]!;
      default:
        return Colors.black87;
    }
  }

  String _getMouthIcon() {
    switch (widget.mood) {
      case 'happy':
      case 'excited':
        return 'sentiment_very_satisfied';
      case 'thinking':
        return 'help_outline';
      case 'encouraging':
        return 'thumb_up';
      default:
        return 'sentiment_satisfied';
    }
  }
}

class CustomPath extends StatelessWidget {
  final Color color;
  final Size size;

  const CustomPath({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: SpeechBubbleTailPainter(color: color),
    );
  }
}

class SpeechBubbleTailPainter extends CustomPainter {
  final Color color;

  SpeechBubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.5, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}