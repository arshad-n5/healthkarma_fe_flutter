// lib/features/auth/signin_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _emailValid      = true;
  bool _formFilled      = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      // Button becomes active only when both fields have content
      // and email looks valid
      _formFilled = email.isNotEmpty && password.isNotEmpty &&
          _isValidEmail(email);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(email);
  }

  void _onEmailUnfocus() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _emailValid = _isValidEmail(email));
  }

  void _onSignIn() {
    if (!_formFilled) return;
    // TODO: wire up to your auth service
    // Navigator.pushReplacementNamed(context, AppRoutes.home);
    debugPrint('Sign in tapped');
  }

  void _onForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Top bar: Logo + Sign Up ────────────
                _TopBar(),

                const SizedBox(height: 72),

                // ── Title ─────────────────────────────
                Text('Signin', style: AppTextStyles.h1B),

                const SizedBox(height: 32),

                // ── Email field ───────────────────────
                Text('Email ID', style: AppTextStyles.t4R),
                const SizedBox(height: 8),
                _EmailField(
                  controller: _emailController,
                  isValid:    _emailValid,
                  onUnfocus:  _onEmailUnfocus,
                  onChanged:  (_) => setState(() => _emailValid = true),
                ),
                if (!_emailValid) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Not valid email',
                    style: AppTextStyles.t5M.copyWith(
                      color: AppColors.alertRed,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Password field ────────────────────
                Text('Password', style: AppTextStyles.t4R),
                const SizedBox(height: 8),
                _PasswordField(
                  controller:      _passwordController,
                  obscure:         _obscurePassword,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: 12),

                // ── Forgot password ───────────────────
                GestureDetector(
                  onTap: _onForgotPassword,
                  child: Text(
                    'Forgot Password',
                    style: AppTextStyles.t4R.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Sign in button ────────────────────
                _SignInButton(
                  active:  _formFilled,
                  onTap:   _onSignIn,
                ),

                const SizedBox(height: 40),

                // ── Terms ─────────────────────────────
                _TermsText(),

                const SizedBox(height: 20),

                // ── Emergency pill ────────────────────
                Center(child: _EmergencyPill()),

                const SizedBox(height: 28),

                // ── Face detect ───────────────────────
                Center(child: _FaceDetect()),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Top bar
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(fontSize: 28),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
          child: Text(
            'Sign Up',
            style: AppTextStyles.t2M.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Email field
// ─────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final VoidCallback onUnfocus;
  final ValueChanged<String> onChanged;

  const _EmailField({
    required this.controller,
    required this.isValid,
    required this.onUnfocus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onUnfocus();
      },
      child: TextField(
        controller:   controller,
        onChanged:    onChanged,
        keyboardType: TextInputType.emailAddress,
        style:        AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled:      true,
          fillColor:   AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:   BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isValid ? AppColors.primary : AppColors.alertRed,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isValid ? Colors.transparent : AppColors.alertRed,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Password field
// ─────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:     controller,
      obscureText:    obscure,
      style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled:    true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 14,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggleObscure,
          child: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textMuted,
            size:  20,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Sign in button — grey when inactive, purple when active
// ─────────────────────────────────────────────

class _SignInButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _SignInButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width:    double.infinity,
      height:   52,
      decoration: BoxDecoration(
        color:        active ? AppColors.primary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color:        Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:        active ? onTap : null,
          child: Center(
            child: Text(
              'Sign in',
              style: AppTextStyles.t2SB.copyWith(
                color: active ? AppColors.white100 : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Terms text
// ─────────────────────────────────────────────

class _TermsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.t5M,
          children: [
            const TextSpan(text: 'By continuing, you agree to our\n'),
            TextSpan(
              text:  'Terms of Service',
              style: AppTextStyles.t5M.copyWith(color: AppColors.primary),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text:  'Privacy Policy',
              style: AppTextStyles.t5M.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Emergency pill
// ─────────────────────────────────────────────

class _EmergencyPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.t5M,
          children: [
            const TextSpan(text: 'In case of emergency, '),
            TextSpan(
              text:  'Call 911',
              style: AppTextStyles.t5SB.copyWith(color: AppColors.alertRed),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Face detect row
// ─────────────────────────────────────────────

class _FaceDetect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.face_retouching_natural_outlined,
          color: AppColors.primary,
          size:  22,
        ),
        const SizedBox(width: 8),
        Text(
          'Detecting Face',
          style: AppTextStyles.t3R.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}