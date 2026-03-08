// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/signin_screen.dart';
import '../features/home/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash  = '/';
  static const String signin  = '/signin';
  static const String home    = '/home';
  // static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        signin: (_) => const SigninScreen(),
        home:   (_) => const HomeScreen(),
      };
}
