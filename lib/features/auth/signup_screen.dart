// lib/features/auth/signup_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _emailValid      = true;
  bool _formFilled      = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm  = _confirmController.text;

    setState(() {
      _formFilled = email.isNotEmpty &&
          password.isNotEmpty &&
          confirm.isNotEmpty &&
          _isValidEmail(email) &&
          password == confirm;
    });
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(email);

  void _onEmailUnfocus() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _emailValid = _isValidEmail(email));
  }

  void _onSignUp() {
    if (!_formFilled) return;
    // TODO: wire up to your auth service
    debugPrint('Sign up tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Top bar ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(fontSize: 28),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.signin),
                    child: Text(
                      'Signin',
                      style: AppTextStyles.t2M.copyWith(
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 72),

              // ── Title ─────────────────────────────
              Text('Sign Up', style: AppTextStyles.h1B),

              const SizedBox(height: 32),

              // ── Email ─────────────────────────────
              Text('Email ID', style: AppTextStyles.t4R),
              const SizedBox(height: 8),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) _onEmailUnfocus();
                },
                child: TextField(
                  controller:   _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged:    (_) => setState(() => _emailValid = true),
                  style: AppTextStyles.t2R
                      .copyWith(color: AppColors.textPrimary),
                  decoration: _inputDecoration(hasError: !_emailValid),
                ),
              ),
              if (!_emailValid) ...[
                const SizedBox(height: 6),
                Text('Not valid email',
                    style: AppTextStyles.t5M
                        .copyWith(color: AppColors.alertRed)),
              ],

              const SizedBox(height: 20),

              // ── Password ──────────────────────────
              Text('Password', style: AppTextStyles.t4R),
              const SizedBox(height: 8),
              TextField(
                controller:  _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.t2R
                    .copyWith(color: AppColors.textPrimary),
                decoration: _inputDecoration(
                  suffixIcon: _eyeIcon(
                    obscure:  _obscurePassword,
                    onToggle: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Confirm Password ──────────────────
              Text('Confirm Password', style: AppTextStyles.t4R),
              const SizedBox(height: 8),
              TextField(
                controller:  _confirmController,
                obscureText: _obscureConfirm,
                style: AppTextStyles.t2R
                    .copyWith(color: AppColors.textPrimary),
                decoration: _inputDecoration(
                  suffixIcon: _eyeIcon(
                    obscure:  _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Sign Up button ────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width:    double.infinity,
                height:   52,
                decoration: BoxDecoration(
                  color: _formFilled
                      ? AppColors.primary
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color:        Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _formFilled ? _onSignUp : null,
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.t2SB.copyWith(
                          color: _formFilled
                              ? AppColors.white100
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Terms ─────────────────────────────
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.t5M,
                    children: [
                      const TextSpan(
                          text: 'By continuing, you agree to our\n'),
                      TextSpan(
                        text:  'Terms of Service',
                        style: AppTextStyles.t5M
                            .copyWith(color: AppColors.primary),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text:  'Privacy Policy',
                        style: AppTextStyles.t5M
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Emergency pill ────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:        AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.surfaceBorder, width: 1),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.t5M,
                      children: [
                        const TextSpan(text: 'In case of emergency, '),
                        TextSpan(
                          text:  'Call 911',
                          style: AppTextStyles.t5SB
                              .copyWith(color: AppColors.alertRed),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    bool hasError = false,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled:    true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:   BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? AppColors.alertRed : AppColors.primary,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? AppColors.alertRed : Colors.transparent,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffixIcon,
    );
  }

  Widget _eyeIcon({required bool obscure, required VoidCallback onToggle}) {
    return GestureDetector(
      onTap: onToggle,
      child: Icon(
        obscure
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: AppColors.textMuted,
        size:  20,
      ),
    );
  }
}