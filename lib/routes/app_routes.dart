// lib/routes/app_routes.dart
//
// All screen routes defined in one place.
// Add new screens here as you build them.

import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  // ── Route names (use these as strings) ───────
  static const String splash = '/';
  static const String home   = '/home';
  // TODO: add more as you build screens
  // static const String login    = '/login';
  // static const String register = '/register';

  // ── Route map ────────────────────────────────
  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        home:   (_) => const HomeScreen(),
        // login:    (_) => const LoginScreen(),
        // register: (_) => const RegisterScreen(),
      };
}
