import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/interactive_demo_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to CATmistry!",
      "description":
          "Meet your chemistry companion! Our cat mascot will guide you through fun experiments and help you master chemistry concepts with purr-fect precision.",
      "imageUrl":
          "https://images.pexels.com/photos/2558605/pexels-photo-2558605.jpeg?auto=compress&cs=tinysrgb&w=800",
      "mascotText":
          "Meow! I'm Professor Whiskers, your chemistry guide. Ready to explore the amazing world of molecules? 🧪",
      "interactiveDemo": null,
    },
    {
      "title": "Drag & Drop Chemistry",
      "description":
          "Learn through interactive gameplay! Drag liquids to pH strips, build molecules by connecting atoms, and discover chemistry through hands-on experimentation.",
      "imageUrl":
          "https://images.pexels.com/photos/2280549/pexels-photo-2280549.jpeg?auto=compress&cs=tinysrgb&w=800",
      "mascotText":
          "Watch me demonstrate! Just drag and drop to test different substances. It's like playing with chemistry toys! 🎮",
      "interactiveDemo": "drag_drop",
    },
    {
      "title": "Earn Badges & Level Up",
      "description":
          "Complete challenges to unlock achievement badges! Progress through chemistry levels from Apprentice to Master Chemist while building your knowledge.",
      "imageUrl":
          "https://images.pexels.com/photos/1181533/pexels-photo-1181533.jpeg?auto=compress&cs=tinysrgb&w=800",
      "mascotText":
          "Collect badges like a true chemistry cat! Each achievement brings you closer to becoming a chemistry master! 🏆",
      "interactiveDemo": "badge_system",
    },
    {
      "title": "Daily Challenges & Leaderboards",
      "description":
          "Take on daily chemistry puzzles and compete with friends! Climb the leaderboards by solving stoichiometry problems and mastering organic chemistry.",
      "imageUrl":
          "https://images.pexels.com/photos/3825581/pexels-photo-3825581.jpeg?auto=compress&cs=tinysrgb&w=800",
      "mascotText":
          "Challenge your friends to chemistry duels! Who will be the ultimate chemistry champion? May the best chemist win! ⚔️",
      "interactiveDemo": null,
    },
    {
      "title": "Start Your Chemistry Adventure",
      "description":
          "You're ready to begin! Dive into pH indicator games, stoichiometry quests, and molecule building challenges. Let's make chemistry fun!",
      "imageUrl":
          "https://images.pexels.com/photos/2280571/pexels-photo-2280571.jpeg?auto=compress&cs=tinysrgb&w=800",
      "mascotText":
          "Time to put on your lab goggles! Your chemistry adventure starts meow. Let's create some chemical magic together! ✨",
      "interactiveDemo": null,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: AppTheme.normalAnimation,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMainDashboard();
    }
  }

  void _skipOnboarding() {
    _navigateToMainDashboard();
  }

  void _navigateToMainDashboard() {
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Page indicator
          Container(
            padding: EdgeInsets.only(top: 6.h, bottom: 2.h),
            child: PageIndicatorWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
          ),

          // PageView content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPageWidget(
                  title: data["title"] as String,
                  description: data["description"] as String,
                  imageUrl: data["imageUrl"] as String,
                  mascotText: data["mascotText"] as String?,
                  interactiveDemo: data["interactiveDemo"] != null
                      ? InteractiveDemoWidget(
                          demoType: data["interactiveDemo"] as String,
                        )
                      : null,
                  showSkip: index < _totalPages - 1,
                  onNext: _nextPage,
                  onSkip: _skipOnboarding,
                  isLastPage: index == _totalPages - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
