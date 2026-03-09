// lib/main.dart
//
// App entry point. Everything starts here.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent so our dark bg shows through
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:           Colors.transparent,
      statusBarIconBrightness:  Brightness.light,
    ),
  );

  runApp(const HealthKarmaApp());
}

class HealthKarmaApp extends StatelessWidget {
  const HealthKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:        'HealthKarma',
      debugShowCheckedModeBanner: false,
      theme:        AppTheme.dark,
      initialRoute: AppRoutes.createProfile,//AppRoutes.splash,
      routes:       AppRoutes.routes,
    );
  }
}
