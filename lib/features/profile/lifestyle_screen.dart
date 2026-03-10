// lib/features/profile/lifestyle_screen.dart
//
// Step 2/3 — Life style form
// Fields: Ongoing conditions (dropdown → inline radio),
//         Drinking Habits (dropdown → inline radio),
//         Smoking Status (dropdown → inline radio),
//         Allergies (dropdown → inline checkboxes, multi-select),
//         Sleep Quality (dropdown → inline radio),
//         Diet Preferences (dropdown → inline radio)

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_routes.dart';

class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({super.key});

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {

  // ── Selections ───────────────────────────
  String?      _condition;
  String?      _drinkingHabit;
  String?      _smokingStatus;
  Set<String>  _allergies     = {};
  String?      _sleepQuality;
  String?      _dietPreference;

  // ── Open/close toggles ───────────────────
  bool _showConditions   = false;
  bool _showDrinking     = false;
  bool _showSmoking      = false;
  bool _showAllergies    = false;
  bool _showSleep        = false;
  bool _showDiet         = false;

  // ── Options ──────────────────────────────
  static const _conditions = [
    'Asthma',
    'Cardiology (e.g., Hypertension)',
    'Endocrinology (e.g., Diabetes)',
    'Psychiatry (e.g., Anxiety, Depression)',
    'Allergies (Seasonal or Food)',
    'None of the above',
    'Other (please specify)',
  ];

  static const _drinkingOptions = [
    'Yes, regularly',
    'Occasionally',
    'No',
  ];

  static const _smokingOptions = [
    'Current smoker',
    'Former smoker',
    'Never smoked',
  ];

  static const _allergyOptions = [
    'Pollen',
    'Dust mites',
    'Pets',
    'Food (specify)',
    'Latex',
    'Other',
  ];

  static const _sleepOptions = [
    'Good',
    'Disturbed / light',
    'Frequently interrupted',
  ];

  static const _dietOptions = [
    'Vegetarian',
    'Vegan',
    'Low-sodium',
    'Diabetic-friendly',
    'No restrictions',
  ];

  bool get _canContinue =>
      _condition     != null &&
      _drinkingHabit != null &&
      _smokingStatus != null &&
      _allergies.isNotEmpty &&
      _sleepQuality  != null &&
      _dietPreference != null;

  String _allergyLabel() {
    if (_allergies.isEmpty) return '';
    if (_allergies.length == 1) return _allergies.first;
    return _allergies.first;
  }

  void _onContinue() {
    if (!_canContinue) return;
    // TODO: navigate to step 3
    Navigator.pushNamed(context, AppRoutes.medications);
  }

  // ── Close all other pickers when opening one ──
  void _toggle(String field) {
    setState(() {
      _showConditions = field == 'conditions' ? !_showConditions : false;
      _showDrinking   = field == 'drinking'   ? !_showDrinking   : false;
      _showSmoking    = field == 'smoking'    ? !_showSmoking    : false;
      _showAllergies  = field == 'allergies'  ? !_showAllergies  : false;
      _showSleep      = field == 'sleep'      ? !_showSleep      : false;
      _showDiet       = field == 'diet'       ? !_showDiet       : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:          AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onSkip: () {}),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FormCard(children: [

                      // ── Ongoing Conditions ──────────
                      _FieldLabel('Any ongoing conditions?'),
                      _TappableField(
                        text:     _condition ?? '',
                        isOpen:   _showConditions,
                        onTap:    () => _toggle('conditions'),
                      ),
                      if (_showConditions) ...[
                        const SizedBox(height: 10),
                        _RadioList(
                          options:  _conditions,
                          selected: _condition,
                          onChanged: (v) => setState(() {
                            _condition      = v;
                            _showConditions = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Drinking Habits ─────────────
                      _FieldLabel('Drinking Habits'),
                      _TappableField(
                        text:   _drinkingHabit ?? '',
                        isOpen: _showDrinking,
                        onTap:  () => _toggle('drinking'),
                      ),
                      if (_showDrinking) ...[
                        const SizedBox(height: 10),
                        _RadioList(
                          options:  _drinkingOptions,
                          selected: _drinkingHabit,
                          onChanged: (v) => setState(() {
                            _drinkingHabit = v;
                            _showDrinking  = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Smoking Status ──────────────
                      _FieldLabel('Smoking Status'),
                      _TappableField(
                        text:   _smokingStatus ?? '',
                        isOpen: _showSmoking,
                        onTap:  () => _toggle('smoking'),
                      ),
                      if (_showSmoking) ...[
                        const SizedBox(height: 10),
                        _RadioList(
                          options:  _smokingOptions,
                          selected: _smokingStatus,
                          onChanged: (v) => setState(() {
                            _smokingStatus = v;
                            _showSmoking   = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Allergies (multi-select) ────
                      _FieldLabel('Allergies'),
                      _TappableField(
                        text:   _allergyLabel(),
                        isOpen: _showAllergies,
                        onTap:  () => _toggle('allergies'),
                      ),
                      if (_showAllergies) ...[
                        const SizedBox(height: 10),
                        _CheckboxList(
                          options:  _allergyOptions,
                          selected: _allergies,
                          onChanged: (v, checked) => setState(() {
                            if (checked) {
                              _allergies.add(v);
                            } else {
                              _allergies.remove(v);
                            }
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Sleep Quality ───────────────
                      _FieldLabel('Sleep Quality'),
                      _TappableField(
                        text:   _sleepQuality ?? '',
                        isOpen: _showSleep,
                        onTap:  () => _toggle('sleep'),
                      ),
                      if (_showSleep) ...[
                        const SizedBox(height: 10),
                        _RadioList(
                          options:  _sleepOptions,
                          selected: _sleepQuality,
                          onChanged: (v) => setState(() {
                            _sleepQuality = v;
                            _showSleep    = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Diet Preferences ────────────
                      _FieldLabel('Diet Preferences'),
                      _TappableField(
                        text:   _dietPreference ?? '',
                        isOpen: _showDiet,
                        onTap:  () => _toggle('diet'),
                      ),
                      if (_showDiet) ...[
                        const SizedBox(height: 10),
                        _RadioList(
                          options:  _dietOptions,
                          selected: _dietPreference,
                          onChanged: (v) => setState(() {
                            _dietPreference = v;
                            _showDiet       = false;
                          }),
                        ),
                      ],
                    ]),

                    const SizedBox(height: 24),

                    _ContinueButton(
                      active: _canContinue,
                      onTap:  _onContinue,
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Top bar  2/3
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 44, height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value:           2 / 3,
                  strokeWidth:     3,
                  backgroundColor: AppColors.black200,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Text('2/3',
                    style: AppTextStyles.t5SB
                        .copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Life style', style: AppTextStyles.h6SB),
                Text('Your daily rhythm', style: AppTextStyles.t5M),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSkip,
            child: Text('Skip',
                style: AppTextStyles.t2M
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared form widgets
// ─────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.t4R),
      );
}

class _TappableField extends StatelessWidget {
  final String       text;
  final bool         isOpen;
  final VoidCallback onTap;

  const _TappableField({
    required this.text,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:  44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: isOpen
              ? const BorderRadius.vertical(top: Radius.circular(8))
              : BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.t2R.copyWith(
                  color: text.isNotEmpty
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
              size:  22,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Radio list (single select) ───────────────

class _RadioList extends StatelessWidget {
  final List<String>      options;
  final String?           selected;
  final ValueChanged<String> onChanged;

  const _RadioList({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(8)),
      ),
      child: Column(
        children: List.generate(options.length, (i) {
          final opt    = options[i];
          final isSel  = opt == selected;
          final isLast = i == options.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(opt),
                borderRadius: isLast
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(8))
                    : BorderRadius.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Custom radio dot
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : AppColors.black200,
                            width: isSel ? 5.5 : 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(opt,
                            style: AppTextStyles.t2R
                                .copyWith(color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1, thickness: 1,
                  color:  AppColors.surfaceBorder.withOpacity(0.4),
                  indent: 48,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Checkbox list (multi-select) ─────────────

class _CheckboxList extends StatelessWidget {
  final List<String>   options;
  final Set<String>    selected;
  final void Function(String, bool) onChanged;

  const _CheckboxList({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(8)),
      ),
      child: Column(
        children: List.generate(options.length, (i) {
          final opt    = options[i];
          final isSel  = selected.contains(opt);
          final isLast = i == options.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(opt, !isSel),
                borderRadius: isLast
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(8))
                    : BorderRadius.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Custom checkbox
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : AppColors.black200,
                            width: 1.5,
                          ),
                        ),
                        child: isSel
                            ? const Icon(Icons.check,
                                color: AppColors.white100, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(opt,
                            style: AppTextStyles.t2R
                                .copyWith(color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1, thickness: 1,
                  color:  AppColors.surfaceBorder.withOpacity(0.4),
                  indent: 48,
                ),
            ],
          );
        }),
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
      duration: const Duration(milliseconds: 250),
      height:   52,
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
            child: Text(
              'Continue',
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