import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/custom_button.dart';
 
/// Landing screen: CYBERMAIL logo 
/// Login/Register/Guest.
/// 
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Icon(Icons.shield_outlined,
                    size: 64, color: Colors.black87),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(flex: 3),
                CustomButton(
                  label: AppStrings.login,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.login),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: AppStrings.register,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.register),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.dashboard,
                    arguments: {'isGuest': true},
                  ),
                  child: const Text(
                    AppStrings.signInAsGuest,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
