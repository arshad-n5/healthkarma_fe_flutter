// lib/features/profile/create_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _heightCtrl    = TextEditingController();
  final _weightCtrl    = TextEditingController();
  final _phoneCtrl     = TextEditingController();
  final _addressCtrl   = TextEditingController();
  final _zipCtrl       = TextEditingController();
  final _mrnCtrl       = TextEditingController();

  DateTime? _dob;
  bool      _showCalendar = false;
  bool      _showGender   = false;
  DateTime  _calendarMonth = DateTime.now();

  String?   _gender;
  String    _heightUnit = 'ft';
  String    _weightUnit = 'lbs';
  String?   _city;

  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Transgender Male (Female to Male)',
    'Transgender Female (Male to Female)',
    'Non-Binary',
    'Prefer not to say',
    'Other',
  ];

  static const List<String> _cities = [
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
    'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose',
  ];

  bool get _canContinue =>
      _firstNameCtrl.text.isNotEmpty &&
      _lastNameCtrl.text.isNotEmpty &&
      _dob != null &&
      _gender != null &&
      _heightCtrl.text.isNotEmpty &&
      _weightCtrl.text.isNotEmpty &&
      _phoneCtrl.text.isNotEmpty &&
      _addressCtrl.text.isNotEmpty &&
      _city != null &&
      _zipCtrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _firstNameCtrl, _lastNameCtrl, _heightCtrl, _weightCtrl,
      _phoneCtrl, _addressCtrl, _zipCtrl, _mrnCtrl,
    ]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl, _lastNameCtrl, _heightCtrl, _weightCtrl,
      _phoneCtrl, _addressCtrl, _zipCtrl, _mrnCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  void _onContinue() {
    if (!_canContinue) return;
    debugPrint('Continue to step 2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:         AppColors.background,
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

                      // ── First Name ──────────────────
                      _FieldLabel('First Name'),
                      _InputField(controller: _firstNameCtrl),
                      const SizedBox(height: 16),

                      // ── Last Name ───────────────────
                      _FieldLabel('Last Name'),
                      _InputField(controller: _lastNameCtrl),
                      const SizedBox(height: 16),

                      // ── Date of Birth ───────────────
                      _FieldLabel('Date of Birth'),
                      _TappableField(
                        text: _dob != null ? _formatDate(_dob!) : '',
                        trailing: const Icon(Icons.calendar_month_outlined,
                            color: AppColors.textMuted, size: 20),
                        onTap: () => setState(
                            () => _showCalendar = !_showCalendar),
                      ),

                      // ── Inline Calendar ─────────────
                      if (_showCalendar) ...[
                        const SizedBox(height: 12),
                        _InlineCalendar(
                          selectedDate:  _dob,
                          displayMonth:  _calendarMonth,
                          onMonthChanged: (m) =>
                              setState(() => _calendarMonth = m),
                          onDateSelected: (d) => setState(() {
                            _dob          = d;
                            _showCalendar = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Gender ──────────────────────
                      _FieldLabel('Gender'),
                      _TappableField(
                        text: _gender ?? '',
                        trailing: Icon(
                          _showGender
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textMuted, size: 22,
                        ),
                        onTap: () => setState(
                            () => _showGender = !_showGender),
                      ),
                      if (_showGender) ...[
                        const SizedBox(height: 12),
                        _InlineGenderPicker(
                          options:  _genderOptions,
                          selected: _gender,
                          onChanged: (v) => setState(() {
                            _gender     = v;
                            _showGender = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ── Height ──────────────────────
                      _FieldLabel('Height'),
                      _UnitInputField(
                        controller:    _heightCtrl,
                        unit:          _heightUnit,
                        units:         const ['ft', 'cm'],
                        onUnitChanged: (v) =>
                            setState(() => _heightUnit = v),
                      ),
                      const SizedBox(height: 16),

                      // ── Weight ──────────────────────
                      _FieldLabel('Weight'),
                      _UnitInputField(
                        controller:    _weightCtrl,
                        unit:          _weightUnit,
                        units:         const ['lbs', 'kg'],
                        onUnitChanged: (v) =>
                            setState(() => _weightUnit = v),
                      ),
                      const SizedBox(height: 16),

                      // ── Phone ───────────────────────
                      _FieldLabel('Phone number'),
                      _InputField(
                        controller:   _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Address ─────────────────────
                      _FieldLabel('Address'),
                      _InputField(controller: _addressCtrl),
                      const SizedBox(height: 16),

                      // ── City ────────────────────────
                      _FieldLabel('City'),
                      _DropdownField(
                        value:     _city,
                        items:     _cities,
                        onChanged: (v) => setState(() => _city = v),
                      ),
                      const SizedBox(height: 16),

                      // ── Zip Code ────────────────────
                      _FieldLabel('Zip Code'),
                      _InputField(
                        controller:   _zipCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── MRN (optional) ──────────────
                      Row(children: [
                        Text('MRN (Medical Record Number)',
                            style: AppTextStyles.t4R),
                        const SizedBox(width: 6),
                        Text('(Optional)',
                            style: AppTextStyles.t4R
                                .copyWith(color: AppColors.textMuted)),
                      ]),
                      const SizedBox(height: 6),
                      _InputField(controller: _mrnCtrl),
                    ]),

                    const SizedBox(height: 24),

                    // ── Continue button ─────────────
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
//  Inline Calendar
// ─────────────────────────────────────────────

class _InlineCalendar extends StatelessWidget {
  final DateTime?  selectedDate;
  final DateTime   displayMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _InlineCalendar({
    required this.selectedDate,
    required this.displayMonth,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  static const _weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  static const _months   = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  List<DateTime?> _buildDays() {
    final first     = DateTime(displayMonth.year, displayMonth.month, 1);
    final daysCount = DateUtils.getDaysInMonth(
        displayMonth.year, displayMonth.month);
    final startWeekday = first.weekday % 7; // Sunday = 0
    final cells = <DateTime?>[];
    for (int i = 0; i < startWeekday; i++) cells.add(null);
    for (int d = 1; d <= daysCount; d++) {
      cells.add(DateTime(displayMonth.year, displayMonth.month, d));
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final days  = _buildDays();
    final label =
        '${_months[displayMonth.month - 1]} ${displayMonth.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ── Month header ─────────────────
          Row(
            children: [
              // Month + year + chevron
              GestureDetector(
                onTap: () {/* year picker could go here */},
                child: Row(
                  children: [
                    Text(label,
                        style: AppTextStyles.t2SB
                            .copyWith(color: AppColors.textPrimary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textPrimary, size: 18),
                  ],
                ),
              ),
              const Spacer(),
              // Prev
              GestureDetector(
                onTap: () => onMonthChanged(
                    DateTime(displayMonth.year, displayMonth.month - 1)),
                child: const Icon(Icons.chevron_left,
                    color: AppColors.textPrimary, size: 22),
              ),
              const SizedBox(width: 8),
              // Next
              GestureDetector(
                onTap: () => onMonthChanged(
                    DateTime(displayMonth.year, displayMonth.month + 1)),
                child: const Icon(Icons.chevron_right,
                    color: AppColors.textPrimary, size: 22),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Weekday headers ──────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekdays
                .map((d) => SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.t5M
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 8),

          // ── Day grid ─────────────────────
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap:     true,
            physics:        const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            children: days.map((day) {
              if (day == null) return const SizedBox.shrink();

              final isSelected = selectedDate != null &&
                  day.year  == selectedDate!.year &&
                  day.month == selectedDate!.month &&
                  day.day   == selectedDate!.day;

              final isToday = day.year  == DateTime.now().year &&
                              day.month == DateTime.now().month &&
                              day.day   == DateTime.now().day;

              return GestureDetector(
                onTap: () => onDateSelected(day),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary, width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: AppTextStyles.t4R.copyWith(
                        color: isSelected
                            ? AppColors.white100
                            : AppColors.textPrimary,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Inline Gender Picker
// ─────────────────────────────────────────────

class _InlineGenderPicker extends StatelessWidget {
  final List<String>      options;
  final String?           selected;
  final ValueChanged<String> onChanged;

  const _InlineGenderPicker({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(options.length, (i) {
          final option     = options[i];
          final isSelected = option == selected;
          final isLast     = i == options.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(option),
                borderRadius: BorderRadius.vertical(
                  top:    i == 0 ? const Radius.circular(12) : Radius.zero,
                  bottom: isLast ? const Radius.circular(12) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Radio circle
                      Container(
                        width:  20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black200,
                            width: isSelected ? 5 : 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(option,
                          style: AppTextStyles.t2R
                              .copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height:  1,
                  thickness: 1,
                  color:   AppColors.surfaceBorder.withOpacity(0.4),
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
//  Top bar
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
            width:  44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value:       1 / 3,
                  strokeWidth: 3,
                  backgroundColor: AppColors.black200,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Text('1/3',
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
                Text('Create your profile', style: AppTextStyles.h6SB),
                Text('For personalized care', style: AppTextStyles.t5M),
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
//  Form card wrapper
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

// ─────────────────────────────────────────────
//  Field widgets
// ─────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.t4R),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController          controller;
  final TextInputType?                 keyboardType;
  final List<TextInputFormatter>?      inputFormatters;

  const _InputField({
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:      controller,
      keyboardType:    keyboardType,
      inputFormatters: inputFormatters,
      style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled:    true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:   BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _TappableField extends StatelessWidget {
  final String       text;
  final Widget       trailing;
  final VoidCallback onTap;

  const _TappableField({
    required this.text,
    required this.trailing,
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
          color:        AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text.isNotEmpty ? text : '',
                style: AppTextStyles.t2R
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _UnitInputField extends StatelessWidget {
  final TextEditingController controller;
  final String                unit;
  final List<String>          units;
  final ValueChanged<String>  onUnitChanged;

  const _UnitInputField({
    required this.controller,
    required this.unit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:   controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              style: AppTextStyles.t2R
                  .copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                border:         InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          Container(
            height:  44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: AppColors.black500,
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(8)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:        unit,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.t4R
                    .copyWith(color: AppColors.textPrimary),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted, size: 18),
                items: units
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onUnitChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String?               value;
  final List<String>          items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:        value,
          isExpanded:   true,
          dropdownColor: AppColors.surface,
          style: AppTextStyles.t2R
              .copyWith(color: AppColors.textPrimary),
          hint: const SizedBox.shrink(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted, size: 22),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
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