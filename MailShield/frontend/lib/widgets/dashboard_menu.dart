import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';

/// Dashboard hamburger menu. Shows Profile/History/Sign out/Leave for
/// registered users, or Login/Leave for guests.
class DashboardMenu extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onProfile;
  final VoidCallback onHistory;
  final VoidCallback onSignOut;
  final VoidCallback onLogin;
  final VoidCallback onLeaveApp;

  const DashboardMenu({
    super.key,
    required this.isGuest,
    required this.onProfile,
    required this.onHistory,
    required this.onSignOut,
    required this.onLogin,
    required this.onLeaveApp,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfile();
            break;
          case 'history':
            onHistory();
            break;
          case 'signout':
            onSignOut();
            break;
          case 'login':
            onLogin();
            break;
          case 'leave':
            onLeaveApp();
            break;
        }
      },
      itemBuilder: (context) {
        if (isGuest) {
          return const [
            PopupMenuItem(
              value: 'login',
              child: ListTile(
                leading: Icon(Icons.login),
                title: Text(AppStrings.login),
              ),
            ),
            PopupMenuItem(
              value: 'leave',
              child: ListTile(
                leading: Icon(Icons.close),
                title: Text(AppStrings.leaveTheApp),
              ),
            ),
          ];
        }
        return const [
          PopupMenuItem(
            value: 'profile',
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(AppStrings.profile),
            ),
          ),
          PopupMenuItem(
            value: 'history',
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text(AppStrings.history),
            ),
          ),
          PopupMenuItem(
            value: 'signout',
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppStrings.signOut),
            ),
          ),
          PopupMenuItem(
            value: 'leave',
            child: ListTile(
              leading: Icon(Icons.close),
              title: Text(AppStrings.leaveTheApp),
            ),
          ),
        ];
      },
    );
  }
}
