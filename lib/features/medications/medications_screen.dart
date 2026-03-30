import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

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
  final String condition;

  const _HistoryMed({
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reasonStopped,
    required this.prescribedBy,
    required this.remarks,
    this.condition = '',
  });
}

class _FilterState {
  final Set<String> medTypes;
  final Set<String> conditions;
  final Set<String> dateRanges;
  final Set<String> reasonsStopped;
  final String? sortBy;

  const _FilterState({
    this.medTypes = const {},
    this.conditions = const {},
    this.dateRanges = const {},
    this.reasonsStopped = const {},
    this.sortBy,
  });

  bool get isEmpty =>
      medTypes.isEmpty &&
      conditions.isEmpty &&
      dateRanges.isEmpty &&
      reasonsStopped.isEmpty &&
      sortBy == null;

  _FilterState copyWith({
    Set<String>? medTypes,
    Set<String>? conditions,
    Set<String>? dateRanges,
    Set<String>? reasonsStopped,
    String? sortBy,
    bool clearSort = false,
  }) {
    return _FilterState(
      medTypes: medTypes ?? this.medTypes,
      conditions: conditions ?? this.conditions,
      dateRanges: dateRanges ?? this.dateRanges,
      reasonsStopped: reasonsStopped ?? this.reasonsStopped,
      sortBy: clearSort ? null : (sortBy ?? this.sortBy),
    );
  }
}

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
      reasonStopped: 'Completed course',
      prescribedBy: 'Dr. Nina Roberts',
      remarks: 'Worked well during spring pollen season',
      condition: 'Allergy',
    ),
    _HistoryMed(
      name: 'Fluticasone Nasal Spray 50 mcg',
      type: 'Nasal Spray',
      startDate: 'Sep 15, 2023',
      endDate: 'Sep 15, 2023',
      reasonStopped: 'Replaced by another',
      prescribedBy: 'Dr. Andrew Chen',
      remarks: 'Mild dryness in nose',
      condition: 'Asthma',
    ),
    _HistoryMed(
      name: 'Albuterol Inhaler (90 mcg)',
      type: 'Inhaler',
      startDate: 'Jan 2023',
      endDate: 'Aug 2023',
      reasonStopped: 'No longer needed',
      prescribedBy: 'Dr. Linda Morales',
      remarks: 'Emergency use only',
      condition: 'Asthma',
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.add, color: AppColors.primary, size: 20),
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
                  height: 62,
                  width: 62,
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
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDBDBDB))),
                const SizedBox(height: 4),
                Text(med.frequency,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999))),
                const SizedBox(height: 12),
                Container(height: 0.5, color: const Color(0xFF48505B)),
                const SizedBox(height: 10),
                if (med.times.isNotEmpty)
                  Text(med.times.join('  |  '),
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF999999))),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999)),
                    children: [
                      const TextSpan(
                          text: 'Note: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(text: med.note),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('More details',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9A86E3))),
                  const Spacer(),
                  Icon(Icons.alarm_rounded,
                      size: 20,
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

class _HistoryTab extends StatefulWidget {
  final List<_HistoryMed> meds;
  const _HistoryTab({required this.meds});

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final _searchCtrl = TextEditingController();
  _FilterState _filter = const _FilterState();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_HistoryMed> get _filtered {
    List<_HistoryMed> result = List.from(widget.meds);

    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where((m) =>
              m.name.toLowerCase().contains(query) ||
              m.type.toLowerCase().contains(query) ||
              m.condition.toLowerCase().contains(query))
          .toList();
    }

    if (_filter.medTypes.isNotEmpty) {
      result = result
          .where((m) => _filter.medTypes
              .any((t) => m.type.toLowerCase() == t.toLowerCase()))
          .toList();
    }

    if (_filter.conditions.isNotEmpty) {
      result = result
          .where((m) => _filter.conditions
              .any((c) => m.condition.toLowerCase() == c.toLowerCase()))
          .toList();
    }

    if (_filter.reasonsStopped.isNotEmpty) {
      result = result
          .where((m) => _filter.reasonsStopped.any(
              (r) => m.reasonStopped.toLowerCase().contains(r.toLowerCase())))
          .toList();
    }

    if (_filter.sortBy != null) {
      switch (_filter.sortBy) {
        case 'A–Z by name':
          result.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'By condition':
          result.sort((a, b) => a.condition.compareTo(b.condition));
          break;
        case 'Most recent':
          result = result.reversed.toList();
          break;
        case 'Oldest first':
          break;
      }
    }

    return result;
  }

  int get _activeFilterCount =>
      _filter.medTypes.length +
      _filter.conditions.length +
      _filter.dateRanges.length +
      _filter.reasonsStopped.length +
      (_filter.sortBy != null ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

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
                  hintStyle:
                      AppTextStyles.t4R.copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textMuted, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<_FilterState>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _FilterSheet(initialFilter: _filter),
              );
              if (result != null) {
                setState(() => _filter = result);
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _activeFilterCount > 0
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: _activeFilterCount > 0
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 1)
                        : null,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.tune_rounded,
                        color: _activeFilterCount > 0
                            ? AppColors.primary
                            : AppColors.primary,
                        size: 16),
                    const SizedBox(width: 6),
                    Text('Filter',
                        style: AppTextStyles.t4M
                            .copyWith(color: AppColors.textPrimary)),
                  ]),
                ),
                if (_activeFilterCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$_activeFilterCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]),
      ),
      if (_activeFilterCount > 0)
        _ActiveFilterChipsRow(
          filter: _filter,
          onClearAll: () => setState(() => _filter = const _FilterState()),
          onRemoveType: (t) => setState(() => _filter = _filter.copyWith(
              medTypes: Set.from(_filter.medTypes)..remove(t))),
          onRemoveCondition: (c) => setState(() => _filter = _filter.copyWith(
              conditions: Set.from(_filter.conditions)..remove(c))),
          onRemoveDateRange: (d) => setState(() => _filter = _filter.copyWith(
              dateRanges: Set.from(_filter.dateRanges)..remove(d))),
          onRemoveReason: (r) => setState(() => _filter = _filter.copyWith(
              reasonsStopped: Set.from(_filter.reasonsStopped)..remove(r))),
          onClearSort: () =>
              setState(() => _filter = _filter.copyWith(clearSort: true)),
        ),
      Expanded(
        child: results.isEmpty
            ? _EmptyFilterResult(
                onClear: () => setState(() => _filter = const _FilterState()),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _HistoryMedCard(med: results[i]),
              ),
      ),
    ]);
  }
}

class _ActiveFilterChipsRow extends StatelessWidget {
  final _FilterState filter;
  final VoidCallback onClearAll;
  final ValueChanged<String> onRemoveType;
  final ValueChanged<String> onRemoveCondition;
  final ValueChanged<String> onRemoveDateRange;
  final ValueChanged<String> onRemoveReason;
  final VoidCallback onClearSort;

  const _ActiveFilterChipsRow({
    required this.filter,
    required this.onClearAll,
    required this.onRemoveType,
    required this.onRemoveCondition,
    required this.onRemoveDateRange,
    required this.onRemoveReason,
    required this.onClearSort,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    for (final t in filter.medTypes) {
      chips.add(_RemovableChip(label: t, onRemove: () => onRemoveType(t)));
    }
    for (final c in filter.conditions) {
      chips.add(_RemovableChip(label: c, onRemove: () => onRemoveCondition(c)));
    }
    for (final d in filter.dateRanges) {
      chips.add(_RemovableChip(label: d, onRemove: () => onRemoveDateRange(d)));
    }
    for (final r in filter.reasonsStopped) {
      chips.add(_RemovableChip(label: r, onRemove: () => onRemoveReason(r)));
    }
    if (filter.sortBy != null) {
      chips.add(_RemovableChip(label: filter.sortBy!, onRemove: onClearSort));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: chips
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: c,
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClearAll,
            child: Text(
              'Clear all',
              style: AppTextStyles.t4R.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _RemovableChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label,
            style: AppTextStyles.t4R.copyWith(color: AppColors.textPrimary)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onRemove,
          child:
              const Icon(Icons.close, size: 12, color: AppColors.textSecondary),
        ),
      ]),
    );
  }
}

class _EmptyFilterResult extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyFilterResult({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.search_off_rounded,
            size: 48, color: AppColors.textMuted),
        const SizedBox(height: 16),
        Text('No medications found',
            style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Try adjusting your filters',
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onClear,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4), width: 1),
            ),
            child: Text('Clear filters',
                style: AppTextStyles.t4M.copyWith(color: AppColors.primary)),
          ),
        ),
      ]),
    );
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
        Text(med.name,
            style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        _InfoRow('Type', med.type),
        if (med.condition.isNotEmpty) _InfoRow('Condition', med.condition),
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
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w400)),
            TextSpan(
                text: value,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

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
                style:
                    AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary)),
            const Spacer(),
            if (isActive)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.add, color: AppColors.primary, size: 20),
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

class _FilterSheet extends StatefulWidget {
  final _FilterState initialFilter;
  const _FilterSheet({required this.initialFilter});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late Set<String> _medTypes;
  late Set<String> _conditions;
  late Set<String> _dateRanges;
  late Set<String> _reasonsStopped;
  late String? _sortBy;

  static const _medTypeOptions = [
    'Tablet',
    'Inhaler',
    'Cream',
    'Syrup',
    'Nasal Spray',
    'Other'
  ];
  static const _conditionOptions = [
    'Asthma',
    'Allergy',
    'Mental Health',
    'Cardiac',
    'Diabetes',
    'General Use',
    'Pain',
    'Skin Issues'
  ];
  static const _dateRangeOptions = [
    'Last 3 months',
    'Last 6 months',
    'Last 12 months'
  ];
  static const _reasonOptions = [
    'Completed course',
    'Replaced by another',
    'Side effects',
    'No longer needed'
  ];
  static const _sortOptions = [
    'Most recent',
    'Oldest first',
    'A–Z by name',
    'By condition'
  ];

  @override
  void initState() {
    super.initState();
    _medTypes = Set.from(widget.initialFilter.medTypes);
    _conditions = Set.from(widget.initialFilter.conditions);
    _dateRanges = Set.from(widget.initialFilter.dateRanges);
    _reasonsStopped = Set.from(widget.initialFilter.reasonsStopped);
    _sortBy = widget.initialFilter.sortBy;
  }

  void _reset() => setState(() {
        _medTypes.clear();
        _conditions.clear();
        _dateRanges.clear();
        _reasonsStopped.clear();
        _sortBy = null;
      });

  void _apply() => Navigator.pop(
        context,
        _FilterState(
          medTypes: _medTypes,
          conditions: _conditions,
          dateRanges: _dateRanges,
          reasonsStopped: _reasonsStopped,
          sortBy: _sortBy,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(children: [
            Text('Filter',
                style:
                    AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary)),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight, shape: BoxShape.circle),
                child: const Icon(Icons.close,
                    color: AppColors.textPrimary, size: 16),
              ),
            ),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _reset,
                  child: Text('Reset',
                      style:
                          AppTextStyles.t3R.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 8),
              _FilterSection(
                  title: 'Type of Medication',
                  options: _medTypeOptions,
                  selected: _medTypes,
                  onToggle: (v) => setState(() => _medTypes.contains(v)
                      ? _medTypes.remove(v)
                      : _medTypes.add(v))),
              _divider(),
              _FilterSection(
                  title: 'Condition Treated',
                  options: _conditionOptions,
                  selected: _conditions,
                  onToggle: (v) => setState(() => _conditions.contains(v)
                      ? _conditions.remove(v)
                      : _conditions.add(v))),
              _divider(),
              _FilterSection(
                  title: 'Date Range',
                  options: _dateRangeOptions,
                  selected: _dateRanges,
                  onToggle: (v) => setState(() => _dateRanges.contains(v)
                      ? _dateRanges.remove(v)
                      : _dateRanges.add(v))),
              _divider(),
              _FilterSection(
                  title: 'Reason Stopped',
                  options: _reasonOptions,
                  selected: _reasonsStopped,
                  onToggle: (v) => setState(() => _reasonsStopped.contains(v)
                      ? _reasonsStopped.remove(v)
                      : _reasonsStopped.add(v))),
              _divider(),
              Text('Sort By',
                  style: AppTextStyles.t2SB
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ..._sortOptions.map((o) => GestureDetector(
                    onTap: () => setState(() => _sortBy = o),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _sortBy == o
                                  ? AppColors.primary
                                  : AppColors.surfaceBorder,
                              width: _sortBy == o ? 5.5 : 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(o,
                            style: AppTextStyles.t3R
                                .copyWith(color: AppColors.textPrimary)),
                      ]),
                    ),
                  )),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Apply',
                  style:
                      AppTextStyles.t2SB.copyWith(color: AppColors.white100)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
      );
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((o) {
          final isSel = selected.contains(o);
          return GestureDetector(
            onTap: () => onToggle(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color:
                    isSel ? const Color(0xFF0D1017) : const Color(0xFF1E2330),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSel ? AppColors.white100 : AppColors.surfaceBorder,
                  width: isSel ? 1.5 : 1.0,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (isSel) ...[
                  const Icon(Icons.check, color: AppColors.white100, size: 13),
                  const SizedBox(width: 5),
                ],
                Text(
                  o,
                  style: AppTextStyles.t4R.copyWith(
                    color: isSel ? AppColors.white100 : AppColors.textSecondary,
                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ]),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}

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
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    color: const Color(0xFFEBEBEB),
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.circle_outlined,
                        color: Color(0xFFEBEBEB),
                        size: 22)),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Text(item.label,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
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
