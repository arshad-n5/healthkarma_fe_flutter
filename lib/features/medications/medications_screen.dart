// lib/features/medications/medications_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

// ─────────────────────────────────────────────
//  Data models
// ─────────────────────────────────────────────

class _ActiveMed {
  final String imagePath;
  final String name;
  final String frequency;
  final List<String> times;
  final String note;
  final bool hasAlarm;

  const _ActiveMed({
    required this.imagePath,
    required this.name,
    required this.frequency,
    required this.times,
    required this.note,
    this.hasAlarm = true,
  });
}

class _HistoryMed {
  final String name;
  final String type;
  final String startDate;
  final String endDate;
  final String reasonStopped;
  final String prescribedBy;
  final String remarks;

  const _HistoryMed({
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reasonStopped,
    required this.prescribedBy,
    required this.remarks,
  });
}

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────

class MedListScreen extends StatefulWidget {
  const MedListScreen({super.key});

  @override
  State<MedListScreen> createState() => _MedListScreenState();
}

class _MedListScreenState extends State<MedListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedNavIndex = 1; // Med tab active

  static const activeMeds = [
    _ActiveMed(
      imagePath: 'assets/HomeAssets/pill.png',
      name:      'Montelukast - 10mg',
      frequency: '3 times a day',
      times:     ['09:00 AM', '03:00 PM', '09:00 PM'],
      note:      'Before bedtime',
      hasAlarm:  true,
    ),
    _ActiveMed(
      imagePath: 'assets/HomeAssets/inhaler.png',
      name:      'Albuterol Inhaler - 90 mcg',
      frequency: 'As needed',
      times:     [],
      note:      'Before bedtime',
      hasAlarm:  false,
    ),
    _ActiveMed(
      imagePath: 'assets/HomeAssets/cream.png',
      name:      'Triamcinolone 0.1% Cream',
      frequency: 'Apply morning and evening',
      times:     ['09:00 AM', '09:00 PM'],
      note:      'Apply to affected skin',
      hasAlarm:  true,
    ),
  ];

  static const historyMeds = [
    _HistoryMed(
      name:          'Cetirizine 10mg',
      type:          'Tablet',
      startDate:     'Feb 1, 2024',
      endDate:       'Apr 1, 2024',
      reasonStopped: 'Seasonal allergy symptoms resolved',
      prescribedBy:  'Dr. Nina Roberts',
      remarks:       'Worked well during spring pollen season',
    ),
    _HistoryMed(
      name:          'Fluticasone Nasal Spray 50 mcg',
      type:          'Nasal Spray',
      startDate:     'Sep 15, 2023',
      endDate:       'Sep 15, 2023',
      reasonStopped: 'Switched to Montelukast for better symptom control',
      prescribedBy:  'Dr. Andrew Chen',
      remarks:       'Mild dryness in nose',
    ),
    _HistoryMed(
      name:          'Albuterol Inhaler (90 mcg)',
      type:          'Inhaler',
      startDate:     'Jan 2023',
      endDate:       'Aug 2023',
      reasonStopped: 'Expired — replaced with new inhaler',
      prescribedBy:  'Dr. Linda Morales',
      remarks:       'Emergency use only',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // ── Header ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [
              const Spacer(),
              Text('Medications',
                  style: AppTextStyles.h6SB
                      .copyWith(color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add,
                    color: AppColors.primary, size: 20),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Tabs ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller:       _tabController,
              labelColor:       AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle:       AppTextStyles.t3SB,
              unselectedLabelStyle: AppTextStyles.t3R,
              indicatorColor:   AppColors.textPrimary,
              indicatorWeight:  2,
              indicatorSize:    TabBarIndicatorSize.label,
              dividerColor:     AppColors.surfaceBorder.withValues(alpha: 0.4),
              tabs: const [
                Tab(text: 'Active (03)'),
                Tab(text: 'History'),
              ],
            ),
          ),

          // ── Tab content ─────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActiveTab(meds: _MedListScreenState.activeMeds),
                _HistoryTab(meds: _MedListScreenState.historyMeds),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (i) {
          if (i == 0) {
            Navigator.pop(context);
          } else {
            setState(() => _selectedNavIndex = i);
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Active tab
// ─────────────────────────────────────────────

class _ActiveTab extends StatelessWidget {
  final List<_ActiveMed> meds;
  const _ActiveTab({required this.meds});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: meds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ActiveMedCard(med: meds[i]),
    );
  }
}

class _ActiveMedCard extends StatelessWidget {
  final _ActiveMed med;
  const _ActiveMedCard({required this.med});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      height:  184,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        const Color(0xFF191F28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF48505B), width: 0.3),
      ),
      child: const SizedBox.shrink(),
    );
  }
}

// ─────────────────────────────────────────────
//  History tab
// ─────────────────────────────────────────────

class _HistoryTab extends StatefulWidget {
  final List<_HistoryMed> meds;
  const _HistoryTab({required this.meds});

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Search + Filter ─────────────────
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: AppTextStyles.t4R
                    .copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText:     'Search',
                  hintStyle:    AppTextStyles.t4R
                      .copyWith(color: AppColors.textMuted),
                  prefixIcon:   const Icon(Icons.search,
                      color: AppColors.textMuted, size: 18),
                  border:       InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.tune_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text('Filter',
                  style: AppTextStyles.t4M
                      .copyWith(color: AppColors.textPrimary)),
            ]),
          ),
        ]),
      ),

      // ── History list ────────────────────
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: widget.meds.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _HistoryMedCard(med: widget.meds[i]),
        ),
      ),
    ]);
  }
}

class _HistoryMedCard extends StatelessWidget {
  final _HistoryMed med;
  const _HistoryMedCard({required this.med});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(med.name,
            style: AppTextStyles.t2SB
                .copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        _InfoRow('Type',           med.type),
        _InfoRow('Start Date',     med.startDate),
        _InfoRow('End Date',       med.endDate),
        _InfoRow('Reason Stopped', med.reasonStopped),
        _InfoRow('Prescribed By',  med.prescribedBy),
        _InfoRow('Remarks',        med.remarks),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.t4R
              .copyWith(color: AppColors.textSecondary),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color:      AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MedListBody — used by home IndexedStack
// ─────────────────────────────────────────────

class MedListBody extends StatefulWidget {
  MedListBody({super.key});

  @override
  State<MedListBody> createState() => _MedListBodyState();
}

class _MedListBodyState extends State<MedListBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 0),
        child: Row(children: [
          const Spacer(),
          Text('Medications',
              style: AppTextStyles.h6SB
                  .copyWith(color: AppColors.textPrimary)),
          const Spacer(),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 20),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBar(
          controller:          _tabController,
          labelColor:          AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle:          AppTextStyles.t3SB,
          unselectedLabelStyle: AppTextStyles.t3R,
          indicatorColor:      AppColors.textPrimary,
          indicatorWeight:     2,
          indicatorSize:       TabBarIndicatorSize.label,
          dividerColor:        AppColors.surfaceBorder.withValues(alpha: 0.4),
          tabs: const [
            Tab(text: 'Active (03)'),
            Tab(text: 'History'),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            _ActiveTab(meds: _MedListScreenState.activeMeds),
            _HistoryTab(meds: _MedListScreenState.historyMeds),
          ],
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  Bottom nav (same as home)
// ─────────────────────────────────────────────

class _NavItem {
  final String imagePath;
  final String label;
  const _NavItem(this.imagePath, this.label);
}

class _BottomNavBar extends StatelessWidget {
  final int               selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const _items = [
    _NavItem('assets/HomeAssets/nav/home 1.png',           'Home'),
    _NavItem('assets/HomeAssets/nav/pill (1) 2.png',       'Med'),
    _NavItem('assets/HomeAssets/nav/Groupnav.png',         'Appt'),
    _NavItem('assets/HomeAssets/nav/Groupmshnav.png',      'Chat'),
    _NavItem('assets/HomeAssets/nav/Group 1000011516.png', 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1017),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
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
              height:   48,
              padding:  EdgeInsets.symmetric(
                  horizontal: isActive ? 16 : 12, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(item.imagePath,
                    width: 22, height: 22, fit: BoxFit.contain,
                    color: const Color(0xFFEBEBEB),
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.circle_outlined,
                        color: Color(0xFFEBEBEB), size: 22)),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Text(item.label,
                      style: const TextStyle(
                        fontFamily: 'Inter', fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      )),
                ],
              ]),
            ),
          );
        }),
      ),
    );
  }
}