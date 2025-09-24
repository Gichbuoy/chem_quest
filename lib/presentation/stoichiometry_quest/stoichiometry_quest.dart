import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/calculation_workspace_widget.dart';
import './widgets/cat_mascot_widget.dart';
import './widgets/chemical_equation_widget.dart';
import './widgets/mission_timer_widget.dart';
import './widgets/numeric_keypad_widget.dart';

class StoichiometryQuest extends StatefulWidget {
  const StoichiometryQuest({Key? key}) : super(key: key);

  @override
  State<StoichiometryQuest> createState() => _StoichiometryQuestState();
}

class _StoichiometryQuestState extends State<StoichiometryQuest>
    with TickerProviderStateMixin {
  // Game state variables
  int timeRemaining = 300; // 5 minutes
  int score = 0;
  int lives = 3;
  int currentProblemIndex = 0;
  int streak = 0;
  bool isPaused = false;
  bool isWorkspaceExpanded = false;

  // Input and validation
  Map<String, String> userInputs = {};
  Map<String, bool> validationResults = {};
  String selectedCompoundId = '';

  // Cat mascot state
  String catMood = 'encouraging';
  String catMessage = 'Let\'s balance some equations! You can do this! 🧪';
  bool showCat = true;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _celebrationController;
  late Animation<double> _backgroundAnimation;

  // Timer
  late Stream<int> _timerStream;

  // Mock data for chemical equations
  final List<Map<String, dynamic>> chemicalProblems = [
    {
      'id': 'problem1',
      'description': 'Balance the combustion of methane',
      'reactants': [
        {
          'id': 'ch4',
          'formula': 'CH₄',
          'needsCoefficient': true,
        },
        {
          'id': 'o2',
          'formula': 'O₂',
          'needsCoefficient': true,
        },
      ],
      'products': [
        {
          'id': 'co2',
          'formula': 'CO₂',
          'needsCoefficient': true,
        },
        {
          'id': 'h2o',
          'formula': 'H₂O',
          'needsCoefficient': true,
        },
      ],
      'correctAnswers': {
        'ch4': '1',
        'o2': '2',
        'co2': '1',
        'h2o': '2',
      },
      'difficulty': 'easy',
      'points': 100,
    },
    {
      'id': 'problem2',
      'description': 'Balance the synthesis of ammonia',
      'reactants': [
        {
          'id': 'n2',
          'formula': 'N₂',
          'needsCoefficient': true,
        },
        {
          'id': 'h2',
          'formula': 'H₂',
          'needsCoefficient': true,
        },
      ],
      'products': [
        {
          'id': 'nh3',
          'formula': 'NH₃',
          'needsCoefficient': true,
        },
      ],
      'correctAnswers': {
        'n2': '1',
        'h2': '3',
        'nh3': '2',
      },
      'difficulty': 'medium',
      'points': 150,
    },
    {
      'id': 'problem3',
      'description': 'Balance the decomposition of calcium carbonate',
      'reactants': [
        {
          'id': 'caco3',
          'formula': 'CaCO₃',
          'needsCoefficient': true,
        },
      ],
      'products': [
        {
          'id': 'cao',
          'formula': 'CaO',
          'needsCoefficient': true,
        },
        {
          'id': 'co2_2',
          'formula': 'CO₂',
          'needsCoefficient': true,
        },
      ],
      'correctAnswers': {
        'caco3': '1',
        'cao': '1',
        'co2_2': '1',
      },
      'difficulty': 'easy',
      'points': 100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
    _initializeProblem();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    );
    _celebrationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _backgroundController.repeat();
  }

  void _startTimer() {
    _timerStream = Stream.periodic(Duration(seconds: 1), (i) {
      if (!isPaused && timeRemaining > 0) {
        return timeRemaining--;
      }
      return timeRemaining;
    }).takeWhile((time) => time > 0);

    _timerStream.listen((time) {
      if (mounted) {
        setState(() {
          if (time == 0) {
            _handleTimeUp();
          }
        });
      }
    });
  }

  void _initializeProblem() {
    final currentProblem = chemicalProblems[currentProblemIndex];
    userInputs.clear();
    validationResults.clear();
    selectedCompoundId = '';

    // Initialize all compound IDs that need coefficients
    final reactants = currentProblem['reactants'] as List<dynamic>;
    final products = currentProblem['products'] as List<dynamic>;

    for (final reactant in reactants) {
      final compound = reactant as Map<String, dynamic>;
      if (compound['needsCoefficient'] == true) {
        userInputs[compound['id'] as String] = '';
      }
    }

    for (final product in products) {
      final compound = product as Map<String, dynamic>;
      if (compound['needsCoefficient'] == true) {
        userInputs[compound['id'] as String] = '';
      }
    }

    _updateCatMessage(
        'Let\'s balance this equation step by step!', 'encouraging');
  }

  void _handleTimeUp() {
    _showGameOverDialog();
  }

  void _updateCatMessage(String message, String mood) {
    setState(() {
      catMessage = message;
      catMood = mood;
      showCat = true;
    });

    // Hide cat after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showCat = false;
        });
      }
    });
  }

  void _onNumberPressed(String number) {
    if (selectedCompoundId.isEmpty) {
      _selectFirstEmptyField();
    }

    if (selectedCompoundId.isNotEmpty) {
      setState(() {
        final currentValue = userInputs[selectedCompoundId] ?? '';
        if (currentValue.length < 3) {
          // Limit to 3 digits
          userInputs[selectedCompoundId] = currentValue + number;
          _validateInput(selectedCompoundId);
        }
      });
    }
  }

  void _selectFirstEmptyField() {
    for (final compoundId in userInputs.keys) {
      if (userInputs[compoundId]?.isEmpty ?? true) {
        setState(() {
          selectedCompoundId = compoundId;
        });
        break;
      }
    }
  }

  void _onClearPressed() {
    setState(() {
      if (selectedCompoundId.isNotEmpty) {
        userInputs[selectedCompoundId] = '';
        validationResults.remove(selectedCompoundId);
      }
    });
  }

  void _onDeletePressed() {
    if (selectedCompoundId.isNotEmpty) {
      setState(() {
        final currentValue = userInputs[selectedCompoundId] ?? '';
        if (currentValue.isNotEmpty) {
          userInputs[selectedCompoundId] =
              currentValue.substring(0, currentValue.length - 1);
          _validateInput(selectedCompoundId);
        }
      });
    }
  }

  void _onDecimalPressed() {
    if (selectedCompoundId.isNotEmpty) {
      setState(() {
        final currentValue = userInputs[selectedCompoundId] ?? '';
        if (!currentValue.contains('.') && currentValue.isNotEmpty) {
          userInputs[selectedCompoundId] = currentValue + '.';
        }
      });
    }
  }

  void _validateInput(String compoundId) {
    final currentProblem = chemicalProblems[currentProblemIndex];
    final correctAnswers =
        currentProblem['correctAnswers'] as Map<String, dynamic>;
    final userAnswer = userInputs[compoundId] ?? '';
    final correctAnswer = correctAnswers[compoundId] as String;

    if (userAnswer.isNotEmpty) {
      setState(() {
        validationResults[compoundId] = userAnswer == correctAnswer;
      });

      if (userAnswer == correctAnswer) {
        HapticFeedback.lightImpact();
        _checkIfProblemComplete();
      }
    }
  }

  void _checkIfProblemComplete() {
    final currentProblem = chemicalProblems[currentProblemIndex];
    final correctAnswers =
        currentProblem['correctAnswers'] as Map<String, dynamic>;

    bool allCorrect = true;
    for (final compoundId in correctAnswers.keys) {
      if (validationResults[compoundId] != true) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      _handleProblemComplete();
    }
  }

  void _handleProblemComplete() {
    final currentProblem = chemicalProblems[currentProblemIndex];
    final points = currentProblem['points'] as int;

    setState(() {
      score += points + (streak * 10); // Bonus points for streak
      streak++;
    });

    HapticFeedback.heavyImpact();
    _celebrationController.forward(from: 0);

    _updateCatMessage(
        'Excellent work! You balanced that equation perfectly! 🎉', 'excited');

    // Move to next problem after celebration
    Future.delayed(Duration(seconds: 2), () {
      _moveToNextProblem();
    });
  }

  void _moveToNextProblem() {
    if (currentProblemIndex < chemicalProblems.length - 1) {
      setState(() {
        currentProblemIndex++;
      });
      _initializeProblem();
    } else {
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Mission Complete! 🏆',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'emoji_events',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Congratulations! You\'ve completed all stoichiometry problems!',
              style: GoogleFonts.inter(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Final Score: $score',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            Text(
              'Streak: $streak',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/main-dashboard');
            },
            child: Text('Return to Dashboard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartQuest();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Time\'s Up! ⏰',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'timer_off',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Don\'t worry! Practice makes perfect in chemistry.',
              style: GoogleFonts.inter(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Score: $score',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/main-dashboard');
            },
            child: Text('Return to Dashboard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartQuest();
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _restartQuest() {
    setState(() {
      timeRemaining = 300;
      score = 0;
      lives = 3;
      currentProblemIndex = 0;
      streak = 0;
      isPaused = false;
    });
    _initializeProblem();
    _startTimer();
  }

  void _showPauseDialog() {
    setState(() {
      isPaused = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Game Paused',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'pause_circle',
              color: AppTheme.lightTheme.primaryColor,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Take your time to review the formula reference!',
              style: GoogleFonts.inter(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            _buildFormulaReference(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/main-dashboard');
            },
            child: Text('Exit Game'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isPaused = false;
              });
            },
            child: Text('Resume'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaReference() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Reference:',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '• Count atoms on both sides\n• Start with complex molecules\n• Balance one element at a time\n• Check your work!',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProblem = currentProblemIndex < chemicalProblems.length
        ? chemicalProblems[currentProblemIndex]
        : chemicalProblems.first;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.05),
                  AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                ],
                stops: [
                  0.0 + (_backgroundAnimation.value * 0.3),
                  0.5 + (_backgroundAnimation.value * 0.2),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    MissionTimerWidget(
                      timeRemaining: timeRemaining,
                      score: score,
                      lives: lives,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 2.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Problem ${currentProblemIndex + 1} of ${chemicalProblems.length}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.lightTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _showPauseDialog,
                                    icon: CustomIconWidget(
                                      iconName: 'pause',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ChemicalEquationWidget(
                              equation: currentProblem,
                              userInputs: userInputs,
                              onCoefficientChanged: (compoundId, value) {
                                setState(() {
                                  selectedCompoundId = compoundId;
                                  // Keep the current value if it's just a selection tap
                                });
                                // Only validate if value actually changed
                                if (userInputs[compoundId] != value &&
                                    value.isNotEmpty) {
                                  _validateInput(compoundId);
                                }
                              },
                              validationResults: validationResults,
                              selectedCompoundId: selectedCompoundId,
                            ),
                            SizedBox(height: 2.h),
                            if (streak > 0)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.lightTheme.colorScheme.secondary,
                                      AppTheme.lightTheme.colorScheme.secondary
                                          .withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'local_fire_department',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Streak: $streak',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ),
                    CalculationWorkspaceWidget(
                      isExpanded: isWorkspaceExpanded,
                      currentProblem: currentProblem,
                      onToggle: () {
                        setState(() {
                          isWorkspaceExpanded = !isWorkspaceExpanded;
                        });
                      },
                      onStepCompleted: (stepId) {
                        _updateCatMessage('Great step! Keep going!', 'happy');
                      },
                    ),
                    if (!isWorkspaceExpanded)
                      NumericKeypadWidget(
                        onNumberPressed: _onNumberPressed,
                        onClearPressed: _onClearPressed,
                        onDeletePressed: _onDeletePressed,
                        onDecimalPressed: _onDecimalPressed,
                      ),
                  ],
                ),
                CatMascotWidget(
                  mood: catMood,
                  message: catMessage,
                  isVisible: showCat,
                ),
                if (!isWorkspaceExpanded)
                  Positioned(
                    bottom: 25.h,
                    right: 4.w,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        setState(() {
                          isWorkspaceExpanded = true;
                        });
                      },
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                      child: CustomIconWidget(
                        iconName: 'calculate',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }


  

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('Dashboard', 'dashboard', false, '/main-dashboard'),
              _buildNavItem(
                  'pH Game', 'science', false, '/p-h-indicator-mini-game'),
              _buildNavItem(
                  'Stoichiometry', 'calculate', false, '/stoichiometry-quest'),
              _buildNavItem(
                  'Progress', 'trending_up', true, '/progress-tracking'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String label, String iconName, bool isActive, String route) {
    return GestureDetector(
      onTap: isActive ? null : () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
