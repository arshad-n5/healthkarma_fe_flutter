// lib/core/constants/colors.dart
//
// Official HealthKarma color palette.
// Every color in the app comes from here.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Purple ───────────────────────────
  static const Color primary500     = Color(0xFF9A86E3); // Primary Purple500
  static const Color primary600     = Color(0xFF7962D4); // Purple600
  static const Color primary700     = Color(0xFF604B9A); // Purple700

  // Shorthand aliases
  static const Color primary        = primary500;
  static const Color primaryDark    = primary700;

  // ── Secondary White ──────────────────────────
  static const Color white100       = Color(0xFFFFFFFF);
  static const Color white200       = Color(0xFFF3F3F3); // Secondary White200
  static const Color white300       = Color(0xFFEBEBEB); // White300

  // ── Tertiary Grey ────────────────────────────
  static const Color grey300        = Color(0xFFDBDBDB); // Grey300 (Primary Text)
  static const Color grey400        = Color(0xFF999999); // Tertiary Grey400
  static const Color grey600        = Color(0xFF66747F); // Grey600

  // ── Dark Mode Backgrounds ────────────────────
  static const Color black200       = Color(0xFF48505B); // Black200
  static const Color black500       = Color(0xFF191F28); // Black500
  static const Color black600       = Color(0xFF141921); // Black600
  static const Color black700       = Color(0xFF0D1017); // Black700
  static const Color black800       = Color(0xFF0E0E10); // Black800

  // Semantic background aliases
  static const Color background     = black700;          // main screen bg
  static const Color surface        = black600;          // cards / sheets
  static const Color surfaceLight   = black500;          // elevated surfaces
  static const Color surfaceBorder  = black200;          // borders / dividers

  // ── Gradient ─────────────────────────────────
  static const Color gradientStart  = Color(0xFF604B9A); // Purple700
  static const Color gradientEnd    = Color(0xFF7962D4); // Purple600
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin:  Alignment.topLeft,
    end:    Alignment.bottomRight,
  );

  // ── Alerts ───────────────────────────────────
  static const Color alertRed       = Color(0xFFF14336); // Alert High Red900
  static const Color alertYellow    = Color(0xFFFEB63D); // Alert Yellow900
  static const Color alertGreen     = Color(0xFF67CF65); // Alert Low Green900
  static const Color alertBlue      = Color(0xFF2092E5); // Alert Blue900

  // ── Text ─────────────────────────────────────
  static const Color textPrimary    = grey300;           // #DBDBDB
  static const Color textSecondary  = grey400;           // #999999
  static const Color textMuted      = grey600;           // #66747F
  static const Color textOnDark     = white100;

  // ── UI helpers ───────────────────────────────
  static const Color divider        = black500;
  static const Color dotInactive    = black200;
}
