// lib/features/splash/splash_screen.dart
//
// The 3-slide onboarding screen shown on first launch.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _fadeController.reset();
    setState(() => _currentPage = index);
    _fadeController.forward();
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRoutes.signin);
  }

  @override
  Widget build(BuildContext context) {
    final slides = AppStrings.onboardingSlides;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false, // we handle bottom manually so slides fill edge-to-edge
        child: Stack(
          children: [
            // ── Slides ─────────────────────────────
            PageView.builder(
              controller:    _pageController,
              itemCount:     slides.length,
              onPageChanged: _onPageChanged,
              itemBuilder:   (context, index) => _SlidePage(
                title:         slides[index]['title']!,
                description:   slides[index]['description']!,
                fadeAnimation: _fadeAnimation,
              ),
            ),

            // ── Bottom bar — respects home bar ─────
            Positioned(
              bottom: bottomPadding + 24,
              left:   28,
              right:  28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(slides.length, (i) {
                      final bool active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve:    Curves.easeInOut,
                        margin:   const EdgeInsets.only(right: 6),
                        width:    active ? 28 : 10,
                        height:   4,
                        decoration: BoxDecoration(
                          color:        active ? AppColors.primary : AppColors.dotInactive,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),

                  // Skip
                  GestureDetector(
                    onTap: _skip,
                    child: Text(AppStrings.skip, style: AppTextStyles.t4R),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single slide ────────────────────────────────

class _SlidePage extends StatelessWidget {
  final String title;
  final String description;
  final Animation<double> fadeAnimation;

  const _SlidePage({
    required this.title,
    required this.description,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo centred in upper half
          Expanded(
            flex: 5,
            child: Center(child: const AppLogo()),
          ),

          // Title + description fade in on page change
          Expanded(
            flex: 4,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h1B),
                  const SizedBox(height: 14),
                  Text(description, style: AppTextStyles.t4R),
                ],
              ),
            ),
          ),

          // Space so content doesn't sit behind bottom bar
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}