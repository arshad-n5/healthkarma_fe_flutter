// lib/features/home/home_screen.dart
//
// Placeholder home screen.
// Replace this with your actual home UI when you have the design.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/app_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(),
            const SizedBox(height: 24),
            Text(
              'Home screen coming soon!',
              style: AppTextStyles.t4R,
            ),
          ],
        ),
      ),
    );
  }
}