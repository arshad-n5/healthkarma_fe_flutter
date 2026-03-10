// lib/features/profile/medications_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../routes/app_routes.dart';

// ─────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────

class _Medication {
  final String    name;
  final String    description;
  final String    type;
  final String    dosage;
  final TimeOfDay? schedule;
  final DateTime? startDate;
  final DateTime? endDate;
  final String    prescribedBy;
  final String    notes;
  final String    remarks;

  const _Medication({
    required this.name,
    required this.description,
    required this.type,
    required this.dosage,
    this.schedule,
    this.startDate,
    this.endDate,
    required this.prescribedBy,
    required this.notes,
    required this.remarks,
  });

  String get subtitle => description.isNotEmpty ? description : '';

  String fmtSchedule() {
    if (schedule == null) return '';
    final h  = schedule!.hourOfPeriod == 0 ? 12 : schedule!.hourOfPeriod;
    final m  = schedule!.minute.toString().padLeft(2, '0');
    final pm = schedule!.period == DayPeriod.pm ? 'PM' : 'AM';
    return '$h:$m $pm';
  }
}

// ─────────────────────────────────────────────
//  Medications Screen (main)
// ─────────────────────────────────────────────

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});
  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final List<_Medication> _saved         = [];
  int?                    _expandedIndex;

  // ── Add-more form controllers ─────────────
  final _nameCtrl       = TextEditingController();
  final _descCtrl       = TextEditingController();
  final _dosageCtrl     = TextEditingController();
  final _prescribedCtrl = TextEditingController();
  final _notesCtrl      = TextEditingController();
  final _remarksCtrl    = TextEditingController();
  String    _type           = 'Tablet';
  TimeOfDay? _schedule;
  DateTime? _startDate;
  DateTime? _endDate;
  bool      _showStartCal   = false;
  bool      _showEndCal     = false;
  DateTime  _startCalMonth  = DateTime.now();
  DateTime  _endCalMonth    = DateTime.now();

  static const _types = ['Tablet','Capsule','Syrup','Injection','Drops','Cream','Other'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _dosageCtrl.dispose();
    _prescribedCtrl.dispose(); _notesCtrl.dispose(); _remarksCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue => _saved.isNotEmpty;

  void _clearForm() {
    _nameCtrl.clear(); _descCtrl.clear(); _dosageCtrl.clear();
    _prescribedCtrl.clear(); _notesCtrl.clear(); _remarksCtrl.clear();
    setState(() {
      _type = 'Tablet'; _schedule = null;
      _startDate = null; _endDate = null;
      _showStartCal = false; _showEndCal = false;
    });
  }

  _Medication _buildMed() => _Medication(
    name: _nameCtrl.text.trim(), description: _descCtrl.text.trim(),
    type: _type, dosage: _dosageCtrl.text.trim(), schedule: _schedule,
    startDate: _startDate, endDate: _endDate,
    prescribedBy: _prescribedCtrl.text.trim(),
    notes: _notesCtrl.text.trim(), remarks: _remarksCtrl.text.trim(),
  );

  void _onAddMore() {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() { _saved.add(_buildMed()); _expandedIndex = null; });
    _clearForm();
  }

  void _onDelete(int index) {
    final med = _saved[index];
    showDialog(
      context: context,
      builder: (_) => _DeleteDialog(
        medName: med.name,
        onCancel: () => Navigator.pop(context),
        onDelete: () {
          Navigator.pop(context);
          setState(() {
            _saved.removeAt(index);
            if (_expandedIndex == index) _expandedIndex = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.surface,
              behavior:        SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 4),
              content: Row(
                children: [
                  Expanded(
                    child: Text('${med.name} has been deleted.',
                        style: AppTextStyles.t4R
                            .copyWith(color: AppColors.textPrimary)),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      setState(() => _saved.insert(index, med));
                    },
                    child: Text('Undo',
                        style: AppTextStyles.t4SB
                            .copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onEdit(int index) async {
    final updated = await Navigator.push<_Medication>(
      context,
      MaterialPageRoute(
        builder: (_) => _EditMedicationScreen(med: _saved[index]),
      ),
    );
    if (updated != null) {
      setState(() {
        _saved[index]  = updated;
        _expandedIndex = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context:     context,
      initialTime: _schedule ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary:   AppColors.primary,
            surface:   AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (t != null) setState(() => _schedule = t);
  }

  String _fmtDate(DateTime? d) => d == null ? ''
      : '${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}/${d.year}';

  void _onContinue() {
    if (!_canContinue) return;
    Navigator.pushNamed(context, AppRoutes.terms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:          AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(children: [
          _TopBar(onSkip: () {}),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Saved cards ──────────────────
                  ..._saved.asMap().entries.map((e) {
                    final i = e.key; final med = e.value;
                    final isExp = _expandedIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MedCard(
                        med: med, isExpanded: isExp,
                        onToggle: () => setState(() =>
                            _expandedIndex = isExp ? null : i),
                        onDelete: () => _onDelete(i),
                        onEdit:   () => _onEdit(i),
                      ),
                    );
                  }),

                  // ── Add form ─────────────────────
                  _FormCard(children: [
                    Text('Add medication',
                        style: AppTextStyles.t2SB
                            .copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 16),

                    _FieldLabel('Medication Name'),
                    _CtrlField(controller: _nameCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Description'),
                    _CtrlField(controller: _descCtrl),
                    const SizedBox(height: 12),

                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Type'),
                            _DropdownField(value: _type, items: _types,
                                onChanged: (v) => setState(() => _type = v!)),
                          ],
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Dosage'),
                            _CtrlField(controller: _dosageCtrl),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _FieldLabel('Schedule'),
                    _TappableField(
                      text:     _schedule != null
                          ? _Medication(name:'',description:'',type:'',dosage:'',
                              schedule:_schedule,prescribedBy:'',notes:'',remarks:'').fmtSchedule()
                          : '',
                      trailing: const Icon(Icons.access_time_rounded,
                          color: AppColors.textMuted, size: 18),
                      onTap:    _pickTime,
                    ),
                    const SizedBox(height: 12),

                    // Start + End date with inline calendars
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Start Date'),
                            _TappableField(
                              text:     _fmtDate(_startDate),
                              trailing: const Icon(Icons.calendar_month_outlined,
                                  color: AppColors.textMuted, size: 18),
                              onTap: () => setState(() {
                                _showStartCal = !_showStartCal;
                                _showEndCal   = false;
                              }),
                            ),
                          ],
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('End Date'),
                            _TappableField(
                              text:     _fmtDate(_endDate),
                              trailing: const Icon(Icons.calendar_month_outlined,
                                  color: AppColors.textMuted, size: 18),
                              onTap: () => setState(() {
                                _showEndCal   = !_showEndCal;
                                _showStartCal = false;
                              }),
                            ),
                          ],
                        )),
                      ],
                    ),

                    if (_showStartCal) ...[
                      const SizedBox(height: 10),
                      _InlineCalendar(
                        selectedDate:   _startDate,
                        displayMonth:   _startCalMonth,
                        onMonthChanged: (m) =>
                            setState(() => _startCalMonth = m),
                        onDateSelected: (d) => setState(() {
                          _startDate    = d;
                          _showStartCal = false;
                        }),
                      ),
                    ],
                    if (_showEndCal) ...[
                      const SizedBox(height: 10),
                      _InlineCalendar(
                        selectedDate:   _endDate,
                        displayMonth:   _endCalMonth,
                        onMonthChanged: (m) =>
                            setState(() => _endCalMonth = m),
                        onDateSelected: (d) => setState(() {
                          _endDate    = d;
                          _showEndCal = false;
                        }),
                      ),
                    ],
                    const SizedBox(height: 12),

                    _FieldLabel('Prescribed By'),
                    _CtrlField(controller: _prescribedCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Notes / Instructions'),
                    _CtrlField(controller: _notesCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Remarks'),
                    _CtrlField(controller: _remarksCtrl, minLines: 2),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _onAddMore,
                      child: Text('Add More',
                          style: AppTextStyles.t3SB
                              .copyWith(color: AppColors.primary)),
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _ContinueButton(active: _canContinue, onTap: _onContinue),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Edit Medication Screen
// ─────────────────────────────────────────────

class _EditMedicationScreen extends StatefulWidget {
  final _Medication med;
  const _EditMedicationScreen({required this.med});
  @override
  State<_EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<_EditMedicationScreen> {
  late final _nameCtrl       = TextEditingController(text: widget.med.name);
  late final _descCtrl       = TextEditingController(text: widget.med.description);
  late final _dosageCtrl     = TextEditingController(text: widget.med.dosage);
  late final _prescribedCtrl = TextEditingController(text: widget.med.prescribedBy);
  late final _notesCtrl      = TextEditingController(text: widget.med.notes);
  late final _remarksCtrl    = TextEditingController(text: widget.med.remarks);
  late String     _type      = widget.med.type;
  late TimeOfDay? _schedule  = widget.med.schedule;
  late DateTime?  _startDate = widget.med.startDate;
  late DateTime?  _endDate   = widget.med.endDate;
  bool _showStartCal  = false;
  bool _showEndCal    = false;
  DateTime _startCalMonth = DateTime.now();
  DateTime _endCalMonth   = DateTime.now();

  static const _types = ['Tablet','Capsule','Syrup','Injection','Drops','Cream','Other'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _dosageCtrl.dispose();
    _prescribedCtrl.dispose(); _notesCtrl.dispose(); _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context:     context,
      initialTime: _schedule ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary:   AppColors.primary,
            surface:   AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (t != null) setState(() => _schedule = t);
  }

  String _fmtTime(TimeOfDay? t) {
    if (t == null) return '';
    final h  = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m  = t.minute.toString().padLeft(2, '0');
    final pm = t.period == DayPeriod.pm ? 'PM' : 'AM';
    return '$h:$m $pm';
  }

  String _fmtDate(DateTime? d) => d == null ? ''
      : '${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}/${d.year}';

  void _onUpdate() {
    Navigator.pop(context, _Medication(
      name:         _nameCtrl.text.trim(),
      description:  _descCtrl.text.trim(),
      type:         _type,
      dosage:       _dosageCtrl.text.trim(),
      schedule:     _schedule,
      startDate:    _startDate,
      endDate:      _endDate,
      prescribedBy: _prescribedCtrl.text.trim(),
      notes:        _notesCtrl.text.trim(),
      remarks:      _remarksCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:          AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 6),
                  Text('Back',
                      style: AppTextStyles.t3R
                          .copyWith(color: AppColors.textPrimary)),
                ]),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormCard(children: [
                    Text('Edit medication',
                        style: AppTextStyles.t2SB
                            .copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 16),

                    _FieldLabel('Medication Name'),
                    _CtrlField(controller: _nameCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Description'),
                    _CtrlField(controller: _descCtrl),
                    const SizedBox(height: 12),

                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Type'),
                            _DropdownField(value: _type, items: _types,
                                onChanged: (v) =>
                                    setState(() => _type = v!)),
                          ],
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Dosage'),
                            _CtrlField(controller: _dosageCtrl),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _FieldLabel('Schedule'),
                    _TappableField(
                      text:     _fmtTime(_schedule),
                      trailing: const Icon(Icons.access_time_rounded,
                          color: AppColors.textMuted, size: 18),
                      onTap:    _pickTime,
                    ),
                    const SizedBox(height: 12),

                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Start Date'),
                            _TappableField(
                              text:     _fmtDate(_startDate),
                              trailing: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.textMuted, size: 18),
                              onTap: () => setState(() {
                                _showStartCal = !_showStartCal;
                                _showEndCal   = false;
                              }),
                            ),
                          ],
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('End Date'),
                            _TappableField(
                              text:     _fmtDate(_endDate),
                              trailing: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.textMuted, size: 18),
                              onTap: () => setState(() {
                                _showEndCal   = !_showEndCal;
                                _showStartCal = false;
                              }),
                            ),
                          ],
                        )),
                      ],
                    ),
                    if (_showStartCal) ...[
                      const SizedBox(height: 10),
                      _InlineCalendar(
                        selectedDate:   _startDate,
                        displayMonth:   _startCalMonth,
                        onMonthChanged: (m) =>
                            setState(() => _startCalMonth = m),
                        onDateSelected: (d) => setState(() {
                          _startDate    = d;
                          _showStartCal = false;
                        }),
                      ),
                    ],
                    if (_showEndCal) ...[
                      const SizedBox(height: 10),
                      _InlineCalendar(
                        selectedDate:   _endDate,
                        displayMonth:   _endCalMonth,
                        onMonthChanged: (m) =>
                            setState(() => _endCalMonth = m),
                        onDateSelected: (d) => setState(() {
                          _endDate    = d;
                          _showEndCal = false;
                        }),
                      ),
                    ],
                    const SizedBox(height: 12),

                    _FieldLabel('Prescribed By'),
                    _CtrlField(controller: _prescribedCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Notes / Instructions'),
                    _CtrlField(controller: _notesCtrl),
                    const SizedBox(height: 12),

                    _FieldLabel('Remarks'),
                    _CtrlField(controller: _remarksCtrl, minLines: 2),
                  ]),

                  const SizedBox(height: 24),

                  // ── Cancel / Update ───────────
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.surfaceBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Cancel',
                            style: AppTextStyles.t2M.copyWith(
                                color: AppColors.textPrimary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Update',
                            style: AppTextStyles.t2SB.copyWith(
                                color: AppColors.white100)),
                      ),
                    ),
                  ]),

                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Delete confirmation dialog
// ─────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final String      medName;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const _DeleteDialog({
    required this.medName,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:  AppColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Red trash icon
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color:  AppColors.alertRed.withOpacity(0.12),
              shape:  BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: AppColors.alertRed, size: 32),
          ),
          const SizedBox(height: 16),
          Text('Delete this medication?',
              style: AppTextStyles.h6SB
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            "You're about to delete $medName from your list. This action cannot be undone.",
            style:     AppTextStyles.t4R,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.surfaceBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text('Cancel',
                    style: AppTextStyles.t2M
                        .copyWith(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alertRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text('Delete',
                    style: AppTextStyles.t2SB
                        .copyWith(color: AppColors.white100)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Saved med card
// ─────────────────────────────────────────────

class _MedCard extends StatelessWidget {
  final _Medication  med;
  final bool         isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _MedCard({
    required this.med, required this.isExpanded,
    required this.onToggle, required this.onDelete, required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap:        onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.name,
                      style: AppTextStyles.t2SB
                          .copyWith(color: AppColors.textPrimary)),
                  if (med.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(med.subtitle,
                        style: AppTextStyles.t4R
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ],
              )),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted, size: 22,
              ),
            ]),
          ),
        ),
        if (isExpanded) ...[
          Divider(height: 1, thickness: 1,
              color: AppColors.surfaceBorder.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: onDelete,
                child: Text('Delete',
                    style: AppTextStyles.t3SB
                        .copyWith(color: AppColors.alertRed)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(width: 1, height: 14,
                    color: AppColors.surfaceBorder),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Text('Edit',
                    style: AppTextStyles.t3SB
                        .copyWith(color: AppColors.primary)),
              ),
            ]),
          ),
        ],
      ]),
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
    required this.selectedDate, required this.displayMonth,
    required this.onMonthChanged, required this.onDateSelected,
  });

  static const _weekdays = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
  static const _months   = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];

  List<DateTime?> _buildDays() {
    final first     = DateTime(displayMonth.year, displayMonth.month, 1);
    final daysCount = DateUtils.getDaysInMonth(
        displayMonth.year, displayMonth.month);
    final startWD   = first.weekday % 7;
    final cells     = <DateTime?>[];
    for (int i = 0; i < startWD; i++) cells.add(null);
    for (int d = 1; d <= daysCount; d++)
      cells.add(DateTime(displayMonth.year, displayMonth.month, d));
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final days  = _buildDays();
    final label = '${_months[displayMonth.month - 1]} ${displayMonth.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () {},
            child: Row(children: [
              Text(label,
                  style: AppTextStyles.t2SB
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right,
                  color: AppColors.textPrimary, size: 18),
            ]),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => onMonthChanged(
                DateTime(displayMonth.year, displayMonth.month - 1)),
            child: const Icon(Icons.chevron_left,
                color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onMonthChanged(
                DateTime(displayMonth.year, displayMonth.month + 1)),
            child: const Icon(Icons.chevron_right,
                color: AppColors.textPrimary, size: 22),
          ),
        ]),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _weekdays.map((d) => SizedBox(
            width: 32,
            child: Text(d, textAlign: TextAlign.center,
                style: AppTextStyles.t5M
                    .copyWith(color: AppColors.textMuted)),
          )).toList(),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap:     true,
          physics:        const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          children: days.map((day) {
            if (day == null) return const SizedBox.shrink();
            final isSel = selectedDate != null &&
                day.year == selectedDate!.year &&
                day.month == selectedDate!.month &&
                day.day   == selectedDate!.day;
            final isToday = day.year  == DateTime.now().year &&
                            day.month == DateTime.now().month &&
                            day.day   == DateTime.now().day;
            return GestureDetector(
              onTap: () => onDateSelected(day),
              child: Container(
                margin:     const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isSel
                      ? Border.all(color: AppColors.primary, width: 1)
                      : null,
                ),
                child: Center(child: Text('${day.day}',
                    style: AppTextStyles.t4R.copyWith(
                      color: isSel
                          ? AppColors.white100
                          : AppColors.textPrimary,
                      fontWeight: isSel || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ))),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Top bar  3/3
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back,
              color: AppColors.textPrimary, size: 22),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 44, height: 44,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value:           1.0,
              strokeWidth:     3,
              backgroundColor: AppColors.black200,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primary),
            ),
            Text('3/3',
                style: AppTextStyles.t5SB
                    .copyWith(color: AppColors.primary)),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medications', style: AppTextStyles.h6SB),
            Text('Set up your current meds', style: AppTextStyles.t5M),
          ],
        )),
        GestureDetector(
          onTap: onSkip,
          child: Text('Skip',
              style: AppTextStyles.t2M.copyWith(color: AppColors.primary)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared widgets
// ─────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: children),
  );
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

class _CtrlField extends StatelessWidget {
  final TextEditingController controller;
  final int                   minLines;
  const _CtrlField({required this.controller, this.minLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    minLines:   minLines,
    maxLines:   minLines == 1 ? 1 : 4,
    style: AppTextStyles.t2R.copyWith(color: AppColors.textPrimary),
    decoration: InputDecoration(
      filled: true, fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 1.5)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  );
}

class _TappableField extends StatelessWidget {
  final String       text;
  final Widget       trailing;
  final VoidCallback onTap;
  const _TappableField(
      {required this.text, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color:        AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Expanded(child: Text(text,
            style: AppTextStyles.t3R
                .copyWith(color: AppColors.textPrimary))),
        trailing,
      ]),
    ),
  );
}

class _DropdownField extends StatelessWidget {
  final String                value;
  final List<String>          items;
  final ValueChanged<String?> onChanged;
  const _DropdownField(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value, isExpanded: true,
        dropdownColor: AppColors.surface,
        style: AppTextStyles.t3R.copyWith(color: AppColors.textPrimary),
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            color: AppColors.textMuted, size: 18),
        items: items.map((i) =>
            DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

class _ContinueButton extends StatelessWidget {
  final bool active; final VoidCallback onTap;
  const _ContinueButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    height: 52,
    decoration: BoxDecoration(
      color: active ? AppColors.primary : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: active ? onTap : null,
        child: Center(child: Text('Continue',
            style: AppTextStyles.t2SB.copyWith(
              color: active ? AppColors.white100 : AppColors.textMuted))),
      ),
    ),
  );
}