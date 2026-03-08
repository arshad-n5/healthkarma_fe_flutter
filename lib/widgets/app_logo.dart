// lib/widgets/app_logo.dart
//
// The "Healthkarma.ai" logo used on splash and other screens.
// Use: AppLogo()  or  AppLogo(fontSize: 24)

import 'package:flutter/material.dart';
import '../core/constants/text_styles.dart';
import '../core/constants/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double? fontSize;

  const AppLogo({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final double size = fontSize ?? 30;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:  AppStrings.appNameBrand,
            style: AppTextStyles.logoPurple.copyWith(fontSize: size),
          ),
          TextSpan(
            text:  AppStrings.appNameRest,
            style: AppTextStyles.logoWhite.copyWith(fontSize: size),
          ),
        ],
      ),
    );
  }
}
