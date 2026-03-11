// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              const SizedBox(height: 16),
            ],
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
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.h4M
                  .copyWith(color: AppColors.textPrimary),
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
        // Notification bell with red dot
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
        // Avatar circle
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color:        AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.6), width: 1.5),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.location_on_rounded,
              color: AppColors.primary, size: 14),
          const SizedBox(width: 4),
          Text('New York',
              style: AppTextStyles.t4M
                  .copyWith(color: AppColors.textPrimary)),
        ]),
      ),
      const Spacer(),
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.people_outline_rounded,
            color: AppColors.textSecondary, size: 18),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        const Color(0xFF162A1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF2A5A38).withOpacity(0.8), width: 1),
      ),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color:        const Color(0xFF1E3828),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
              child: Text('🌻', style: TextStyle(fontSize: 28))),
        ),
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
      Row(children: [
        Expanded(
            child: _PollenCard(
                emoji: '🌿', label: 'Grass', value: 4, level: 'Low')),
        const SizedBox(width: 10),
        Expanded(
            child: _PollenCard(
                emoji: '🌳', label: 'Tree', value: 6, level: 'Low')),
        const SizedBox(width: 10),
        Expanded(
            child: _PollenCard(
                emoji: '🌼', label: 'Weeds', value: 5, level: 'Low')),
      ]),
    ]);
  }
}

class _PollenCard extends StatelessWidget {
  final String emoji;
  final String label;
  final int    value;
  final String level;

  const _PollenCard({
    required this.emoji, required this.label,
    required this.value, required this.level,
  });

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
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          Text('$value',
              style: AppTextStyles.t2SB
                  .copyWith(color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 4),
        Text(level,
            style: AppTextStyles.t5SB
                .copyWith(color: AppColors.alertGreen)),
        Container(
          margin:  const EdgeInsets.symmetric(vertical: 5),
          height:  2,
          decoration: BoxDecoration(
            color:        AppColors.alertGreen,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Text(label,
            style: AppTextStyles.t4R
                .copyWith(color: AppColors.textSecondary)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
              const Text('🌬️', style: TextStyle(fontSize: 20)),
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
          width: 1, height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.surfaceBorder.withOpacity(0.4),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('AQI',
                  style: AppTextStyles.t4R
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              const Text('❄️', style: TextStyle(fontSize: 20)),
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
    ('🧤', 'Avoid evening walks after 8 PM, as pollen levels peak around 10 PM.'),
    ('👨', 'Carry antihistamines or allergy medications'),
    ('🥽', 'Wear sunglasses or mask'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _tips.map((t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.$1, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(t.$2,
                style: AppTextStyles.t3R
                    .copyWith(color: AppColors.textPrimary)),
          ),
        ]),
      )).toList(),
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
    _MedRow('Montelukast 10mg',        '7:00 AM',  done: true),
    _MedRow('Fluticasone Nasal Spray', '10:00 AM', hasAlarm: true),
    _MedRow('Albuterol Inhaler (90 mcg)', '1:00 PM', hasAlarm: true),
    _MedRow('Cetirizine 10mg',         '8:00 PM',  hasAlarm: true),
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
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:        AppColors.primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text('💊', style: TextStyle(fontSize: 16))),
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
                    color: m.done
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    decoration: m.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.textMuted,
                  )),
            ),
            if (m.hasAlarm)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.alarm_rounded,
                    color: AppColors.textMuted, size: 13),
              ),
            Text(m.time,
                style: AppTextStyles.t5M.copyWith(
                  color: m.done
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                  decoration: m.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: AppColors.textMuted,
                )),
            const SizedBox(width: 8),
            Icon(Icons.check,
                color: m.done
                    ? AppColors.alertGreen
                    : AppColors.textMuted,
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
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:        AppColors.alertBlue.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text('📅', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Text('Appointment',
              style: AppTextStyles.t2SB
                  .copyWith(color: AppColors.textPrimary)),
        ]),
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
       const  Expanded(
          child: Column(children: [
            _VitalCard(
              emoji:   '🟢',
              label:   'SpO₂',
              value:   '93',
              unit:    '%',
              status:  'Normal',
              timeAgo: '3m ago',
            ),
             SizedBox(height: 12),
            _VitalCard(
              emoji:   '❤️',
              label:   'Heart Rate',
              value:   '99',
              unit:    'bpm',
              status:  'Normal',
              timeAgo: '3m ago',
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🫁', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text('Peak Flow',
              style: AppTextStyles.t4R
                  .copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 14),
        SizedBox(
          height: 44,
          child: CustomPaint(
            size: const Size(double.infinity, 44),
            painter: _SparklinePainter(
              points: const [
                0.5, 0.38, 0.58, 0.42, 0.68, 0.52, 0.62,
                0.48, 0.58, 0.44, 0.54, 0.40, 0.58,
              ],
              color: AppColors.alertBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('460',
              style: AppTextStyles.h5B
                  .copyWith(color: AppColors.textPrimary)),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text('L/min',
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Text('3m ago',
              style: AppTextStyles.t5M
                  .copyWith(color: AppColors.textMuted)),
          const Spacer(),
          Text('Normal',
              style: AppTextStyles.t5SB
                  .copyWith(color: AppColors.alertGreen)),
        ]),
      ]),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String unit;
  final String status;
  final String timeAgo;

  const _VitalCard({
    required this.emoji, required this.label,
    required this.value, required this.unit,
    required this.status, required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Text(timeAgo,
              style: AppTextStyles.t5M
                  .copyWith(color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(value,
              style: AppTextStyles.h5B
                  .copyWith(color: AppColors.textPrimary)),
          const SizedBox(width: 3),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(unit,
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ]),
        const SizedBox(height: 4),
        Text(status,
            style: AppTextStyles.t5SB
                .copyWith(color: AppColors.alertGreen)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Sparkline painter
// ─────────────────────────────────────────────

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color        color;
  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color       = color
      ..strokeWidth = 2.0
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