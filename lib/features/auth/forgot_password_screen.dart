// lib/features/auth/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/success_checkmark.dart';

// ─────────────────────────────────────────────
//  1. Forgot Password
// ─────────────────────────────────────────────

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailValid = true;
  bool _formFilled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final email = _emailController.text.trim();
      setState(() {
        _formFilled = email.isNotEmpty && _isValidEmail(email);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) =>
      RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(v);

  void _onUnfocus() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _emailValid = _isValidEmail(email));
  }

  void _onConfirm() {
    if (!_formFilled) return;
    Navigator.pushNamed(
      context,
      AppRoutes.otpVerification,
      arguments: _emailController.text.trim(),
    );
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
              const SizedBox(height: 16),
              _BackButton(),
              const SizedBox(height: 20),
              const AppLogo(fontSize: 28),
              const SizedBox(height: 64),

              Text('Forgot Password', style: AppTextStyles.h1B),
              const SizedBox(height: 12),
              Text(
                'Please enter your email to receive a\nconfirmation code to set a new password.',
                style: AppTextStyles.t3R,
              ),

              const SizedBox(height: 36),

              Text('Enter your registered email ID', style: AppTextStyles.t4R),
              const SizedBox(height: 8),

              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) _onUnfocus();
                },
                child: TextField(
                  controller:   _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged:    (_) => setState(() => _emailValid = true),
                  style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
                  decoration: _inputDeco(hasError: !_emailValid),
                ),
              ),
              if (!_emailValid) ...[
                const SizedBox(height: 6),
                Text(
                  'Not valid email',
                  style: AppTextStyles.t5M.copyWith(color: AppColors.alertRed),
                ),
              ],

              const SizedBox(height: 28),

              _ActionButton(
                label:  'Confirm Mail',
                active: _formFilled,
                onTap:  _onConfirm,
              ),

              const SizedBox(height: 48),
              Center(child: _EmergencyPill()),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  2. OTP Verification
// ─────────────────────────────────────────────

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _focusNode     = FocusNode();

  int  _secondsLeft = 300;
  bool _canResend   = false;

  String get _email =>
      (ModalRoute.of(context)?.settings.arguments as String?) ?? 'your@mail.com';

  String get _otp   => _otpController.text;
  bool get _otpFilled => _otp.length == 6;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() => setState(() {}));
    _focusNode.addListener(() => setState(() {}));
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startTimer() {
    setState(() {
      _secondsLeft = 300;
      _canResend   = false;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
        }
      });
      return _secondsLeft > 0;
    });
  }

  String get _timerLabel {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onVerify() {
    if (!_otpFilled) return;
    Navigator.pushNamed(
      context,
      AppRoutes.newPassword,
      arguments: _email,
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              const SizedBox(height: 16),
              _BackButton(),
              const SizedBox(height: 20),
              const AppLogo(fontSize: 28),
              const SizedBox(height: 48),

              Text('Verify email address', style: AppTextStyles.h1B),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.t3R,
                  children: [
                    TextSpan(
                      text: _canResend
                          ? "We've sent a fresh OTP to your email.\n"
                          : 'An OTP has been send to ',
                    ),
                    TextSpan(
                      text:  _email,
                      style: AppTextStyles.t3R
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 56),

              // ── OTP: hidden field + visual digits ─────
              GestureDetector(
                onTap: () => _focusNode.requestFocus(),
                child: SizedBox(
                  height: 56,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                    // Hidden TextField — captures actual keyboard input
                    Positioned(
                      left: -9999,
                      child: SizedBox(
                        width: 1,
                        height: 1,
                        child: TextField(
                          controller:   _otpController,
                          focusNode:    _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength:    6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            counterText: '',
                            border:      InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    // Visual digit row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) {
                        final digit     = i < _otp.length ? _otp[i] : '';
                        final isFocused = i == _otp.length && _focusNode.hasFocus;
                        return _OtpDigit(digit: digit, isFocused: isFocused);
                      }),
                    ),
                  ],
                  ),
                ),
              ),

              const SizedBox(height: 56),

              // ── Resend ────────────────────────────
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.t4R,
                    children: [
                      const TextSpan(text: "Didn't receive? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: _canResend ? _startTimer : null,
                          child: Text(
                            'Resend OTP',
                            style: AppTextStyles.t4SB.copyWith(
                              color: _canResend
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _timerLabel,
                  style: AppTextStyles.h6M.copyWith(color: AppColors.textPrimary),
                ),
              ),

              const SizedBox(height: 32),

              _ActionButton(
                label:  'Verify',
                active: _otpFilled,
                onTap:  _onVerify,
              ),

              const SizedBox(height: 40),
              Center(child: _EmergencyPill()),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  3. New Password
// ─────────────────────────────────────────────

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();
  bool _obscurePassword     = true;
  bool _obscureConfirm      = true;

  bool get _formFilled =>
      _passwordController.text.isNotEmpty &&
      _confirmController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (!_formFilled) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.passwordSuccess,
      (route) => false,
    );
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
              const SizedBox(height: 16),
              _BackButton(),
              const SizedBox(height: 20),
              const AppLogo(fontSize: 28),
              const SizedBox(height: 64),

              Text('New Password', style: AppTextStyles.h1B),
              const SizedBox(height: 8),
              Text('Enter new password', style: AppTextStyles.t3R),

              const SizedBox(height: 32),

              Text('Password', style: AppTextStyles.t4R),
              const SizedBox(height: 8),
              TextField(
                controller:  _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
                decoration: _inputDeco(
                  suffixIcon: _eyeIcon(
                    obscure:  _obscurePassword,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text('Confirm Password', style: AppTextStyles.t4R),
              const SizedBox(height: 8),
              TextField(
                controller:  _confirmController,
                obscureText: _obscureConfirm,
                style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
                decoration: _inputDeco(
                  suffixIcon: _eyeIcon(
                    obscure:  _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _ActionButton(
                label:  'Reset Password',
                active: _formFilled,
                onTap:  _onReset,
              ),

              const SizedBox(height: 48),
              Center(child: _EmergencyPill()),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  4. Password Success
// ─────────────────────────────────────────────

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppLogo(fontSize: 28),
              const Spacer(),
              const SuccessCheckmark(size: 90),
              const SizedBox(height: 24),
              Text(
                'Your password has been\nchanged successfully',
                textAlign: TextAlign.center,
                style: AppTextStyles.h5M,
              ),
              const Spacer(),
              SizedBox(
                width:  double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.signin,
                    (route) => false,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Go to Sign in',
                    style: AppTextStyles.t2SB.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared widgets
// ─────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 18),
          const SizedBox(width: 6),
          Text('Back',
              style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

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
          onTap: active ? onTap : null,
          child: Center(
            child: Text(
              label,
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

class _OtpDigit extends StatelessWidget {
  final String digit;
  final bool   isFocused;

  const _OtpDigit({required this.digit, required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 48,
            child: Center(
              child: Text(
                digit,
                style: const TextStyle(
                  color:      AppColors.textPrimary,
                  fontSize:   36,
                  fontWeight: FontWeight.w600,
                  height:     1.0,
                ),
              ),
            ),
          ),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: isFocused ? AppColors.primary : AppColors.black200,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared helpers
// ─────────────────────────────────────────────

InputDecoration _inputDeco({bool hasError = false, Widget? suffixIcon}) {
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
      obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      color: AppColors.textMuted,
      size:  20,
    ),
  );
}