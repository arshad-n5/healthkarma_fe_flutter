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
  int _selectedNavIndex = 1;

  static const activeMeds = [
    _ActiveMed(
      imagePath: 'assets/MedicationAssets/drug 1.png',
      name: 'Montelukast - 10mg',
      frequency: '3 times a day',
      times: ['09:00 AM', '03:00 PM', '09:00 PM'],
      note: 'Before bedtime',
      hasAlarm: true,
    ),
    _ActiveMed(
      imagePath: 'assets/MedicationAssets/inhaler 1.png',
      name: 'Albuterol Inhaler - 90 mcg',
      frequency: 'As needed',
      times: [],
      note: 'Before bedtime',
      hasAlarm: false,
    ),
    _ActiveMed(
      imagePath: 'assets/MedicationAssets/sunscreen 2.png',
      name: 'Triamcinolone 0.1% Cream',
      frequency: 'Apply morning and evening',
      times: ['09:00 AM', '09:00 PM'],
      note: 'Apply to affected skin',
      hasAlarm: true,
    ),
  ];

  static const historyMeds = [
    _HistoryMed(
      name: 'Cetirizine 10mg',
      type: 'Tablet',
      startDate: 'Feb 1, 2024',
      endDate: 'Apr 1, 2024',
      reasonStopped: 'Seasonal allergy symptoms resolved',
      prescribedBy: 'Dr. Nina Roberts',
      remarks: 'Worked well during spring pollen season',
    ),
    _HistoryMed(
      name: 'Fluticasone Nasal Spray 50 mcg',
      type: 'Nasal Spray',
      startDate: 'Sep 15, 2023',
      endDate: 'Sep 15, 2023',
      reasonStopped: 'Switched to Montelukast for better symptom control',
      prescribedBy: 'Dr. Andrew Chen',
      remarks: 'Mild dryness in nose',
    ),
    _HistoryMed(
      name: 'Albuterol Inhaler (90 mcg)',
      type: 'Inhaler',
      startDate: 'Jan 2023',
      endDate: 'Aug 2023',
      reasonStopped: 'Expired — replaced with new inhaler',
      prescribedBy: 'Dr. Linda Morales',
      remarks: 'Emergency use only',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _tabController.index == 0;
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
              if (isActive)
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add,
                      color: AppColors.primary, size: 20),
                )
              else
                const SizedBox(width: 36),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Tabs ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.t3SB,
              unselectedLabelStyle: AppTextStyles.t3R,
              indicatorColor: AppColors.textPrimary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: AppColors.surfaceBorder.withValues(alpha: 0.4),
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
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191F28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF48505B), width: 0.3),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 62, width: 62,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 1, 1, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image(image: AssetImage(med.imagePath)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name,
                    style: const TextStyle(
                        fontFamily: 'Inter', fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDBDBDB))),
                const SizedBox(height: 4),
                Text(med.frequency,
                    style: const TextStyle(
                        fontFamily: 'Inter', fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999))),
                const SizedBox(height: 12),
                Container(height: 0.5, color: const Color(0xFF48505B)),
                const SizedBox(height: 10),
                if (med.times.isNotEmpty)
                  Text(med.times.join('  |  '),
                      style: const TextStyle(
                          fontFamily: 'Inter', fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF999999))),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'Inter', fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999)),
                    children: [
                      const TextSpan(text: 'Note: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(text: med.note),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('More details',
                      style: TextStyle(
                          fontFamily: 'Inter', fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9A86E3))),
                  const Spacer(),
                  Icon(Icons.alarm_rounded, size: 20,
                      color: med.hasAlarm
                          ? const Color(0xFF9A86E3)
                          : const Color(0xFF66747F)),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_vert_rounded,
                      size: 20, color: Color(0xFF66747F)),
                ]),
              ],
            ),
          )
        ],
      ),
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
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: AppTextStyles.t4R.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: AppTextStyles.t4R.copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _FilterSheet(),
            ),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.tune_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text('Filter', style: AppTextStyles.t4M.copyWith(color: AppColors.textPrimary)),
              ]),
            ),
          ),
        ]),
      ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(med.name, style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        _InfoRow('Type', med.type),
        _InfoRow('Start Date', med.startDate),
        _InfoRow('End Date', med.endDate),
        _InfoRow('Reason Stopped', med.reasonStopped),
        _InfoRow('Prescribed By', med.prescribedBy),
        _InfoRow('Remarks', med.remarks),
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
          style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary),
          children: [
            TextSpan(text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w400)),
            TextSpan(text: value,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
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
  const MedListBody({super.key});

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
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _tabController.index == 0;
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(children: [
            const Spacer(),
            Text('Medications',
                style: AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary)),
            const Spacer(),
            if (isActive)
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: AppColors.primary, size: 20),
              )
            else
              const SizedBox(width: 36),
          ]),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.t3SB,
            unselectedLabelStyle: AppTextStyles.t3R,
            indicatorColor: AppColors.textPrimary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: AppColors.surfaceBorder.withValues(alpha: 0.4),
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
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Filter bottom sheet
// ─────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final Set<String> _medTypes      = {};
  final Set<String> _conditions    = {};
  final Set<String> _dateRanges    = {};
  final Set<String> _reasonStopped = {};
  String?           _sortBy;

  static const _medTypeOptions   = ['Tablet','Inhaler','Cream','Syrup','Nasal Spray','Other'];
  static const _conditionOptions = ['Asthma','Allergy','Mental Health','Cardiac','Diabetes','General Use','Pain','Skin Issues'];
  static const _dateRangeOptions = ['Last 3 months','Last 6 months','Last 12 months'];
  static const _reasonOptions    = ['Completed course','Replaced by another','Side effects','No longer needed'];
  static const _sortOptions      = ['Most recent','Oldest first','A–Z by name','By condition'];

  void _reset() => setState(() {
    _medTypes.clear(); _conditions.clear();
    _dateRanges.clear(); _reasonStopped.clear();
    _sortBy = null;
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        Container(
          width: 40, height: 4, margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(children: [
            Text('Filter', style: AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary)),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: AppColors.textPrimary, size: 16),
              ),
            ),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _reset,
                  child: Text('Reset', style: AppTextStyles.t3R.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 8),
              _FilterSection(title: 'Type of Medication', options: _medTypeOptions, selected: _medTypes,
                  onToggle: (v) => setState(() => _medTypes.contains(v) ? _medTypes.remove(v) : _medTypes.add(v))),
              _divider(),
              _FilterSection(title: 'Condition Treated', options: _conditionOptions, selected: _conditions,
                  onToggle: (v) => setState(() => _conditions.contains(v) ? _conditions.remove(v) : _conditions.add(v))),
              _divider(),
              _FilterSection(title: 'Date Range', options: _dateRangeOptions, selected: _dateRanges,
                  onToggle: (v) => setState(() => _dateRanges.contains(v) ? _dateRanges.remove(v) : _dateRanges.add(v))),
              _divider(),
              _FilterSection(title: 'Reason Stopped', options: _reasonOptions, selected: _reasonStopped,
                  onToggle: (v) => setState(() => _reasonStopped.contains(v) ? _reasonStopped.remove(v) : _reasonStopped.add(v))),
              _divider(),
              Text('Sort By', style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ..._sortOptions.map((o) => GestureDetector(
                onTap: () => setState(() => _sortBy = o),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _sortBy == o ? AppColors.primary : AppColors.surfaceBorder,
                          width: _sortBy == o ? 5.5 : 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(o, style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary)),
                  ]),
                ),
              )),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Apply', style: AppTextStyles.t2SB.copyWith(color: AppColors.white100)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Divider(height: 1, thickness: 0.5,
        color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
  );
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _FilterSection({
    required this.title, required this.options,
    required this.selected, required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8,
        children: options.map((o) {
          final isSel = selected.contains(o);
          return GestureDetector(
            onTap: () => onToggle(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSel ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSel ? AppColors.primary : AppColors.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (isSel) ...[
                  const Icon(Icons.check, color: AppColors.white100, size: 14),
                  const SizedBox(width: 4),
                ],
                Text(o, style: AppTextStyles.t4R.copyWith(
                  color: isSel ? AppColors.white100 : AppColors.textPrimary)),
              ]),
            ),
          );
        }).toList(),
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
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const _items = [
    _NavItem('assets/HomeAssets/nav/home 1.png', 'Home'),
    _NavItem('assets/HomeAssets/nav/pill (1) 2.png', 'Med'),
    _NavItem('assets/HomeAssets/nav/Groupnav.png', 'Appt'),
    _NavItem('assets/HomeAssets/nav/Groupmshnav.png', 'Chat'),
    _NavItem('assets/HomeAssets/nav/Group 1000011516.png', 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1017),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
          color: AppColors.surfaceBorder.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 16 : 12, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
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