import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cat_mascot_widget.dart';
import './widgets/continue_learning_carousel_widget.dart';
import './widgets/daily_challenge_card_widget.dart';
import './widgets/game_mode_tile_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data
  final List<Map<String, dynamic>> _gameModes = [
    {
      "id": 1,
      "title": "pH Indicators",
      "description":
          "Learn to identify acids and bases using color-changing indicators",
      "iconName": "colorize",
      "completionPercentage": 75,
      "badges": ["Acid Master", "Base Explorer", "pH Pro"],
      "difficulty": "Intermediate",
      "primaryColor": 0xFF4CAF50,
      "route": "/p-h-indicator-mini-game"
    },
    {
      "id": 2,
      "title": "Stoichiometry Quest",
      "description": "Master mole calculations and chemical equation balancing",
      "iconName": "calculate",
      "completionPercentage": 45,
      "badges": ["Mole Calculator"],
      "difficulty": "Advanced",
      "primaryColor": 0xFF2196F3,
      "route": "/stoichiometry-quest"
    },
    {
      "id": 3,
      "title": "Organic Chemistry",
      "description": "Build molecules and identify functional groups",
      "iconName": "account_tree",
      "completionPercentage": 30,
      "badges": [],
      "difficulty": "Beginner",
      "primaryColor": 0xFFFF9800,
      "route": "/organic-chemistry-builder"
    }
  ];

  final Map<String, dynamic> _dailyChallenge = {
    "id": 1,
    "title": "Molecular Mystery",
    "description":
        "Identify the unknown compound using spectroscopic data and chemical tests. Can you solve today's chemistry puzzle?",
    "imageUrl":
        "https://images.pexels.com/photos/2280549/pexels-photo-2280549.jpeg?auto=compress&cs=tinysrgb&w=800",
    "reward": 150,
    "difficulty": "Hard",
    "isCompleted": false,
    "timeLimit": "24 hours"
  };

  final List<Map<String, dynamic>> _continueLearningLessons = [
    {
      "id": 1,
      "title": "Introduction to pH Scale",
      "description":
          "Understanding the fundamentals of acidity and alkalinity in solutions",
      "thumbnailUrl":
          "https://images.pexels.com/photos/2280571/pexels-photo-2280571.jpeg?auto=compress&cs=tinysrgb&w=400",
      "progress": 80,
      "duration": "8 min",
      "topic": "pH Indicators"
    },
    {
      "id": 2,
      "title": "Balancing Chemical Equations",
      "description":
          "Learn the step-by-step process of balancing chemical reactions",
      "thumbnailUrl":
          "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=400",
      "progress": 25,
      "duration": "12 min",
      "topic": "Stoichiometry"
    },
    {
      "id": 3,
      "title": "Functional Groups Overview",
      "description": "Identify and understand common organic functional groups",
      "thumbnailUrl":
          "https://images.pexels.com/photos/1366957/pexels-photo-1366957.jpeg?auto=compress&cs=tinysrgb&w=400",
      "progress": 0,
      "duration": "15 min",
      "topic": "Organic Chemistry"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate data refresh
    });
  }

  void _navigateToGame(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showGameOptions(Map<String, dynamic> gameData) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppTheme.largeRadius),
            topRight: Radius.circular(AppTheme.largeRadius),
          ),
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
            SizedBox(height: 2.h),
            Text(
              gameData['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              'Practice Mode',
              'play_arrow',
              () {
                Navigator.pop(context);
                _navigateToGame(gameData['route'] as String);
              },
            ),
            _buildQuickActionTile(
              'View Progress',
              'trending_up',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/progress-tracking');
              },
            ),
            _buildQuickActionTile(
              'Settings',
              'settings',
              () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _launchDailyChallenge() {
    HapticFeedback.mediumImpact();
    // Navigate to daily challenge screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily Challenge launched!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleLessonTap(Map<String, dynamic> lesson) {
    final String topic = lesson['topic'] as String;
    String route = '/onboarding-flow';

    switch (topic.toLowerCase()) {
      case 'ph indicators':
        route = '/p-h-indicator-mini-game';
        break;
      case 'stoichiometry':
        route = '/stoichiometry-quest';
        break;
      case 'organic chemistry':
        route = '/organic-chemistry-builder';
        break;
    }

    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                ),
                labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'dashboard',
                          color: _currentTabIndex == 0
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text('Dashboard', style: TextStyle(fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'games',
                          color: _currentTabIndex == 1
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text('Games', style: TextStyle(fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: _currentTabIndex == 2
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text('Progress', style: TextStyle(fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: _currentTabIndex == 3
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text('Profile', style: TextStyle(fontSize: 11.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildGamesTab(),
                  _buildProgressTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _launchDailyChallenge,
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: CustomIconWidget(
                iconName: 'flash_on',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 20,
              ),
              label: Text(
                'Daily Challenge',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // Cat Mascot Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CatMascotWidget(
                streakCount: 7,
                experiencePoints: 2450,
                mood: 'happy',
              ),
            ),
            SizedBox(height: 3.h),
            // Daily Challenge
            DailyChallengeCardWidget(
              challengeData: _dailyChallenge,
              onTap: _launchDailyChallenge,
            ),
            SizedBox(height: 4.h),
            // Quick Access Games
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'games',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Quick Access',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              itemCount: _gameModes.length,
              itemBuilder: (context, index) {
                final gameMode = _gameModes[index];
                return GameModeTileWidget(
                  gameData: gameMode,
                  onTap: () => _navigateToGame(gameMode['route'] as String),
                  onLongPress: () => _showGameOptions(gameMode),
                );
              },
            ),
            SizedBox(height: 4.h),
            // Continue Learning
            ContinueLearningCarouselWidget(
              lessons: _continueLearningLessons,
              onLessonTap: _handleLessonTap,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildGamesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Games',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _gameModes.length,
            itemBuilder: (context, index) {
              final gameMode = _gameModes[index];
              return GameModeTileWidget(
                gameData: gameMode,
                onTap: () => _navigateToGame(gameMode['route'] as String),
                onLongPress: () => _showGameOptions(gameMode),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/progress-tracking'),
            child: Text('View Detailed Progress'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text('Chemistry Explorer'),
            subtitle: Text('Level 12 • 2,450 XP'),
          ),
        ],
      ),
    );
  }
}
