// lib/features/auth/terms_screen.dart
//
// Terms & Conditions — Consent & Confirmations
// 3 checkboxes, each with a "Know more" link that opens
// a scrollable bottom sheet with the full Payment Consent text.
// Continue activates only when all 3 are checked.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';

// ─────────────────────────────────────────────
//  Consent items
// ─────────────────────────────────────────────

class _ConsentItem {
  final String text;
  const _ConsentItem(this.text);
}

const _items = [
  _ConsentItem(
    'I consent to participate in a virtual appointment and understand that this will occur over a video platform.',
  ),
  _ConsentItem(
    'I agree to the use of my email and/or phone number for receiving appointment links and communication related to my virtual care.',
  ),
  _ConsentItem(
    'I understand the risks related to the privacy of virtual communication.',
  ),
];

const _paymentConsentText = '''Thank you for choosing our services for your needs. Please read the agreement below. It lays out billing, scheduling, and cancellation procedures. If you have any questions please ask for clarification.

Payment of all fees is expected at the time of service or via credit card on file. We will assist you in submitting claims to your insurance carrier.

It is the client's responsibility to check insurance benefits and coverage. You will be responsible for any non-covered services, deductibles, co-payments or co-insurances, as determined by your insurance carrier. Accounts unpaid by the insurance carrier greater than 90 days will be billed to the client.

I hereby authorize payment of medical benefits directly to VirtueMed for all services rendered where applicable.

Out-of-pocket payments can be made via credit/debit card, cash or check and are due on the date of your appointment. Credit/debit card payments can be made directly with your Registered Dietitian. Please make checks payable to VirtueMed. There is an extra fee for all returned checks.

I hereby authorize VirtueMed to release to government agencies, insurance carriers and all other parties as needed, any information pertinent to my case and treatment. I understand that if at any point my insurance coverage changes, I am to notify administrative staff prior to my next visit. Failure to do so will result in being personally and completely responsible for the full amount of all services.

I will be responsible for paying an extra late cancel fee for any missed or canceled initial visits, not made at least 24 hours in advance prior to the scheduled appointment time.

If I default on my account, I understand I will be subject to finance and/or legal fees in addition to the total account balance.

I, agree to the above financial and cancellation policies. In the case of default payment, I am responsible for full payment of the balance, interest accrued, and any collection costs and legal fees incurred to collect on this account. I understand the scope and limitations of my insurance coverage and agree to pay all fees not covered by my insurance plan. I have read, understand, and accept the information and conditions specified in this agreement.''';

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final List<bool> _checked = [false, false, false];

  bool get _allChecked => _checked.every((c) => c);

  void _toggle(int i) =>
      setState(() => _checked[i] = !_checked[i]);

  void _showKnowMore(int index) {
    showModalBottomSheet(
      context:           context,
      isScrollControlled: true,
      backgroundColor:   Colors.transparent,
      builder:           (_) => _PaymentConsentSheet(
        onAgree: () {
          Navigator.pop(context);
          setState(() => _checked[index] = true);
        },
      ),
    );
  }

  void _onContinue() {
    if (!_allChecked) return;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Content ───────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consent & Confirmations',
                        style: AppTextStyles.h1B
                            .copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 32),

                    // Checkboxes
                    ...List.generate(_items.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: _ConsentRow(
                          text:      _items[i].text,
                          checked:   _checked[i],
                          onToggle:  () => _toggle(i),
                          onKnowMore: () => _showKnowMore(i),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── Continue button ───────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 0, 24, MediaQuery.of(context).padding.bottom + 20),
              child: _ContinueButton(
                active: _allChecked,
                onTap:  _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Consent row  (checkbox + text + Know more)
// ─────────────────────────────────────────────

class _ConsentRow extends StatelessWidget {
  final String       text;
  final bool         checked;
  final VoidCallback onToggle;
  final VoidCallback onKnowMore;

  const _ConsentRow({
    required this.text,
    required this.checked,
    required this.onToggle,
    required this.onKnowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Custom checkbox ─────────────
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width:  22, height: 22,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: checked ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: checked ? AppColors.primary : AppColors.surfaceBorder,
                width: 1.5,
              ),
            ),
            child: checked
                ? const Icon(Icons.check,
                    color: AppColors.white100, size: 14)
                : null,
          ),
        ),
        const SizedBox(width: 14),

        // ── Text + Know more ────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: AppTextStyles.t2R
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onKnowMore,
                child: Text('Know more',
                    style: AppTextStyles.t2R.copyWith(
                      color:     AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Payment Consent bottom sheet
// ─────────────────────────────────────────────

class _PaymentConsentSheet extends StatelessWidget {
  final VoidCallback onAgree;
  const _PaymentConsentSheet({required this.onAgree});

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ───────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [
              Expanded(
                child: Text('Payment Consent',
                    style: AppTextStyles.h6SB
                        .copyWith(color: AppColors.textPrimary)),
              ),
              // Download icon
              GestureDetector(
                onTap: () {}, // TODO: download
                child: const Icon(Icons.download_outlined,
                    color: AppColors.textSecondary, size: 22),
              ),
              const SizedBox(width: 16),
              // Close icon
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close,
                    color: AppColors.textSecondary, size: 22),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.surfaceBorder.withOpacity(0.5)),

          // ── Scrollable text ───────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                _paymentConsentText,
                style: AppTextStyles.t3R
                    .copyWith(color: AppColors.textPrimary, height: 1.65),
              ),
            ),
          ),

          // ── I agree button ────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
            child: SizedBox(
              width:  double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onAgree,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('I agree',
                    style: AppTextStyles.t2SB
                        .copyWith(color: AppColors.white100)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Continue button
// ─────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final bool         active;
  final VoidCallback onTap;
  const _ContinueButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height:   54,
      decoration: BoxDecoration(
        color:        active ? AppColors.primary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color:        Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap:        active ? onTap : null,
          child: Center(
            child: Text('Continue',
                style: AppTextStyles.t2SB.copyWith(
                  color: active
                      ? AppColors.white100
                      : AppColors.textMuted,
                )),
          ),
        ),
      ),
    );
  }
}