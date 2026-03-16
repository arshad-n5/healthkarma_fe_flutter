// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(),
              const SizedBox(height: 6),
              _LocationRow(),
              const SizedBox(height: 16),
              _AlertBanner(),
              const SizedBox(height: 24),
              _PollenSection(),
              const SizedBox(height: 12),
              _WeatherAQIRow(),
              const SizedBox(height: 16),
              _TipsList(),
              const SizedBox(height: 24),
              _SectionHeader('Reminders'),
              const SizedBox(height: 12),
              _MedicationsReminder(),
              const SizedBox(height: 12),
              _AppointmentReminder(),
              const SizedBox(height: 24),
              _SectionHeader('Vitals'),
              const SizedBox(height: 12),
              _VitalsGrid(),
              const SizedBox(height: 24),
              _SectionHeader("Today's Workout/Care Plan"),
              const SizedBox(height: 12),
              _WorkoutSection(),
              const SizedBox(height: 24),
              _SectionHeader('Your Daily Goal'),
              const SizedBox(height: 12),
              _DailyGoalSection(),
              const SizedBox(height: 24),
              _SectionHeader("Today's Reading"),
              const SizedBox(height: 12),
              _TodaysReading(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Bottom navigation bar
// ─────────────────────────────────────────────

class _NavItem {
  final String imagePath;
  final String label;
  const _NavItem(this.imagePath, this.label);
}

class _BottomNavBar extends StatelessWidget {
  final int                selectedIndex;
  final ValueChanged<int>  onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem('assets/HomeAssets/nav/home 1.png',     'Home'),
    _NavItem('assets/HomeAssets/nav/pill (1) 2.png',      'Med'),
    _NavItem('assets/HomeAssets/nav/Groupnav.png', 'Appt'),
    _NavItem('assets/HomeAssets/nav/Groupmshnav.png',     'Chat'),
    _NavItem('assets/HomeAssets/nav/Group 1000011516.png',     'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1017),
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)),
        border: Border.all(
          color: AppColors.surfaceBorder.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final item     = _items[i];
          final isActive = i == selectedIndex;
          return GestureDetector(
            onTap:    () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 16 : 12,
                vertical:   12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    item.imagePath,
                    width:  22,
                    height: 22,
                    fit:    BoxFit.contain,
                    color:  const Color(0xFFEBEBEB),
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.circle_outlined,
                            color: Color(0xFFEBEBEB), size: 22),
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 6),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.h4M.copyWith(color: AppColors.textPrimary),
              children: const [
                TextSpan(text: 'Hello '),
                TextSpan(
                  text: 'Alexandrianna,',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: AppColors.textPrimary, size: 20),
            ),
            Positioned(
              top: 8, right: 8,
              child: Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.alertRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color:        AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.6), width: 1.5),
          ),
          child: const Icon(Icons.person,
              color: AppColors.textSecondary, size: 22),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Location row
// ─────────────────────────────────────────────

class _LocationRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        height: 40,
        width: 136,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.location_on_rounded, color: AppColors.primary, size: 19),
          SizedBox(width: 16),
          Text('New York',
              style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
        ]),
      ),
      const Spacer(),
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Image(
            image: AssetImage("assets/HomeAssets/calendar (2) 1.png")),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  Alert banner
// ─────────────────────────────────────────────

class _AlertBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      height:  101,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color:        const Color(0xFF162A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF75A31D), width: 0.5),
      ),
      child: Row(children: [
        Image.asset("assets/HomeAssets/Group.png",
            width: 52, height: 52, fit: BoxFit.contain),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Low pollen count and healthy air—great day to be outside',
            style: AppTextStyles.t3SB
                .copyWith(color: const Color(0xFF6FCF97)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Pollen index
// ─────────────────────────────────────────────

class _PollenSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Text('Pollen Index',
            style: AppTextStyles.t2SB
                .copyWith(color: AppColors.textPrimary)),
        const Spacer(),
        Text('Today',
            style: AppTextStyles.t4R
                .copyWith(color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 12),
      const Row(children: [
        Expanded(
            child: _PollenCard(
                cardImage: 'assets/HomeAssets/grass (2) 1.png',
                label: 'Grass',
                value: 4,
                level: 'Low')),
        SizedBox(width: 10),
        Expanded(
            child: _PollenCard(
                cardImage: 'assets/HomeAssets/tree 1.png',
                label: 'Tree',
                value: 6,
                level: 'Low')),
        SizedBox(width: 10),
        Expanded(
            child: _PollenCard(
                cardImage: 'assets/HomeAssets/nature 1.png',
                label: 'Weeds',
                value: 5,
                level: 'Low')),
      ]),
    ]);
  }
}

class _PollenCard extends StatelessWidget {
  final String cardImage;
  final String label;
  final int    value;
  final String level;

  static const int _maxValue = 10;

  const _PollenCard({
    required this.cardImage, required this.label,
    required this.value,     required this.level,
  });

  String get _levelLabel {
    if (value <= 4) return 'Low';
    if (value <= 7) return 'Moderate';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFF0D0F14),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(cardImage, fit: BoxFit.contain),
            ),
          ),
          const Spacer(),
          Text('$value',
              style: AppTextStyles.h5L
                  .copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 12),
        Text(_levelLabel,
            style: AppTextStyles.t2SB
                .copyWith(color: AppColors.alertGreen)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value:           value / _maxValue,
            minHeight:       3,
            backgroundColor: AppColors.surfaceBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.alertGreen),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: AppTextStyles.t2M
                .copyWith(color: AppColors.textPrimary)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Wind + AQI
// ─────────────────────────────────────────────

class _WeatherAQIRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      height:  134,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color:        const Color(0xFF191F28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF48505B), width: 0.3),
      ),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('Wind',
                  style: AppTextStyles.t4R
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Image.asset("assets/HomeAssets/breezy 1.png",
                  width: 34, height: 34, fit: BoxFit.contain),
            ]),
            const SizedBox(height: 8),
            Text('5km/h',
                style: AppTextStyles.h6SB
                    .copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('Light Air',
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textSecondary)),
          ],
        )),
        Container(
          width: 1, height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFF48505B).withValues(alpha: 0.4),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('AQI',
                  style: AppTextStyles.t4R
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Image.asset("assets/HomeAssets/air-conditioner 1.png",
                  width: 34, height: 34, fit: BoxFit.contain),
            ]),
            const SizedBox(height: 8),
            Text('40',
                style: AppTextStyles.h6SB
                    .copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('Good',
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textSecondary)),
          ],
        )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Tips list
// ─────────────────────────────────────────────

class _TipsList extends StatelessWidget {
  static const _tips = [
    ('assets/HomeAssets/no-touch 1.png',
     'Avoid evening walks after 8 PM, as pollen levels peak around 10 PM.'),
    ('assets/HomeAssets/medicine 1.png',
     'Carry antihistamines or allergy medications'),
    ('assets/HomeAssets/man 1.png',
     'Wear sunglasses or mask'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _tips.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image.asset(t.$1, width: 28, height: 28, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Text(t.$2,
                  style: AppTextStyles.t3R
                      .copyWith(color: AppColors.textPrimary)),
            ),
          ]),
        )).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Section header
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary));
}

// ─────────────────────────────────────────────
//  Medications reminder
// ─────────────────────────────────────────────

class _MedRow {
  final String name;
  final String time;
  final bool   done;
  final bool   hasAlarm;
  const _MedRow(this.name, this.time,
      {this.done = false, this.hasAlarm = false});
}

class _MedicationsReminder extends StatelessWidget {
  static const _meds = [
    _MedRow('Montelukast 10mg',           '7:00 AM',  done: true),
    _MedRow('Fluticasone Nasal Spray',    '10:00 AM', hasAlarm: true),
    _MedRow('Albuterol Inhaler (90 mcg)', '1:00 PM',  hasAlarm: true),
    _MedRow('Cetirizine 10mg',            '8:00 PM',  hasAlarm: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 35, height: 35,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/HomeAssets/drugs 1.png",
                  fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          Text('Medications',
              style: AppTextStyles.t2SB
                  .copyWith(color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 14),
        ..._meds.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Expanded(
              child: Text(m.name,
                  style: AppTextStyles.t4R.copyWith(
                    color:           m.done ? AppColors.alertGreen : AppColors.textPrimary,
                    decoration:      m.done ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationColor: AppColors.alertGreen,
                  )),
            ),
            if (m.hasAlarm)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.alarm_rounded,
                    color: AppColors.primary, size: 16),
              ),
            Text(m.time,
                style: AppTextStyles.t5M.copyWith(
                  color:           m.done ? AppColors.textMuted : AppColors.textSecondary,
                  decoration:      m.done ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: AppColors.textMuted,
                )),
            const SizedBox(width: 8),
            Icon(Icons.check,
                color: m.done ? AppColors.alertGreen : AppColors.textMuted,
                size: 16),
          ]),
        )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Appointment reminder
// ─────────────────────────────────────────────

class _AppointmentReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 35, height: 35,
            decoration: const BoxDecoration(
              color: AppColors.alertBlue,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/HomeAssets/calendar-star--calendar-date-day-favorite-like-month-star.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('Appointment',
              style: AppTextStyles.t2SB
                  .copyWith(color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 14),
        Divider(height: 1, thickness: 0.5,
            color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: Text('Pulmonology Check-Up',
                style: AppTextStyles.t4R
                    .copyWith(color: AppColors.textPrimary)),
          ),
          Text('Today',
              style: AppTextStyles.t5M
                  .copyWith(color: AppColors.textSecondary)),
          Container(
            width: 1, height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: AppColors.surfaceBorder,
          ),
          Text('3:30 PM',
              style: AppTextStyles.t5M
                  .copyWith(color: AppColors.textSecondary)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Vitals grid
// ─────────────────────────────────────────────

class _VitalsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _PeakFlowCard()),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(children: [
            _VitalCard(
              imagePath: 'assets/HomeAssets/Group 427319552.png',
              label:     'SpO₂',
              value:     '93',
              unit:      '%',
              status:    'Normal',
              timeAgo:   '3m ago',
            ),
            SizedBox(height: 12),
            _VitalCard(
              imagePath: 'assets/HomeAssets/cardiogram 1.png',
              label:     'Heart Rate',
              value:     '99',
              unit:      'bpm',
              status:    'Normal',
              timeAgo:   '3m ago',
            ),
          ]),
        ),
      ],
    );
  }
}

class _PeakFlowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 203,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        const Color(0xFF191F28),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF48505B), width: 0.3),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Image.asset(
              'assets/HomeAssets/peak-flow-meter 1.png',
              width: 16, height: 16, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.air, color: Color(0xFF999999), size: 16),
            ),
            const SizedBox(width: 5),
            const Text('Peak Flow',
                style: TextStyle(
                  fontFamily: 'Inter', fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF999999))),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: Transform.rotate(
              angle: -8.99 * 3.14159 / 180,
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: _SparklinePainter(
                  points: const [
                    0.3, 0.25, 0.38, 0.28, 0.42, 0.35, 0.30,
                    0.38, 0.45, 0.40, 0.50, 0.55, 0.65,
                  ],
                  color: const Color(0xFF69C7F5),
                  strokeWidth: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('460',
                style: TextStyle(
                  fontFamily: 'Inter', fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF))),
            const SizedBox(width: 4),
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Text('L/min',
                  style: TextStyle(
                    fontFamily: 'Inter', fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999))),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Text('3m ago',
                style: TextStyle(
                  fontFamily: 'Inter', fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF66747F))),
            const Spacer(),
            const Text('Normal',
                style: TextStyle(
                  fontFamily: 'Inter', fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF67CF65))),
          ]),
        ]),
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value;
  final String unit;
  final String status;
  final String timeAgo;

  const _VitalCard({
    required this.imagePath, required this.label,
    required this.value,     required this.unit,
    required this.status,    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:        const Color(0xFF191F28),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF48505B), width: 0.3),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Image.asset(imagePath,
                width: 16, height: 16, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.favorite,
                        color: Color(0xFFEB5757), size: 16)),
            const SizedBox(width: 5),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999))),
            ),
            Text(timeAgo,
                style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF66747F))),
          ]),
          const Spacer(),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(value,
                style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF))),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(unit,
                  style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999))),
            ),
          ]),
          Align(
            alignment: Alignment.centerRight,
            child: Text(status,
                style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF67CF65))),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Today's Workout / Care Plan
// ─────────────────────────────────────────────

class _WorkoutItem {
  final String imagePath;
  final Color  iconBg;
  final String title;
  final String time;
  final bool   done;
  const _WorkoutItem({
    required this.imagePath, required this.iconBg,
    required this.title,     required this.time,
    this.done = false,
  });
}

class _WorkoutSection extends StatelessWidget {
  static const _items = [
    _WorkoutItem(
      imagePath: 'assets/HomeAssets/meditation 1.png',
      iconBg:    Color(0xFF7FC67E),
      title:     'Morning Breathing & Yoga',
      time:      '7:00am - 7:30am',
      done:      true,
    ),
    _WorkoutItem(
      imagePath: 'assets/HomeAssets/Vector.png',
      iconBg:    Color(0xFFF5C542),
      title:     'Indoor Walk',
      time:      '9:00am - 9:30am',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(_items.length, (i) {
          final item   = _items[i];
          final isLast = i == _items.length - 1;
          return Column(children: [
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(item.imagePath, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.fitness_center,
                              color: Colors.white, size: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppTextStyles.t3SB
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(item.time,
                      style: AppTextStyles.t5M
                          .copyWith(color: AppColors.textSecondary)),
                ],
              )),
              if (item.done) ...[
                const Icon(Icons.check,
                    color: AppColors.alertGreen, size: 16),
                const SizedBox(width: 4),
                Text('Done',
                    style: AppTextStyles.t4SB
                        .copyWith(color: AppColors.alertGreen)),
              ] else
                Text('In Progress',
                    style: AppTextStyles.t4SB
                        .copyWith(color: AppColors.textPrimary)),
            ]),
            if (!isLast) ...[
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 0.5,
                  color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
            ],
          ]);
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Your Daily Goal
// ─────────────────────────────────────────────

class _DailyGoalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      Expanded(
        child: _GoalCard(
          bgColor:   Color(0xFFE8D5F5),
          imagePath: 'assets/HomeAssets/cough 1.png',
          title:     'Peak Flow Reading',
          subtitle:  'Goal: Track twice daily',
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: _GoalCard(
          bgColor:   Color(0xFFD5EBF5),
          imagePath: 'assets/HomeAssets/Groupgoal.png',
          title:     '1200 ml (1.2 liters)',
          subtitle:  'Goal: 2000 ml',
        ),
      ),
    ]);
  }
}

class _GoalCard extends StatelessWidget {
  final Color  bgColor;
  final String imagePath;
  final String title;
  final String subtitle;

  const _GoalCard({
    required this.bgColor,  required this.imagePath,
    required this.title,    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   198,
      height:  170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 60, height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(imagePath, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.track_changes,
                        color: Colors.black54, size: 22)),
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(
              fontFamily: 'Inter', fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A))),
        const SizedBox(height: 3),
        Text(subtitle,
            style: const TextStyle(
              fontFamily: 'Inter', fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF555555))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Today's Reading
// ─────────────────────────────────────────────

class _ReadingItem {
  final String imagePath;
  final String title;
  final String tag;
  const _ReadingItem(this.imagePath, this.title, this.tag);
}

class _TodaysReading extends StatelessWidget {
  static const _items = [
    _ReadingItem(
      'assets/HomeAssets/reading1.png',
      'Cleaning Your Home to Reduce Allergens',
      'Health',
    ),
    _ReadingItem(
      'assets/HomeAssets/reading2.png',
      'Pollen Season Guide',
      'Interview',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _items.map((item) => Container(
          width:  302,
          height: 281,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color:        const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF48505B), width: 0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                child: Image.asset(
                  item.imagePath,
                  height:  175,
                  width:   double.infinity,
                  fit:     BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 175,
                    color:  const Color(0xFFD9D9D9),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                          fontFamily: 'Inter', fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(item.tag,
                        style: const TextStyle(
                          fontFamily: 'Inter', fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666))),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Sparkline painter
// ─────────────────────────────────────────────

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color        color;
  final double       strokeWidth;
  const _SparklinePainter({
    required this.points, required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color       = color
      ..strokeWidth = strokeWidth
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round
      ..style       = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = (1.0 - points[i]) * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => false;
}