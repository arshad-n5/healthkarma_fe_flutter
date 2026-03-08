// lib/core/constants/text_styles.dart
//
// Official HealthKarma type scale — Inter (Google Fonts)
// Naming matches the design system exactly:
//
//  Headings  →  H SB, H1 B, H2 M, H3 SB, H4 M, H5 L/M/B, H6 M/SB/B
//  Body      →  T1, T2, T3, T4, T5  (suffixes: R=Regular, M=Medium,
//                                     SB=SemiBold, L=Light, B=Bold)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ─────────────────────────────────────────────
  //  HEADINGS
  // ─────────────────────────────────────────────

  /// H SB  — 32px / SemiBold
  static TextStyle get hSB => GoogleFonts.inter(
        fontSize:   32,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     1.2,
      );

  /// H1 B  — 28px / Bold  / line-height 30
  static TextStyle get h1B => GoogleFonts.inter(
        fontSize:   28,
        fontWeight: FontWeight.w700,
        color:      AppColors.textPrimary,
        height:     30 / 28,
      );

  /// H2 M  — 40px / Medium / line-height 53
  static TextStyle get h2M => GoogleFonts.inter(
        fontSize:   40,
        fontWeight: FontWeight.w500,
        color:      AppColors.textPrimary,
        height:     53 / 40,
      );

  /// H3 SB — 35px / SemiBold / line-height 42
  static TextStyle get h3SB => GoogleFonts.inter(
        fontSize:   35,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     42 / 35,
      );

  /// H4 M  — 20px / Medium
  static TextStyle get h4M => GoogleFonts.inter(
        fontSize:   20,
        fontWeight: FontWeight.w500,
        color:      AppColors.textPrimary,
      );

  /// H5 L  — 22px / Light  / line-height 30
  static TextStyle get h5L => GoogleFonts.inter(
        fontSize:   22,
        fontWeight: FontWeight.w300,
        color:      AppColors.textPrimary,
        height:     30 / 22,
      );

  /// H5 M  — 22px / Medium / line-height 30
  static TextStyle get h5M => GoogleFonts.inter(
        fontSize:   22,
        fontWeight: FontWeight.w500,
        color:      AppColors.textPrimary,
        height:     30 / 22,
      );

  /// H5 B  — 22px / Bold   / line-height 30
  static TextStyle get h5B => GoogleFonts.inter(
        fontSize:   22,
        fontWeight: FontWeight.w700,
        color:      AppColors.textPrimary,
        height:     30 / 22,
      );

  /// H6 M  — 20px / Medium / line-height 30
  static TextStyle get h6M => GoogleFonts.inter(
        fontSize:   20,
        fontWeight: FontWeight.w500,
        color:      AppColors.textPrimary,
        height:     30 / 20,
      );

  /// H6 SB — 20px / SemiBold / line-height 30
  static TextStyle get h6SB => GoogleFonts.inter(
        fontSize:   20,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     30 / 20,
      );

  /// H6 B  — 20px / Bold / line-height 30
  static TextStyle get h6B => GoogleFonts.inter(
        fontSize:   20,
        fontWeight: FontWeight.w700,
        color:      AppColors.textPrimary,
        height:     30 / 20,
      );

  // ─────────────────────────────────────────────
  //  BODY — T1  (18px)
  // ─────────────────────────────────────────────

  /// T1 R  — 18px / Regular / line-height 26
  static TextStyle get t1R => GoogleFonts.inter(
        fontSize:   18,
        fontWeight: FontWeight.w400,
        color:      AppColors.textPrimary,
        height:     26 / 18,
      );

  /// T1 M  — 18px / Medium  / line-height auto
  static TextStyle get t1M => GoogleFonts.inter(
        fontSize:   18,
        fontWeight: FontWeight.w500,
        color:      AppColors.textPrimary,
      );

  /// T1 SB — 18px / SemiBold / line-height 26
  static TextStyle get t1SB => GoogleFonts.inter(
        fontSize:   18,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     26 / 18,
      );

  // ─────────────────────────────────────────────
  //  BODY — T2  (16px)
  // ─────────────────────────────────────────────

  /// T2 L  — 16px / Light   / line-height 26
  static TextStyle get t2L => GoogleFonts.inter(
        fontSize:   16,
        fontWeight: FontWeight.w300,
        color:      AppColors.textSecondary,
        height:     26 / 16,
      );

  /// T2 R  — 16px / Regular / line-height 26
  static TextStyle get t2R => GoogleFonts.inter(
        fontSize:   16,
        fontWeight: FontWeight.w400,
        color:      AppColors.textSecondary,
        height:     26 / 16,
      );

  /// T2 M  — 16px / Medium  / line-height 26
  static TextStyle get t2M => GoogleFonts.inter(
        fontSize:   16,
        fontWeight: FontWeight.w500,
        color:      AppColors.textSecondary,
        height:     26 / 16,
      );

  /// T2 SB — 16px / SemiBold / line-height 26
  static TextStyle get t2SB => GoogleFonts.inter(
        fontSize:   16,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     26 / 16,
      );

  // ─────────────────────────────────────────────
  //  BODY — T3  (15px)
  // ─────────────────────────────────────────────

  /// T3 R  — 15px / Regular / line-height 26
  static TextStyle get t3R => GoogleFonts.inter(
        fontSize:   15,
        fontWeight: FontWeight.w400,
        color:      AppColors.textSecondary,
        height:     26 / 15,
      );

  /// T3 M  — 15px / Medium  / line-height 26
  static TextStyle get t3M => GoogleFonts.inter(
        fontSize:   15,
        fontWeight: FontWeight.w500,
        color:      AppColors.textSecondary,
        height:     26 / 15,
      );

  /// T3 SB — 15px / SemiBold / line-height 26
  static TextStyle get t3SB => GoogleFonts.inter(
        fontSize:   15,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     26 / 15,
      );

  // ─────────────────────────────────────────────
  //  BODY — T4  (14px)
  // ─────────────────────────────────────────────

  /// T4 L  — 14px / Light
  static TextStyle get t4L => GoogleFonts.inter(
        fontSize:   14,
        fontWeight: FontWeight.w300,
        color:      AppColors.textSecondary,
      );

  /// T4 R  — 14px / Regular
  static TextStyle get t4R => GoogleFonts.inter(
        fontSize:   14,
        fontWeight: FontWeight.w400,
        color:      AppColors.textSecondary,
      );

  /// T4 M  — 14px / Medium
  static TextStyle get t4M => GoogleFonts.inter(
        fontSize:   14,
        fontWeight: FontWeight.w500,
        color:      AppColors.textSecondary,
      );

  /// T4 SB — 14px / SemiBold
  static TextStyle get t4SB => GoogleFonts.inter(
        fontSize:   14,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
      );

  // ─────────────────────────────────────────────
  //  BODY — T5  (13px)
  // ─────────────────────────────────────────────

  /// T5 M  — 13px / Medium  / line-height 26
  static TextStyle get t5M => GoogleFonts.inter(
        fontSize:   13,
        fontWeight: FontWeight.w500,
        color:      AppColors.textSecondary,
        height:     26 / 13,
      );

  /// T5 SB — 13px / SemiBold / line-height 26
  static TextStyle get t5SB => GoogleFonts.inter(
        fontSize:   13,
        fontWeight: FontWeight.w600,
        color:      AppColors.textPrimary,
        height:     26 / 13,
      );

  // ─────────────────────────────────────────────
  //  SPECIAL — Logo & Buttons
  // ─────────────────────────────────────────────

  /// Logo "Health" — purple part
  static TextStyle get logoPurple => GoogleFonts.inter(
        fontSize:   30,
        fontWeight: FontWeight.w700,
        color:      AppColors.primary,
        letterSpacing: -0.5,
      );

  /// Logo "karma.ai" — white part
  static TextStyle get logoWhite => GoogleFonts.inter(
        fontSize:   30,
        fontWeight: FontWeight.w400,
        color:      AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  /// Primary button label
  static TextStyle get buttonLabel => GoogleFonts.inter(
        fontSize:   16,
        fontWeight: FontWeight.w600,
        color:      AppColors.white100,
        letterSpacing: 0.1,
      );
}
