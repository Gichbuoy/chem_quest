import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cat_mascot_widget.dart';
import './widgets/celebration_animation_widget.dart';
import './widgets/game_timer_widget.dart';
import './widgets/liquid_container_widget.dart';
import './widgets/pause_menu_widget.dart';
import './widgets/ph_scale_widget.dart';
import './widgets/progress_bar_widget.dart';
import './widgets/success_screen_widget.dart';

class PHIndicatorMiniGame extends StatefulWidget {
  const PHIndicatorMiniGame({Key? key}) : super(key: key);

  @override
  State<PHIndicatorMiniGame> createState() => _PHIndicatorMiniGameState();
}

class _PHIndicatorMiniGameState extends State<PHIndicatorMiniGame>
    with TickerProviderStateMixin {
  // Game State Variables
  bool _isGameStarted = false;
  bool _isGamePaused = false;
  bool _isGameCompleted = false;
  bool _showCelebration = false;
  int _currentLiquidIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _correctAnswers = 0;
  int _totalAttempts = 0;
  int _remainingSeconds = 300; // 5 minutes
  Timer? _gameTimer;
  String _catEmotion = 'neutral';
  String _catMessage = '';
  List<String> _earnedBadges = [];

  // Mock Data for Liquids
  final List<Map<String, dynamic>> _liquidData = [
    {
      "id": 1,
      "name": "Lemon Juice",
      "ph": 2.0,
      "image":
          "https://images.pexels.com/photos/1414130/pexels-photo-1414130.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Citric acid makes lemons very acidic"
    },
    {
      "id": 2,
      "name": "Coffee",
      "ph": 5.0,
      "image":
          "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Coffee is mildly acidic due to organic acids"
    },
    {
      "id": 3,
      "name": "Pure Water",
      "ph": 7.0,
      "image":
          "https://images.pexels.com/photos/416528/pexels-photo-416528.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Pure water is perfectly neutral"
    },
    {
      "id": 4,
      "name": "Baking Soda",
      "ph": 9.0,
      "image":
          "https://images.pexels.com/photos/6544373/pexels-photo-6544373.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Sodium bicarbonate creates a basic solution"
    },
    {
      "id": 5,
      "name": "Soap",
      "ph": 10.0,
      "image":
          "https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Most soaps are basic to help clean oils"
    },
    {
      "id": 6,
      "name": "Vinegar",
      "ph": 2.5,
      "image":
          "https://images.pexels.com/photos/4198021/pexels-photo-4198021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Acetic acid makes vinegar very acidic"
    },
    {
      "id": 7,
      "name": "Milk",
      "ph": 6.5,
      "image":
          "https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Fresh milk is slightly acidic"
    },
    {
      "id": 8,
      "name": "Bleach",
      "ph": 12.0,
      "image":
          "https://images.pexels.com/photos/4239146/pexels-photo-4239146.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "Household bleach is very basic"
    },
  ];

  List<Map<String, dynamic>> _shuffledLiquids = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    _shuffledLiquids = List.from(_liquidData)..shuffle();
    _currentLiquidIndex = 0;
    _score = 0;
    _streak = 0;
    _correctAnswers = 0;
    _totalAttempts = 0;
    _remainingSeconds = 300;
    _isGameStarted = false;
    _isGamePaused = false;
    _isGameCompleted = false;
    _showCelebration = false;
    _catEmotion = 'neutral';
    _catMessage = 'Ready to test your pH knowledge?';
    _earnedBadges.clear();
  }

  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _catMessage = 'Let\'s start! Drag the liquids to their pH positions!';
      _catEmotion = 'excited';
    });
    _startTimer();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGamePaused && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds == 0) {
          _endGame();
        }
      }
    });
  }

  void _pauseGame() {
    setState(() {
      _isGamePaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _isGamePaused = false;
    });
  }

  void _restartGame() {
    _gameTimer?.cancel();
    _initializeGame();
    _startGame();
  }

  void _quitGame() {
    _gameTimer?.cancel();
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  void _endGame() {
    _gameTimer?.cancel();
    _calculateBadges();
    setState(() {
      _isGameCompleted = true;
      _catEmotion = 'happy';
      _catMessage = 'Great job! You\'ve completed the game!';
    });
  }

  void _calculateBadges() {
    final accuracy =
        _totalAttempts > 0 ? (_correctAnswers / _totalAttempts) * 100 : 0.0;

    if (accuracy >= 95.0) {
      _earnedBadges.add('Perfectionist');
    }
    if (_streak >= 5) {
      _earnedBadges.add('Streak Master');
    }
    if (_remainingSeconds > 180) {
      _earnedBadges.add('Speed Demon');
    }
    if (_correctAnswers >= _shuffledLiquids.length) {
      _earnedBadges.add('Chemistry Expert');
    }
  }

  void _onLiquidDropped(double phPosition) {
    if (_currentLiquidIndex >= _shuffledLiquids.length) return;

    final currentLiquid = _shuffledLiquids[_currentLiquidIndex];
    final correctPH = currentLiquid['ph'] as double;
    final tolerance = 1.0;
    final isCorrect = (phPosition - correctPH).abs() <= tolerance;

    setState(() {
      _totalAttempts++;

      if (isCorrect) {
        _correctAnswers++;
        _streak++;
        _score += (100 + (_streak * 10));
        _catEmotion = 'happy';
        _catMessage = 'Excellent! That\'s correct!';
        _showCelebration = true;

        // Haptic feedback for correct answer
        HapticFeedback.lightImpact();

        _currentLiquidIndex++;

        if (_currentLiquidIndex >= _shuffledLiquids.length) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            _endGame();
          });
        }
      } else {
        _streak = 0;
        _catEmotion = 'sad';
        _catMessage =
            'Not quite! ${currentLiquid['name']} has a pH of ${correctPH.toStringAsFixed(1)}';

        // Show educational popup
        _showEducationalPopup(currentLiquid);
      }
    });

    // Reset cat message after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _catEmotion = 'neutral';
          _catMessage = _currentLiquidIndex < _shuffledLiquids.length
              ? 'Keep going! You\'re doing great!'
              : '';
        });
      }
    });
  }

  void _showEducationalPopup(Map<String, dynamic> liquid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Learn About ${liquid['name']}',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageWidget(
              imageUrl: liquid['image'] as String,
              width: 60.w,
              height: 20.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 2.h),
            Text(
              'pH Level: ${(liquid['ph'] as double).toStringAsFixed(1)}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              liquid['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showHints() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'pH Scale Hints',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHintItem('0-6: Acidic (Red zone)', 'Lemon, vinegar, coffee'),
            _buildHintItem('7: Neutral (Green zone)', 'Pure water'),
            _buildHintItem(
                '8-14: Basic (Blue zone)', 'Soap, bleach, baking soda'),
            SizedBox(height: 2.h),
            Text(
              'Remember: Lower numbers = more acidic, Higher numbers = more basic!',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Thanks!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHintItem(String title, String examples) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Examples: $examples',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _shareResults() {
    final accuracy =
        _totalAttempts > 0 ? (_correctAnswers / _totalAttempts) * 100 : 0.0;
    final message =
        'I just scored $_score points with ${accuracy.toStringAsFixed(1)}% accuracy in the Chem-Quest pH Indicator Mini-Game! 🧪🐱 #ChemQuest #Chemistry #Learning';

    // In a real app, you would use a sharing plugin here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share feature would open here: $message'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Chemistry Lab Image
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/2280549/pexels-photo-2280549.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Game Content
            if (!_isGameStarted) _buildStartScreen(),
            if (_isGameStarted && !_isGameCompleted) _buildGameScreen(),
            if (_isGameCompleted) _buildSuccessScreen(),

            // Overlays
            if (_isGamePaused && _isGameStarted && !_isGameCompleted)
              _buildPauseMenu(),
            if (_showCelebration) _buildCelebrationAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Container(
        width: 85.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game Title
            Text(
              'pH Indicator Mini-Game',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Cat Mascot
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'pets',
                color: Colors.white,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            // Instructions
            Text(
              'Test your chemistry knowledge by dragging household liquids to their correct pH positions on the scale!',
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            // Game Info
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Time Limit', '5 minutes'),
                  _buildInfoRow('Total Items', '${_shuffledLiquids.length}'),
                  _buildInfoRow('Scoring', 'Accuracy + Speed + Streaks'),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
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
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Start Game',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Back Button
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/main-dashboard'),
              child: Text(
                'Back to Dashboard',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Stack(
      children: [
        // Main Game Area
        Positioned.fill(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // pH Scale
              PHScaleWidget(
                onDropAccepted: _onLiquidDropped,
                highlightedPosition:
                    _currentLiquidIndex < _shuffledLiquids.length
                        ? _shuffledLiquids[_currentLiquidIndex]['ph'] as double?
                        : null,
              ),
              const Spacer(),
              // Current Liquid Display
              if (_currentLiquidIndex < _shuffledLiquids.length) ...[
                Text(
                  'Drag this liquid to its pH position:',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                LiquidContainerWidget(
                  liquidData: _shuffledLiquids[_currentLiquidIndex],
                ),
              ],
              SizedBox(height: 8.h),
            ],
          ),
        ),

        // Game UI Overlays
        GameTimerWidget(
          remainingSeconds: _remainingSeconds,
          isRunning: !_isGamePaused,
        ),
        ProgressBarWidget(
          completedItems: _currentLiquidIndex,
          totalItems: _shuffledLiquids.length,
          streak: _streak,
        ),
        CatMascotWidget(
          emotion: _catEmotion,
          message: _catMessage,
        ),

        // Pause Button
        Positioned(
          top: 6.h,
          left: 4.w,
          child: IconButton(
            onPressed: _pauseGame,
            icon: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'pause',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPauseMenu() {
    return PauseMenuWidget(
      onResume: _resumeGame,
      onRestart: _restartGame,
      onQuit: _quitGame,
      onShowHints: _showHints,
    );
  }

  Widget _buildCelebrationAnimation() {
    return CelebrationAnimationWidget(
      isVisible: _showCelebration,
      message: _streak > 1 ? 'Streak x$_streak!' : 'Correct!',
      onAnimationComplete: () {
        setState(() {
          _showCelebration = false;
        });
      },
    );
  }

  Widget _buildSuccessScreen() {
    final accuracy =
        _totalAttempts > 0 ? (_correctAnswers / _totalAttempts) * 100 : 0.0;
    final timeCompleted = 300 - _remainingSeconds;

    return SuccessScreenWidget(
      score: _score,
      accuracy: accuracy,
      timeCompleted: timeCompleted,
      earnedBadges: _earnedBadges,
      onPlayAgain: _restartGame,
      onBackToDashboard: _quitGame,
      onShare: _shareResults,
    );
  }
}
