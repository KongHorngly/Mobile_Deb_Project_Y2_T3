import 'package:flutter/material.dart';
 
import '../../models/analysis_result_model.dart';
import '../../screens/auth/landing_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/analysis/analyze_screen.dart';
import '../../screens/analysis/result_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/profile/profile_screen.dart';
 

class AppRoutes {
  AppRoutes._();
 
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String analyze = '/analyze';
  static const String result = '/result';
  static const String history = '/history';
  static const String profile = '/profile';
}
 

class AppRouter {
  AppRouter._();
 
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.landing:
        return _build(const LandingScreen(), settings);
 
      case AppRoutes.login:
        return _build(const LoginScreen(), settings);
 
      case AppRoutes.register:
        return _build(const RegisterScreen(), settings); //<===== The name 'RegisterScreen' isn't a class. Try correcting the name to match an existing class.dartcreation_with_non_type
 
      case AppRoutes.dashboard:
       
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _build(
          DashboardScreen(isGuest: args['isGuest'] as bool? ?? false), 
          settings,
        );
 
      case AppRoutes.analyze:
       
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _build(
          AnalyzeScreen(
            type: args['type'] as String? ?? 'email',
            isGuest: args['isGuest'] as bool? ?? false,
          ),
          settings,
        );
 
      case AppRoutes.result:
        // args: { 'type': 'email' | 'image', 'result': AnalysisResultModel }
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final result = args['result'] as AnalysisResultModel? ??
            AnalysisResultModel.placeholder(isSafe: true);
        return _build(
          ResultScreen(
            type: args['type'] as String? ?? 'email',
            result: result,
          ),
          settings,
        );
 
      case AppRoutes.history:
        return _build(const HistoryScreen(), settings);
 
      case AppRoutes.profile:
        return _build(const ProfileScreen(), settings);
 
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
 
  static MaterialPageRoute _build(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
 
