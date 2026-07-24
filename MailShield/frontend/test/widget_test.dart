import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:project/core/constants/app_strings.dart';
import 'package:project/core/constants/app_theme.dart';
import 'package:project/core/routes/app_router.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/analysis_provider.dart';
import 'package:project/providers/history_provider.dart';

void main() {
  testWidgets('Landing screen shows Login, Register, and Guest options', (
    WidgetTester tester,
  ) async {
    // NOTE: this does NOT call Firebase.initializeApp() — real AuthService/
    // FirestoreService calls will throw if a screen under test tries to hit
    // Firebase. For screens that touch auth/firestore, inject fakes via
    // constructor params (e.g. AuthProvider(authService: FakeAuthService()))
    // instead of using the real services.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AnalysisProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: MaterialApp(
          title: AppStrings.appName,
          theme: AppTheme.light,
          initialRoute: AppRoutes.landing,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );

    expect(find.text(AppStrings.login), findsOneWidget);
    expect(find.text(AppStrings.register), findsOneWidget);
    expect(find.text(AppStrings.signInAsGuest), findsOneWidget);
  });
}
