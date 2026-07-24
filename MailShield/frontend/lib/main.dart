import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/analysis_provider.dart';
import 'providers/history_provider.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: uncomment once firebase_options.dart exists (run `flutterfire configure`)
  // await Firebase.initializeApp();
  runApp(const CyberMailApp());
}
 
class CyberMailApp extends StatelessWidget {
  const CyberMailApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.landing,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
 
