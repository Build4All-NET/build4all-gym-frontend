import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../data/models/availability_model.dart';
import '../../data/models/pt_service_model.dart';
import '../../data/services/availability_service.dart';
import '../../data/services/pt_service_service.dart';
import '../../domain/entities/availability_entity.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_event.dart';

class BookSessionSheet extends StatefulWidget {
  final int    branchId;
  final int    tenantId;
  final int    trainerId;
  final bool   isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final DateTime selectedDate;

  const BookSessionSheet({
    super.key,
    required this.branchId,
    required this.tenantId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
    required this.selectedDate,
  });

  static Future<void> show(
    BuildContext context, {
    required int    branchId,
    required int    tenantId,
    required int    trainerId,
    required bool   isAdmin,
    required List<AdminTrainerCardModel> trainers,
    required DateTime selectedDate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TrainerPtSessionsBloc>(),
        child: BookSessionSheet(
          branchId:     branchId,
          tenantId:     tenantId,
          trainerId:    trainerId,
          isAdmin:      isAdmin,
          trainers:     trainers,
          selectedDate: selectedDate,
        ),
      ),
    );
  }

  @override
  State<BookSessionSheet> createState() => _BookSessionSheetState();
}

class _BookSessionSheetState extends State<BookSessionSheet> {
  final _formKey             = GlobalKey<FormState>();
  final _memberIdCtrl        = TextEditingController();
  final _memberPackageIdCtrl = TextEditingController();
  final _notesCtrl           = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay?    _startTime;
  TimeOfDay?    _endTime;

  List<AvailabilityEntity> _slots        = [];
  bool                     _slotsLoading = false;
  AvailabilityEntity?      _selectedSlot;

  List<PtServiceModel> _services        = [];
  bool                 _servicesLoading = false;
  PtServiceModel?      _selectedService;

  late int _assignedTrainerId;

  @override
  void initState() {
    super.initState();
    _selectedDate      = widget.selectedDate;
    _assignedTrainerId = widget.trainerId;
    _loadServices();
    _loadSlots();
  }

  @override
  void dispose() {
    _memberIdCtrl.dispose();
    _memberPackageIdCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSlots() async {
    setState(() => _slotsLoading = true);
    try {
      final list = await AvailabilityHttpService().getSlots(
        trainerId: _assignedTrainerId,
        branchId:  widget.branchId,
      );
      if (mounted) {
        setState(() {
          _slots        = list.map((m) => m.toEntity()).toList();
          _slotsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _slotsLoading = false);
    }
  }

  Future<void> _loadServices() async {
    setState(() => _servicesLoading = true);
    try {
      final list = await PtServiceService().getServices(tenantId: widget.tenantId);
      if (mounted) {
        setState(() {
          _services        = list.where((s) => s.isActive == true).toList();
          _servicesLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _servicesLoading = false);
    }
  }

  List<AvailabilityEntity> _slotsForDate(DateTime date) {
    final weekday = date.weekday; // 1=Mon…7=Sun — matches AvailabilityEntity.weekday
    return _slots.where((slot) {
      if (slot.isRecurring) return slot.weekday == weekday;
      return slot.specificDate != null &&
          slot.specificDate!.year  == date.year &&
          slot.specificDate!.month == date.month &&
          slot.specificDate!.day   == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  bool _isDayAvailable(DateTime date) => _slotsForDate(date).isNotEmpty;

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
      _startTime    = null;
      _endTime      = null;
    });
  }

  void _onSlotTapped(AvailabilityEntity slot) {
    final sp = slot.startTime.split(':');
    final ep = slot.endTime.split(':');
    setState(() {
      _selectedSlot = slot;
      _startTime = TimeOfDay(hour: int.parse(sp[0]), minute: int.parse(sp[1]));
      _endTime   = TimeOfDay(hour: int.parse(ep[0]), minute: int.parse(ep[1]));
    });
  }

  Future<void> _pickManualTime(bool isStart) async {
    final picked = await showTimePicker(
      context:     context,
      initialTime: isStart
          ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_endTime   ?? const TimeOfDay(hour: 10, minute: 0)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) _startTime = picked;
      else          _endTime   = picked;
    });
  }

  DateTime _toDateTime(TimeOfDay t) => DateTime(
    _selectedDate.year, _selectedDate.month, _selectedDate.day, t.hour, t.minute,
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.trainer_selectTimeSlot)),
      );
      return;
    }
    final userId = int.tryParse(_memberIdCtrl.text.trim());
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.trainer_enterValidMemberId)),
      );
      return;
    }
    final packageIdText = _memberPackageIdCtrl.text.trim();
    final memberPtPackageId = packageIdText.isNotEmpty ? int.tryParse(packageIdText) : null;

    context.read<TrainerPtSessionsBloc>().add(
      PtSessionCreateRequested(
        branchId:          widget.branchId,
        trainerId:         _assignedTrainerId,
        userId:            userId,
        serviceId:         _selectedService?.serviceId,
        memberPtPackageId: memberPtPackageId,
        startTime:         _toDateTime(_startTime!),
        endTime:           _toDateTime(_endTime!),
        notes:             _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs     = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;
    final daySlots = _slotsForDate(_selectedDate);

    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      minChildSize:     0.5,
      maxChildSize:     0.97,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: cs.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Handle ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.border.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
              child: Row(
                children: [
                  Text(l10n.trainer_bookSession,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: cs.label)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: cs.muted),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: cs.border.withOpacity(0.3)),
            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Trainer picker (admin) ───────────────────────────
                      if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
                        _label(l10n.trainer_assignToTrainer, cs),
                        const SizedBox(height: 8),
                        _dropdownBox(
                          cs: cs,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _assignedTrainerId,
                              isExpanded: true,
                              dropdownColor: cs.surface,
                              style: TextStyle(color: cs.label, fontSize: 14),
                              items: widget.trainers
                                  .map((t) => DropdownMenuItem(
                                        value: t.trainerId,
                                        child: Text(t.fullName),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() {
                                  _assignedTrainerId = v;
                                  _slots = [];
                                  _selectedSlot = null;
                                  _startTime = null;
                                  _endTime   = null;
                                });
                                _loadSlots();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── Calendar ─────────────────────────────────────────
                      _label(l10n.trainer_selectDate, cs),
                      const SizedBox(height: 12),
                      _slotsLoading
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: CircularProgressIndicator(color: cs.primary),
                              ),
                            )
                          : _InlineCalendar(
                              selectedDate:    _selectedDate,
                              onDaySelected:   _onDaySelected,
                              isDayAvailable:  _isDayAvailable,
                              cs:              cs,
                            ),
                      const SizedBox(height: 20),

                      // ── Time slot section ─────────────────────────────────
                      if (!_slotsLoading) ...[
                        _label(l10n.trainer_selectTimeLabel, cs),
                        const SizedBox(height: 10),
                        if (daySlots.isEmpty) ...[
                          // No availability banner
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:  cs.danger.withOpacity(0.08),
                              border: Border.all(color: cs.danger.withOpacity(0.25)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.event_busy_outlined,
                                    size: 18, color: cs.danger),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    l10n.trainer_noAvailabilityCustomTime,
                                    style: TextStyle(
                                        fontSize: 13, color: cs.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _manualTimeTile(l10n.trainer_startTime, _startTime, () => _pickManualTime(true), cs)),
                              const SizedBox(width: 12),
                              Expanded(child: _manualTimeTile(l10n.trainer_endTime, _endTime, () => _pickManualTime(false), cs)),
                            ],
                          ),
                        ] else ...[
                          // Slot chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: daySlots.map((slot) {
                              final isSelected = _selectedSlot == slot;
                              return GestureDetector(
                                onTap: () => _onSlotTapped(slot),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? cs.primary
                                        : cs.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? cs.primary
                                          : cs.border.withOpacity(0.5),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: cs.primary.withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: isSelected ? Colors.white : cs.muted,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${slot.startTime}  –  ${slot.endTime}',
                                        style: TextStyle(
                                          fontSize:   13,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : cs.label,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (_selectedSlot == null) ...[
                            const SizedBox(height: 8),
                            Text(l10n.trainer_tapSlotToSelect,
                                style: TextStyle(fontSize: 12, color: cs.muted)),
                          ],
                        ],
                      ],
                      const SizedBox(height: 20),

                      // ── Member ID ─────────────────────────────────────────
                      _label(l10n.trainer_memberIdLabel, cs),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller:  _memberIdCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: cs.label),
                        decoration:  _inputDec(l10n.trainer_enterMemberUserId, cs),
                        validator:   (v) =>
                            (v == null || v.trim().isEmpty || int.tryParse(v.trim()) == null)
                                ? l10n.trainer_enterValidMemberIdValidation
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Member Package ID ─────────────────────────────────
                      _label(l10n.trainer_memberPackageIdOptional, cs),
                      const SizedBox(height: 4),
                      Text(
                        l10n.trainer_linkSessionToPackage,
                        style: TextStyle(color: cs.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller:   _memberPackageIdCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: cs.label),
                        decoration:   _inputDec(l10n.trainer_leaveBlankIfNone, cs),
                        validator:    (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          if (int.tryParse(v.trim()) == null) return l10n.trainer_validNumberError;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ── Service ───────────────────────────────────────────
                      _label(l10n.trainer_serviceOptionalLabel, cs),
                      const SizedBox(height: 8),
                      if (_servicesLoading)
                        Center(child: CircularProgressIndicator(color: cs.primary))
                      else
                        _dropdownBox(
                          cs: cs,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PtServiceModel?>(
                              value:       _selectedService,
                              isExpanded:  true,
                              dropdownColor: cs.surface,
                              style: TextStyle(color: cs.label, fontSize: 14),
                              hint: Text(l10n.trainer_noService,
                                  style: TextStyle(color: cs.muted)),
                              items: [
                                DropdownMenuItem<PtServiceModel?>(
                                  value: null,
                                  child: Text(l10n.trainer_noService,
                                      style: TextStyle(color: cs.muted)),
                                ),
                                ..._services.map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s.name),
                                    )),
                              ],
                              onChanged: (v) => setState(() => _selectedService = v),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // ── Notes ─────────────────────────────────────────────
                      _label(l10n.trainer_notesOptionalLabel, cs),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines:   3,
                        style: TextStyle(color: cs.label),
                        decoration: _inputDec(l10n.trainer_notesHint, cs),
                      ),
                      const SizedBox(height: 28),

                      // ── Submit ────────────────────────────────────────────
                      SizedBox(
                        width:  double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(l10n.trainer_bookSession,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _manualTimeTile(
    String label, TimeOfDay? time, VoidCallback onTap, dynamic cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: cs.muted)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color:        cs.surface,
              border:       Border.all(color: cs.border.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  time == null ? AppLocalizations.of(context)!.trainer_pickTime : time.format(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: time == null ? cs.muted : cs.label,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownBox({required Widget child, required dynamic cs}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color:        cs.surface,
          border:       Border.all(color: cs.border.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      );

  Widget _label(String text, dynamic cs) => Text(
        text,
        style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: cs.label),
      );

  InputDecoration _inputDec(String hint, dynamic cs) => InputDecoration(
        hintText:  hint,
        hintStyle: TextStyle(color: cs.muted, fontSize: 14),
        filled:    true,
        fillColor: cs.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: cs.border.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: cs.border.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: cs.primary, width: 1.5),
        ),
      );
}

// ── Inline Calendar ───────────────────────────────────────────────────────────

class _InlineCalendar extends StatefulWidget {
  final DateTime               selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final bool Function(DateTime) isDayAvailable;
  final dynamic                cs;

  const _InlineCalendar({
    required this.selectedDate,
    required this.onDaySelected,
    required this.isDayAvailable,
    required this.cs,
  });

  @override
  State<_InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<_InlineCalendar> {
  late DateTime _focusedMonth;

  static const _dayHeaders = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
        widget.selectedDate.year, widget.selectedDate.month);
  }

  void _prevMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void _nextMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    final cs      = widget.cs;
    final today   = DateTime.now();
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    // offset: Monday = 0, Tuesday = 1, …, Sunday = 6
    final offset = (firstDay.weekday - 1) % 7;
    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      decoration: BoxDecoration(
        color:        cs.surface,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: cs.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // ── Month nav header ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                _navBtn(Icons.chevron_left_rounded, _prevMonth, cs),
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_focusedMonth),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: cs.label),
                  ),
                ),
                _navBtn(Icons.chevron_right_rounded, _nextMonth, cs),
              ],
            ),
          ),
          // ── Day-of-week headers ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: _dayHeaders
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: cs.muted)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 6),
          // ── Day grid ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Column(
              children: List.generate(rows, (row) {
                return Row(
                  children: List.generate(7, (col) {
                    final cellIndex = row * 7 + col;
                    final dayNum    = cellIndex - offset + 1;

                    if (dayNum < 1 || dayNum > daysInMonth) {
                      return const Expanded(child: SizedBox(height: 38));
                    }

                    final date = DateTime(
                        _focusedMonth.year, _focusedMonth.month, dayNum);
                    final isPast = date.isBefore(
                        DateTime(today.year, today.month, today.day));
                    final isToday = DateUtils.isSameDay(date, today);
                    final isSelected =
                        DateUtils.isSameDay(date, widget.selectedDate);
                    final isAvailable = !isPast && widget.isDayAvailable(date);

                    return Expanded(
                      child: GestureDetector(
                        onTap: isPast ? null : () => widget.onDaySelected(date),
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary
                                : isToday
                                    ? cs.primary.withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$dayNum',
                                style: TextStyle(
                                  fontSize:   13,
                                  fontWeight: isSelected || isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : isPast
                                          ? cs.muted.withOpacity(0.35)
                                          : cs.label,
                                ),
                              ),
                              if (isAvailable && !isSelected)
                                Container(
                                  width:  5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color:  cs.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (isAvailable && isSelected)
                                Container(
                                  width:  5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color:  Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          // ── Legend ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _legendDot(cs.success),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.trainer_calendarAvailable, style: TextStyle(fontSize: 11, color: cs.muted)),
                const SizedBox(width: 16),
                Container(
                  width: 5, height: 5,
                  decoration: BoxDecoration(
                    color:  cs.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.trainer_calendarSelected, style: TextStyle(fontSize: 11, color: cs.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap, dynamic cs) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 22, color: cs.label),
        ),
      );

  Widget _legendDot(Color color) => Container(
        width: 6, height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
