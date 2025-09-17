import 'package:flutter/material.dart';
import '../presentation/onboarding_flow_screen/onboarding_flow_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard_home_screen/dashboard_home_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/meal_logging_screen/meal_logging_screen.dart';
import '../presentation/user_registration_screen/user_registration_screen.dart';
import '../presentation/activity_tracking_screen/activity_tracking_screen.dart';
import '../presentation/progress_analytics_screen/progress_analytics_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow-screen';
  static const String splash = '/splash-screen';
  static const String dashboardHome = '/dashboard-home-screen';
  static const String login = '/login-screen';
  static const String mealLogging = '/meal-logging-screen';
  static const String userRegistration = '/user-registration-screen';
  static const String activityTracking = '/activity-tracking-screen';
  static const String progressAnalytics = '/progress-analytics-screen';
  static const String userProfileScreen = '/user-profile-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlowScreen(),
    splash: (context) => const SplashScreen(),
    dashboardHome: (context) => const DashboardHomeScreen(),
    login: (context) => const LoginScreen(),
    mealLogging: (context) => const MealLoggingScreen(),
    userRegistration: (context) => const UserRegistrationScreen(),
    activityTracking: (context) => const ActivityTrackingScreen(),
    progressAnalytics: (context) => const ProgressAnalyticsScreen(),
    userProfileScreen: (context) => const UserProfileScreen(),
    adminDashboardScreen: (context) => const AdminDashboardScreen(),
    // TODO: Add your other routes here
  };
}
