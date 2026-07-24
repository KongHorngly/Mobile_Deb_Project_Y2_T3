import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/dashboard_menu.dart';

/// Dashboard screen. Renders the full card set for registered users,
/// or just Email Analysis for guests. Driven entirely by [isGuest].
class DashboardScreen extends StatelessWidget {
  final bool isGuest;

  const DashboardScreen({super.key, required this.isGuest});

  void _openAnalyze(BuildContext context, String type) {
    Navigator.pushNamed(
      context,
      AppRoutes.analyze,
      arguments: {'type': type, 'isGuest': isGuest},
    );
  }

  void _leaveApp(BuildContext context) {
    // TODO: hook up to system exit / confirmation dialog
  }

  void _signOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.landing,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App bar row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    DashboardMenu(
                      isGuest: isGuest,
                      onProfile: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                      onHistory: () =>
                          Navigator.pushNamed(context, AppRoutes.history),
                      onSignOut: () => _signOut(context),
                      onLogin: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                      onLeaveApp: () => _leaveApp(context),
                    ),
                    const Expanded(
                      child: Text(
                        AppStrings.dashboard,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balances the menu icon
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // User row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isGuest ? AppStrings.guest : 'username',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      DashboardCard(
                        title: AppStrings.emailAnalysis,
                        description: AppStrings.emailAnalysisDesc,
                        buttonLabel: AppStrings.start,
                        onPressed: () => _openAnalyze(context, 'email'),
                      ),
                      if (!isGuest) ...[
                        DashboardCard(
                          title: AppStrings.imageAnalysis,
                          description: AppStrings.imageAnalysisDesc,
                          buttonLabel: AppStrings.upload,
                          onPressed: () => _openAnalyze(context, 'image'),
                        ),
                        DashboardCard(
                          title: AppStrings.analysisHistory,
                          description: '',
                          buttonLabel: AppStrings.view,
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.history),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
