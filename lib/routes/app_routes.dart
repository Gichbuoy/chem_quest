import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/p_h_indicator_mini_game/p_h_indicator_mini_game.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/stoichiometry_quest/stoichiometry_quest.dart';

class AppRoutes {
  // main routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String mainDashboard = '/main-dashboard';
  static const String pHIndicatorMiniGame = '/p-h-indicator-mini-game';
  static const String splash = '/splash-screen';
  static const String progressTracking = '/progress-tracking';
  static const String stoichiometryQuest = '/stoichiometry-quest';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    mainDashboard: (context) => const MainDashboard(),
    pHIndicatorMiniGame: (context) => const PHIndicatorMiniGame(),
    splash: (context) => const SplashScreen(),
    progressTracking: (context) => const ProgressTracking(),
    stoichiometryQuest: (context) => const StoichiometryQuest(),
    // TODO: Add other routes here
  };
}
