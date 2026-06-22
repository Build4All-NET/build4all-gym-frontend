// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_schedule_screen.dart
//
// CHANGES vs previous version:
//   - _AddSlotDialog now shows a Date picker when `recurring = false`.
//     That date is passed as `specificDate` in AvailabilitySlotCreateRequested
//     so it reaches the backend and is stored in
//     trainer_availability.specific_date (nullable date column in DB).
//   - _showAddDialog passes the picked specificDate to the BLoC event.
//   - onSubmit callback signature extended with `specificDate` param.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../domain/entities/availability_entity.dart';
import '../bloc/availability/availability_bloc.dart';
import '../widgets/pt_form_dialog_kit.dart';

List<String> _localizedWeekdays(AppLocalizations l10n) => [
  l10n.trainer_dayFullMonday, l10n.trainer_dayFullTuesday, l10n.trainer_dayFullWednesday,
  l10n.trainer_dayFullThursday, l10n.trainer_dayFullFriday, l10n.trainer_dayFullSaturday, l10n.trainer_dayFullSunday,
];

class TrainerScheduleScreen extends StatefulWidget {
  final int  branchId;
  /// 0 = admin/owner (all-trainers mode)
  final int  trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerScheduleScreen({
    super.key,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  State<TrainerScheduleScreen> createState() =>
      _TrainerScheduleScreenState();
}

class _TrainerScheduleScreenState extends State<TrainerScheduleScreen> {
  late final AvailabilityBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AvailabilityBloc>();
    _load();
  }

  void _load() {
    _bloc.add(AvailabilitySlotsLoadRequested(
      trainerId: widget.isAdmin ? null : widget.trainerId,
      branchId:  widget.branchId,
    ));
  }

  String _trainerName(int trainerId, BuildContext context) {
    try {
      return widget.trainers
          .firstWhere((t) => t.trainerId == trainerId)
          .fullName;
    } catch (_) {
      return AppLocalizations.of(context)!.trainer_trainerNumber(trainerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return BlocConsumer<AvailabilityBloc, AvailabilityState>(
      listener: (ctx, state) {
        if (state is AvailabilityMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AvailabilityError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: tokens.colors.error,
            ),
          );
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: tokens.colors.background,
          appBar: AppBar(
            title: Text(
              widget.isAdmin ? AppLocalizations.of(context)!.trainer_schedulesAllTitle : AppLocalizations.of(context)!.trainer_schedulesMyTitle,
              style: TextStyle(color: tokens.colors.label),
            ),
            backgroundColor: tokens.colors.surface,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: tokens.colors.primary),
                onPressed: () => _showAddDialog(context, tokens),
              ),
            ],
          ),
          body: _buildBody(context, state, tokens),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AvailabilityState state, dynamic tokens) {
    if (state is AvailabilityLoading || state is AvailabilityMutating) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AvailabilityError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)!.retry)),
          ],
        ),
      );
    }

    final slots = state is AvailabilityLoaded
        ? state.slots
        : <AvailabilityEntity>[];

    if (slots.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.trainer_noAvailabilityFound));
    }

    // Group slots by weekday
    final Map<int, List<AvailabilityEntity>> grouped = {};
    for (final slot in slots) {
      grouped.putIfAbsent(slot.weekday, () => []).add(slot);
    }

    final sortedWeekdays = grouped.keys.toList()..sort();

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedWeekdays.length,
        itemBuilder: (_, i) {
          final day      = sortedWeekdays[i];
          final daySlots = grouped[day]!;
          final l10n = AppLocalizations.of(context)!;
          final weekdays = _localizedWeekdays(l10n);
          final dayName  = day >= 1 && day <= 7
              ? weekdays[day - 1]
              : l10n.trainer_dayNumberFallback(day);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  dayName,
                  style: TextStyle(
                    color: tokens.colors.label,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              ...daySlots.map((slot) => _SlotCard(
                slot:        slot,
                trainerName: _trainerName(slot.trainerId, context),
                showBadge:   widget.isAdmin,
                onDelete:    () {
                  _bloc.add(AvailabilitySlotDeleteRequested(
                      slot.availabilityId));
                },
              )),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  // ── Add-slot dialog ───────────────────────────────────────────────────────

  void _showAddDialog(BuildContext context, dynamic tokens) {
    showDialog(
      context: context,
      builder: (_) => _AddSlotDialog(
        isAdmin:          widget.isAdmin,
        trainers:         widget.trainers,
        defaultTrainerId: widget.trainerId,
        onSubmit: ({
          required int      trainerId,
          required int      weekday,
          required String   startTime,
          required String   endTime,
          required bool     recurring,
          DateTime?         specificDate,   // ← NEW
        }) {
          _bloc.add(AvailabilitySlotCreateRequested(
            trainerId:    trainerId,
            branchId:     widget.branchId,
            weekday:      weekday,
            startTime:    startTime,
            endTime:      endTime,
            recurring:    recurring,
            specificDate: specificDate,     // ← forwarded to BLoC
          ));
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── Slot card ─────────────────────────────────────────────────────────────────

class _SlotCard extends StatelessWidget {
  final AvailabilityEntity slot;
  final String trainerName;
  final bool showBadge;
  final VoidCallback onDelete;

  const _SlotCard({
    required this.slot,
    required this.trainerName,
    required this.showBadge,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final l10n = AppLocalizations.of(context)!;
    String subtitle;
    if (showBadge) {
      subtitle = l10n.trainer_byName(trainerName);
    } else if (slot.isRecurring) {
      subtitle = l10n.trainer_recurringWeekly;
    } else if (slot.specificDate != null) {
      subtitle = l10n.trainer_oneTimeDate(DateFormat('EEE, MMM d, yyyy').format(slot.specificDate!));
    } else {
      subtitle = l10n.trainer_oneTime;
    }

    return Card(
      color: tokens.colors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: ListTile(
        leading: Icon(Icons.schedule, color: tokens.colors.primary),
        title: Text(
          '${slot.startTime} – ${slot.endTime}',
          style: TextStyle(color: tokens.colors.label, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: showBadge ? tokens.colors.primary : tokens.colors.muted,
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: tokens.colors.danger),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.trainer_deleteSlotTitle),
              content: Text(AppLocalizations.of(context)!.trainer_deleteSlotMessage(slot.startTime, slot.endTime)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.general_cancel),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.admin_members_actionDelete,
                      style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Add slot dialog ───────────────────────────────────────────────────────────

class _AddSlotDialog extends StatefulWidget {
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int defaultTrainerId;

  /// Callback extended with `specificDate` (nullable).
  /// Required when `recurring = false` — maps to
  /// trainer_availability.specific_date in the DB.
  final void Function({
  required int    trainerId,
  required int    weekday,
  required String startTime,
  required String endTime,
  required bool   recurring,
  DateTime?       specificDate,
  }) onSubmit;

  const _AddSlotDialog({
    required this.isAdmin,
    required this.trainers,
    required this.defaultTrainerId,
    required this.onSubmit,
  });

  @override
  State<_AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<_AddSlotDialog> {
  int?      _selectedTrainerId;
  int       _selectedWeekday = 1;
  String    _startTime = '09:00';
  String    _endTime   = '10:00';
  bool      _recurring = true;
  DateTime? _specificDate;           // ← NEW: only used when !_recurring

  @override
  void initState() {
    super.initState();
    _selectedTrainerId =
    widget.defaultTrainerId != 0 ? widget.defaultTrainerId : null;
  }

  // ── Date picker for one-time slots ─────────────────────────────────────────

  Future<void> _pickSpecificDate() async {
    final now    = DateTime.now();
    final picked = await showDatePicker(
      context:     context,
      initialDate: _specificDate ?? now,
      firstDate:   now,
      lastDate:    now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _specificDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c    = context.read<ThemeCubit>().state.tokens.colors;

    return PtFormDialogScaffold(
      header: PtDialogHeader(
        icon:     Icons.event_available_rounded,
        title:    l10n.trainer_addAvailabilitySlotTitle,
        subtitle: l10n.trainer_addSlotSubtitle,
        onClose:  () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Trainer picker (admin only) ─────────────────────────────────
          if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
            DropdownButtonFormField<int>(
              value: _selectedTrainerId,
              decoration: ptFieldDecoration(c,
                  label: l10n.trainer_assignToTrainer,
                  icon: Icons.person_outline_rounded),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
              items: widget.trainers.map((t) {
                return DropdownMenuItem(
                  value: t.trainerId,
                  child: Text(t.fullName),
                );
              }).toList(),
              onChanged: (v) =>
                  setState(() => _selectedTrainerId = v),
            ),
            const SizedBox(height: 14),
          ],

          // ── Timing ────────────────────────────────────────────────────────
          PtSectionLabel(icon: Icons.schedule_rounded, text: l10n.trainer_sectionTiming),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DropdownButtonFormField<int>(
              value: _selectedWeekday,
              decoration: ptFieldDecoration(c,
                  label: l10n.trainer_dayOfWeek,
                  icon: Icons.calendar_today_outlined),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
              items: List.generate(7, (i) {
                final weekdays = _localizedWeekdays(l10n);
                return DropdownMenuItem(
                  value: i + 1,
                  child: Text(weekdays[i]),
                );
              }),
              onChanged: (v) =>
                  setState(() => _selectedWeekday = v ?? 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PtTimeField(
                    c:        c,
                    label:    l10n.trainer_startTime,
                    initial:  _startTime,
                    onChange: (v) => setState(() => _startTime = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PtTimeField(
                    c:        c,
                    label:    l10n.trainer_endTime,
                    initial:  _endTime,
                    onChange: (v) => setState(() => _endTime = v),
                  ),
                ),
              ],
            ),
          ),

          // ── Availability type ────────────────────────────────────────────
          PtSectionLabel(icon: Icons.repeat_rounded, text: l10n.trainer_sectionAvailabilityType),
          PtSwitchCard(
            icon:  Icons.event_repeat_rounded,
            title: l10n.trainer_recurringWeeklyToggle,
            value: _recurring,
            onChanged: (v) => setState(() {
              _recurring = v;
              if (v) _specificDate = null; // clear when toggling back
            }),
          ),

          // ── Specific date picker (one-time only) ────────────────────────
          // Shown when recurring = false.
          // Maps to trainer_availability.specific_date in the DB.
          if (!_recurring) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickSpecificDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: ptFieldDecoration(c,
                    label: l10n.trainer_specificDate,
                    icon: Icons.calendar_month_rounded,
                    errorText: _specificDate == null
                        ? l10n.trainer_requiredForOneTime
                        : null),
                child: Text(
                  _specificDate == null
                      ? l10n.trainer_pickDate
                      : DateFormat('EEE, MMM d, yyyy').format(_specificDate!),
                  style: TextStyle(
                    fontSize: 14,
                    color: _specificDate == null ? c.muted : c.label,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      footer: PtDialogFooter(
        cancelLabel: l10n.general_cancel,
        submitLabel: l10n.trainer_addAvailabilityButton,
        submitIcon:  Icons.add_rounded,
        onCancel:    () => Navigator.pop(context),
        onSubmit:    () {
          final trainerId =
              _selectedTrainerId ?? widget.defaultTrainerId;
          if (trainerId == 0) {
            AppToast.error(context, l10n.trainer_selectTrainerSnackbar);
            return;
          }
          // Validate: specificDate required for one-time slots
          if (!_recurring && _specificDate == null) {
            AppToast.error(context, l10n.trainer_pickSpecificDate);
            return;
          }
          widget.onSubmit(
            trainerId:    trainerId,
            weekday:      _selectedWeekday,
            startTime:    _startTime,
            endTime:      _endTime,
            recurring:    _recurring,
            specificDate: _recurring ? null : _specificDate,
          );
        },
      ),
    );
  }
}

// ── Time picker field ─────────────────────────────────────────────────────────

class _PtTimeField extends StatelessWidget {
  final ColorTokens c;
  final String label;
  final String initial;
  final void Function(String) onChange;

  const _PtTimeField({
    required this.c,
    required this.label,
    required this.initial,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final parts  = initial.split(':');
        final picked = await showTimePicker(
          context:     context,
          initialTime: TimeOfDay(
            hour:   int.tryParse(parts[0]) ?? 9,
            minute: int.tryParse(parts[1]) ?? 0,
          ),
        );
        if (picked != null) {
          onChange(
            '${picked.hour.toString().padLeft(2, '0')}:'
                '${picked.minute.toString().padLeft(2, '0')}',
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: ptFieldDecoration(c, label: label, icon: Icons.access_time_rounded),
        child: Text(initial, style: TextStyle(fontSize: 14, color: c.label)),
      ),
    );
  }
}
