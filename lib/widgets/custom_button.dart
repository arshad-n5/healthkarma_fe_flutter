// lib/widgets/custom_button.dart
//
// A reusable button used across the app.
// Usage:
//   CustomButton(label: 'Get Started', onTap: () { ... })
//   CustomButton(label: 'Skip', onTap: () { ... }, outlined: true)

import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.outlined   = false,
    this.isLoading  = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 52,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _label(color: AppColors.primary),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onTap,
              child: isLoading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : _label(color: Colors.white),
            ),
    );
  }

  Widget _label({required Color color}) => Text(
        label,
        style: AppTextStyles.buttonLabel.copyWith(color: color),
      );
}