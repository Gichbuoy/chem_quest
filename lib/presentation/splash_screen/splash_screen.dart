import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late AnimationController _moleculeAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _moleculeRotationAnimation;

  bool _isInitialized = false;
  double _loadingProgress = 0.0;
  String _loadingText = "Preparing chemistry adventures...";

  // Mock user data for navigation logic
  final Map<String, dynamic> _mockUserData = {
    "isFirstTime": false, // Set to true to test onboarding flow
    "userId": "student_001",
    "username": "ChemCat_Explorer",
    "level": 5,
    "totalPoints": 1250,
    "lastLoginDate": "2025-09-19",
    "completedLessons": ["ph_basics", "acids_bases", "stoichiometry_intro"],
    "unlockedGames": ["ph_indicator", "stoichiometry_quest"],
    "preferences": {
      "soundEnabled": true,
      "hapticFeedback": true,
      "difficulty": "intermediate"
    }
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
    _hideSystemUI();
  }

  void _setupAnimations() {
    // Logo bounce animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading animation
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Molecule rotation animation
    _moleculeAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _moleculeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _moleculeAnimationController,
      curve: Curves.linear,
    ));
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _startInitialization() async {
    // Start animations
    _logoAnimationController.forward();
    _moleculeAnimationController.repeat();

    await Future.delayed(const Duration(milliseconds: 500));
    _loadingAnimationController.forward();

    // Simulate initialization tasks
    await _performInitializationTasks();

    // Navigate based on user status
    _navigateToNextScreen();
  }

  Future<void> _performInitializationTasks() async {
    final tasks = [
      {"name": "Loading user progress...", "duration": 400},
      {"name": "Preparing chemistry problems...", "duration": 600},
      {"name": "Fetching daily challenges...", "duration": 500},
      {"name": "Caching offline content...", "duration": 700},
      {"name": "Initializing game engine...", "duration": 500},
    ];

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      setState(() {
        _loadingText = task["name"] as String;
        _loadingProgress = (i + 1) / tasks.length;
      });

      await Future.delayed(Duration(milliseconds: task["duration"] as int));
    }

    setState(() {
      _isInitialized = true;
      _loadingText = "Ready to explore chemistry!";
    });

    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    _restoreSystemUI();

    final isFirstTime = _mockUserData["isFirstTime"] as bool;
    final targetRoute = isFirstTime ? '/onboarding-flow' : '/main-dashboard';

    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    _moleculeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating molecules background
              _buildFloatingMolecules(),

              // Main content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Loading section
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLoadingIndicator(),
                          SizedBox(height: 3.h),
                          _buildLoadingText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMolecules() {
    return AnimatedBuilder(
      animation: _moleculeAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Molecule 1 - Top left
            Positioned(
              top: 10.h,
              left: 5.w,
              child: Transform.rotate(
                angle: _moleculeRotationAnimation.value * 3.14159,
                child: Opacity(
                  opacity: 0.3,
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=100&h=100&fit=crop",
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Molecule 2 - Top right
            Positioned(
              top: 15.h,
              right: 8.w,
              child: Transform.rotate(
                angle: -_moleculeRotationAnimation.value * 3.14159 * 0.8,
                child: Opacity(
                  opacity: 0.25,
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=100&h=100&fit=crop",
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Molecule 3 - Bottom left
            Positioned(
              bottom: 20.h,
              left: 10.w,
              child: Transform.rotate(
                angle: _moleculeRotationAnimation.value * 3.14159 * 1.2,
                child: Opacity(
                  opacity: 0.2,
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
                    width: 18.w,
                    height: 18.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Molecule 4 - Bottom right
            Positioned(
              bottom: 25.h,
              right: 5.w,
              child: Transform.rotate(
                angle: -_moleculeRotationAnimation.value * 3.14159 * 0.6,
                child: Opacity(
                  opacity: 0.35,
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1518152006812-edab29b069ac?w=100&h=100&fit=crop",
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cat mascot with chemistry elements
        Container(
          width: 35.w,
          height: 35.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: CustomImageWidget(
              imageUrl:
                  "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200&h=200&fit=crop",
              width: 25.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App name
        Text(
          "CATmistry",
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          "Chemistry Adventures with Cats",
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Column(
          children: [
            // Beaker loading animation
            Container(
              width: 20.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  // Liquid fill
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 8.h * _loadingProgress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.lightTheme.colorScheme.secondary,
                            AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4.w - 2),
                          bottomRight: Radius.circular(4.w - 2),
                          topLeft: _loadingProgress > 0.9
                              ? Radius.circular(4.w - 2)
                              : Radius.zero,
                          topRight: _loadingProgress > 0.9
                              ? Radius.circular(4.w - 2)
                              : Radius.zero,
                        ),
                      ),
                    ),
                  ),

                  // Bubbles effect
                  if (_loadingProgress > 0.3)
                    Positioned(
                      top: 1.h,
                      left: 3.w,
                      child: Container(
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),

                  if (_loadingProgress > 0.6)
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: Container(
                        width: 1.5.w,
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Progress percentage
            Text(
              "${(_loadingProgress * 100).toInt()}%",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _loadingText,
        key: ValueKey(_loadingText),
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white.withValues(alpha: 0.8),
          height: 1.4,
        ),
      ),
    );
  }
}