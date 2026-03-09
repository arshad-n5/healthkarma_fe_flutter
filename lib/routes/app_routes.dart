// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/signin_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/create_profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash          = '/';
  static const String signin          = '/signin';
  static const String signup          = '/signup';
  static const String forgotPassword  = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String newPassword     = '/new-password';
  static const String passwordSuccess = '/password-success';
  static const String home            = '/home';
  static const String createProfile   = '/create-profile';

  static Map<String, WidgetBuilder> get routes => {
        splash:          (_) => const SplashScreen(),
        signin:          (_) => const SigninScreen(),
        signup:          (_) => const SignupScreen(),
        forgotPassword:  (_) => const ForgotPasswordScreen(),
        otpVerification: (_) => const OtpVerificationScreen(),
        newPassword:     (_) => const NewPasswordScreen(),
        passwordSuccess: (_) => const PasswordSuccessScreen(),
        home:            (_) => const HomeScreen(),
        createProfile:   (_) => const CreateProfileScreen(),
      };
}