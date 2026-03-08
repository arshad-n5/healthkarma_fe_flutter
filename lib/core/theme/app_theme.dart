// lib/core/theme/app_theme.dart
//
// Central MaterialApp theme using the official HealthKarma palette.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness:   Brightness.dark,

      // ── Color scheme ────────────────────────
      colorScheme: const ColorScheme.dark(
        background:   AppColors.background,   // #0D1017
        surface:      AppColors.surface,      // #141921
        primary:      AppColors.primary,      // #9A86E3
        primaryContainer: AppColors.primary700,
        onPrimary:    AppColors.white100,
        onBackground: AppColors.textPrimary,
        onSurface:    AppColors.textPrimary,
        error:        AppColors.alertRed,
        tertiary:     AppColors.alertBlue,
      ),

      scaffoldBackgroundColor: AppColors.background,

      // ── Typography (Inter) ──────────────────
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor:    AppColors.textSecondary,
        displayColor: AppColors.textPrimary,
      ),

      // ── AppBar ──────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  AppColors.background,
        elevation:        0,
        centerTitle:      true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.inter(
          fontSize:   17,
          fontWeight: FontWeight.w600,
          color:      AppColors.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ── Elevated Button ─────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,      // #9A86E3
          foregroundColor: AppColors.white100,
          minimumSize:     const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize:   16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize:   16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input fields ────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: AppColors.surfaceLight,   // #191F28
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color:    AppColors.textMuted,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical:   14,
        ),
      ),

      // ── Divider ─────────────────────────────
      dividerColor: AppColors.divider,

      // ── Card ────────────────────────────────
      cardTheme: CardThemeData(
        color:     AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}