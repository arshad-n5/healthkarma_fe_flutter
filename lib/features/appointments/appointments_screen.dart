import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class _UpcomingAppt {
  final String title;
  final String day;
  final String monthYear;
  final String weekday;
  final String time;
  final String providerName;
  final String providerSpecialty;
  final String appointmentType;
  final bool isVideo;
  final String lifestyleRisks;
  final String allergies;

  const _UpcomingAppt({
    required this.title,
    required this.day,
    required this.monthYear,
    required this.weekday,
    required this.time,
    required this.providerName,
    required this.providerSpecialty,
    required this.appointmentType,
    this.isVideo = true,
    required this.lifestyleRisks,
    required this.allergies,
  });
}

class _PastAppt {
  final String date;
  final String title;
  final String doctorName;
  final String specialty;
  final String location;
  final bool isTelehealth;
  final String outcome;
  final String actionLabel;

  const _PastAppt({
    required this.date,
    required this.title,
    required this.doctorName,
    required this.specialty,
    required this.location,
    this.isTelehealth = false,
    required this.outcome,
    required this.actionLabel,
  });
}

class _CancelledAppt {
  final String date;
  final String title;
  final String doctorName;
  final String specialty;
  final String reason;

  const _CancelledAppt({
    required this.date,
    required this.title,
    required this.doctorName,
    required this.specialty,
    required this.reason,
  });
}

const _upcomingAppts = [
  _UpcomingAppt(
    title: 'Pulmonology Check-Up',
    day: '05',
    monthYear: 'JUNE 2025',
    weekday: 'MONDAY',
    time: '10:00 AM ET',
    providerName: 'Sara Collins',
    providerSpecialty: 'Pulmonologist',
    appointmentType: 'Video Consultation (15 min)',
    isVideo: true,
    lifestyleRisks: 'Chain Smoker, Alcoholic',
    allergies:
        'Peanuts, Medication allergies, Shellfish, Pollen, Animal dander',
  ),
];

const _pastAppts = [
  _PastAppt(
    date: 'May 2, 2025 – 10:00 AM',
    title: 'Pulmonology Follow-Up',
    doctorName: 'Dr. Emily Carter',
    specialty: 'Pulmonologist',
    location: 'U.S. Allergy & Asthma Center, Phoenix, AZ',
    isTelehealth: false,
    outcome: 'Reviewed asthma control; adjusted inhaler dosage',
    actionLabel: 'View Summary',
  ),
  _PastAppt(
    date: 'April 12, 2025 – 2:30 PM',
    title: 'Virtual Consultation – Allergy Check',
    doctorName: 'Dr. Michael Lee',
    specialty: 'Allergist',
    location: 'Telehealth Visit',
    isTelehealth: true,
    outcome: 'Discussed pollen triggers and prescribed nasal spray',
    actionLabel: 'View Notes',
  ),
  _PastAppt(
    date: 'March 5, 2025 – 9:00 AM',
    title: 'Pulmonary Function Test',
    doctorName: 'Dr. Sarah Kim',
    specialty: 'Pulmonologist',
    location: 'Banner Health Diagnostics, Mesa, AZ',
    isTelehealth: false,
    outcome: 'Moderate airflow limitation confirmed',
    actionLabel: 'Download Report',
  ),
];

const _cancelledAppts = [
  _CancelledAppt(
    date: 'Feb 20, 2025 – 11:00 AM',
    title: 'Cardiology Consultation',
    doctorName: 'Dr. James Patel',
    specialty: 'Cardiologist',
    reason: 'Patient cancelled — scheduling conflict',
  ),
  _CancelledAppt(
    date: 'Jan 8, 2025 – 3:00 PM',
    title: 'Dermatology Follow-Up',
    doctorName: 'Dr. Laura Nguyen',
    specialty: 'Dermatologist',
    reason: 'Provider unavailable — rescheduled',
  ),
];

class AppointmentsBody extends StatefulWidget {
  const AppointmentsBody({super.key});

  @override
  State<AppointmentsBody> createState() => _AppointmentsBodyState();
}

class _AppointmentsBodyState extends State<AppointmentsBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(children: [
            const Spacer(),
            Text('Appointments',
                style:
                    AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary)),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
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
              Tab(text: 'Upcoming(01)'),
              Tab(text: 'Past'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _UpcomingTab(),
              _PastTab(),
              _CancelledTab(),
            ],
          ),
        ),
      ]),
    );
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
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
      body: const AppointmentsBody(),
    );
  }
}

class _UpcomingTab extends StatefulWidget {
  const _UpcomingTab();

  @override
  State<_UpcomingTab> createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<_UpcomingTab> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: _upcomingAppts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final appt = _upcomingAppts[i];
        final isExpanded = _expandedIndex == i;
        return _UpcomingCard(
          appt: appt,
          isExpanded: isExpanded,
          onToggle: () =>
              setState(() => _expandedIndex = isExpanded ? null : i),
        );
      },
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final _UpcomingAppt appt;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _UpcomingCard({
    required this.appt,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.surfaceBorder.withValues(alpha: 0.4), width: 0.5),
      ),
      child: isExpanded
          ? _ExpandedBody(appt: appt, onToggle: onToggle)
          : _CollapsedHeader(appt: appt, onToggle: onToggle),
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  final _UpcomingAppt appt;
  final VoidCallback onToggle;

  const _CollapsedHeader({required this.appt, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(appt.title,
            style: AppTextStyles.t1SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.calendar_today_outlined,
              size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text('${appt.day} ${appt.monthYear}',
              style: AppTextStyles.t4R.copyWith(
                  color: AppColors.textSecondary, letterSpacing: 0.4)),
          const Spacer(),
          const Icon(Icons.access_time_outlined,
              size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(appt.time,
              style:
                  AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _JoinButton(onTap: () {}),
          const Spacer(),
          GestureDetector(
            onTap: onToggle,
            child: Text('View Details',
                style: AppTextStyles.t4R.copyWith(color: AppColors.primary)),
          ),
        ]),
      ]),
    );
  }
}

class _ExpandedBody extends StatelessWidget {
  final _UpcomingAppt appt;
  final VoidCallback onToggle;

  const _ExpandedBody({required this.appt, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1017),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Text(appt.day,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1,
                )),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(appt.monthYear,
                  style: AppTextStyles.t4R.copyWith(
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              Text(appt.weekday,
                  style: AppTextStyles.t4R.copyWith(
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
            ]),
            const Spacer(),
            const Icon(Icons.access_time_outlined,
                size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(appt.time,
                style:
                    AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(height: 14),
        Text(appt.title,
            style: AppTextStyles.t1SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Provider',
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Row(children: [
          Text(appt.providerName,
              style: AppTextStyles.t3SB.copyWith(color: AppColors.textPrimary)),
          const SizedBox(width: 8),
          Container(width: 1, height: 14, color: AppColors.surfaceBorder),
          const SizedBox(width: 8),
          Text(appt.providerSpecialty,
              style:
                  AppTextStyles.t3R.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 12),
        Text('Appointment Type',
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.videocam, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Text(appt.appointmentType,
              style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 14),
        Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
        const SizedBox(height: 14),
        Row(children: [
          Text('Lifestyle and Risk Factors',
              style:
                  AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text('Edit',
              style:
                  AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 4),
        Text(appt.lifestyleRisks,
            style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Text('Allergies',
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(appt.allergies,
            style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
        const SizedBox(height: 14),
        Row(children: [
          _JoinButton(onTap: () {}),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: Text('Reschedule',
                style: AppTextStyles.t4R.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: Text('Cancel',
                style: AppTextStyles.t4R.copyWith(color: AppColors.primary)),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onToggle,
            child: const Icon(Icons.keyboard_arrow_up_rounded,
                color: AppColors.textSecondary, size: 22),
          ),
        ]),
      ]),
    );
  }
}

class _JoinButton extends StatelessWidget {
  final VoidCallback onTap;
  const _JoinButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D45),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Join',
            style: AppTextStyles.t4M.copyWith(color: AppColors.textPrimary)),
      ),
    );
  }
}

class _PastTab extends StatefulWidget {
  const _PastTab();

  @override
  State<_PastTab> createState() => _PastTabState();
}

class _PastTabState extends State<_PastTab> {
  final _searchCtrl = TextEditingController();
  _ApptFilter _filter = const _ApptFilter();

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

  List<_PastAppt> get _filtered {
    List<_PastAppt> result = List.from(_pastAppts);
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.doctorName.toLowerCase().contains(q) ||
              a.specialty.toLowerCase().contains(q))
          .toList();
    }
    if (_filter.specialties.isNotEmpty) {
      result = result
          .where((a) => _filter.specialties
              .any((s) => a.specialty.toLowerCase() == s.toLowerCase()))
          .toList();
    }
    if (_filter.visitTypes.isNotEmpty) {
      result = result.where((a) {
        final isTelematch =
            _filter.visitTypes.contains('Telehealth') && a.isTelehealth;
        final isInPersonMatch =
            _filter.visitTypes.contains('In-Person') && !a.isTelehealth;
        return isTelematch || isInPersonMatch;
      }).toList();
    }
    return result;
  }

  int get _filterCount =>
      _filter.specialties.length +
      _filter.visitTypes.length +
      _filter.dateRanges.length;

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
                  borderRadius: BorderRadius.circular(10)),
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
              final result = await showModalBottomSheet<_ApptFilter>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _ApptFilterSheet(initialFilter: _filter),
              );
              if (result != null) setState(() => _filter = result);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _filterCount > 0
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: _filterCount > 0
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 1)
                        : null,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.filter_list_rounded,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 6),
                    Text('Filter',
                        style: AppTextStyles.t4M
                            .copyWith(color: AppColors.textPrimary)),
                  ]),
                ),
                if (_filterCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                      child: Center(
                        child: Text('$_filterCount',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]),
      ),
      Expanded(
        child: results.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.search_off_rounded,
                    size: 48, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text('No appointments found',
                    style: AppTextStyles.t2SB
                        .copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text('Try adjusting your search or filters',
                    style: AppTextStyles.t4R
                        .copyWith(color: AppColors.textSecondary)),
              ]))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _PastApptCard(appt: results[i]),
              ),
      ),
    ]);
  }
}

class _PastApptCard extends StatelessWidget {
  final _PastAppt appt;
  const _PastApptCard({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.surfaceBorder.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(appt.date,
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Text(appt.title,
            style: AppTextStyles.t1SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.person_outline,
              size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(appt.doctorName,
              style: AppTextStyles.t4R.copyWith(color: AppColors.textPrimary)),
          Text(' - ${appt.specialty}',
              style:
                  AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Icon(
            appt.isTelehealth
                ? Icons.phone_outlined
                : Icons.location_on_outlined,
            size: 15,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(appt.location,
                style:
                    AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
          ),
        ]),
        const SizedBox(height: 10),
        Text('Outcome:',
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(appt.outcome,
            style: AppTextStyles.t4R.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: Text(appt.actionLabel,
              style: AppTextStyles.t4R.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              )),
        ),
      ]),
    );
  }
}

class _CancelledTab extends StatelessWidget {
  const _CancelledTab();

  @override
  Widget build(BuildContext context) {
    if (_cancelledAppts.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cancel_outlined,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('No cancelled appointments',
              style: AppTextStyles.t2SB.copyWith(color: AppColors.textPrimary)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: _cancelledAppts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _CancelledApptCard(appt: _cancelledAppts[i]),
    );
  }
}

class _CancelledApptCard extends StatelessWidget {
  final _CancelledAppt appt;
  const _CancelledApptCard({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.surfaceBorder.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(appt.date,
            style: AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Text(appt.title,
            style: AppTextStyles.t1SB.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.person_outline,
              size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(appt.doctorName,
              style: AppTextStyles.t4R.copyWith(color: AppColors.textPrimary)),
          Text(' - ${appt.specialty}',
              style:
                  AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(appt.reason,
                style:
                    AppTextStyles.t4R.copyWith(color: AppColors.textSecondary)),
          ),
        ]),
      ]),
    );
  }
}

class _ApptFilter {
  final Set<String> specialties;
  final Set<String> visitTypes;
  final Set<String> dateRanges;

  const _ApptFilter({
    this.specialties = const {},
    this.visitTypes = const {},
    this.dateRanges = const {},
  });
}

class _ApptFilterSheet extends StatefulWidget {
  final _ApptFilter initialFilter;
  const _ApptFilterSheet({required this.initialFilter});

  @override
  State<_ApptFilterSheet> createState() => _ApptFilterSheetState();
}

class _ApptFilterSheetState extends State<_ApptFilterSheet> {
  late Set<String> _specialties;
  late Set<String> _visitTypes;
  late Set<String> _dateRanges;

  static const _specialtyOptions = [
    'Pulmonologist',
    'Allergist',
    'Cardiologist',
    'Dermatologist',
    'General Practitioner',
  ];
  static const _visitTypeOptions = ['Telehealth', 'In-Person'];
  static const _dateRangeOptions = [
    'Last 3 months',
    'Last 6 months',
    'Last 12 months',
  ];

  @override
  void initState() {
    super.initState();
    _specialties = Set.from(widget.initialFilter.specialties);
    _visitTypes = Set.from(widget.initialFilter.visitTypes);
    _dateRanges = Set.from(widget.initialFilter.dateRanges);
  }

  void _reset() => setState(() {
        _specialties.clear();
        _visitTypes.clear();
        _dateRanges.clear();
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
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
              borderRadius: BorderRadius.circular(2)),
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
                title: 'Specialty',
                options: _specialtyOptions,
                selected: _specialties,
                onToggle: (v) => setState(() => _specialties.contains(v)
                    ? _specialties.remove(v)
                    : _specialties.add(v)),
              ),
              _divider(),
              _FilterSection(
                title: 'Visit Type',
                options: _visitTypeOptions,
                selected: _visitTypes,
                onToggle: (v) => setState(() => _visitTypes.contains(v)
                    ? _visitTypes.remove(v)
                    : _visitTypes.add(v)),
              ),
              _divider(),
              _FilterSection(
                title: 'Date Range',
                options: _dateRangeOptions,
                selected: _dateRanges,
                onToggle: (v) => setState(() => _dateRanges.contains(v)
                    ? _dateRanges.remove(v)
                    : _dateRanges.add(v)),
              ),
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
              onPressed: () => Navigator.pop(
                context,
                _ApptFilter(
                  specialties: _specialties,
                  visitTypes: _visitTypes,
                  dateRanges: _dateRanges,
                ),
              ),
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
                Text(o,
                    style: AppTextStyles.t4R.copyWith(
                      color:
                          isSel ? AppColors.white100 : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    )),
              ]),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
