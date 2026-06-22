// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_income_screen.dart
//
// Shows the trainer's commission earnings (percentage of session price) for
// COMPLETED + PAID sessions, with a date-range filter.
//   Trainer mode (isAdmin=false): always shows the signed-in trainer's income.
//   Admin mode  (isAdmin=true):  a trainer must be picked from the dropdown.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../domain/entities/trainer_income_entity.dart';
import '../bloc/income/trainer_income_bloc.dart';
import '../widgets/pt_form_dialog_kit.dart';

class TrainerIncomeScreen extends StatefulWidget {
  final int branchId;
  /// 0 in admin mode until a trainer is picked from the dropdown.
  final int trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerIncomeScreen({
    super.key,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  State<TrainerIncomeScreen> createState() => _TrainerIncomeScreenState();
}

class _TrainerIncomeScreenState extends State<TrainerIncomeScreen> {
  late int? _selectedTrainerId;
  late DateTimeRange _range;
  static final _dateFmt = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _selectedTrainerId = widget.isAdmin
        ? (widget.trainers.isNotEmpty ? widget.trainers.first.trainerId : null)
        : widget.trainerId;

    final now = DateTime.now();
    _range = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );

    _load();
  }

  void _load() {
    context.read<TrainerIncomeBloc>().add(TrainerIncomeLoadRequested(
          branchId: widget.branchId,
          trainerId: _selectedTrainerId,
          from: _range.start,
          to: _range.end,
        ));
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (picked == null) return;
    setState(() => _range = picked);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          widget.isAdmin ? l10n.trainer_incomeAllTitle : l10n.trainer_incomeMyTitle,
          style: TextStyle(color: c.label),
        ),
        backgroundColor: c.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.isAdmin) ...[
              DropdownButtonFormField<int?>(
                value: _selectedTrainerId,
                decoration: ptFieldDecoration(c,
                    label: l10n.trainer_assignToTrainer,
                    icon: Icons.person_outline_rounded),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
                items: widget.trainers
                    .map((t) => DropdownMenuItem(
                          value: t.trainerId,
                          child: Text(t.fullName),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() => _selectedTrainerId = v);
                  _load();
                },
              ),
              const SizedBox(height: 12),
            ],

            InkWell(
              onTap: _pickRange,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border.all(color: c.border.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range_rounded, size: 18, color: c.muted),
                    const SizedBox(width: 10),
                    Text(
                      '${_dateFmt.format(_range.start)}  –  ${_dateFmt.format(_range.end)}',
                      style: TextStyle(fontSize: 14, color: c.label),
                    ),
                    const Spacer(),
                    Icon(Icons.edit_calendar_outlined, size: 18, color: c.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            BlocBuilder<TrainerIncomeBloc, TrainerIncomeState>(
              builder: (context, state) {
                if (_selectedTrainerId == null) {
                  return _emptyMessage(c, l10n.trainer_incomeSelectTrainer);
                }
                if (state is TrainerIncomeLoading || state is TrainerIncomeInitial) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TrainerIncomeError) {
                  return Center(
                    child: Column(
                      children: [
                        Text(state.message, style: TextStyle(color: c.danger)),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _load, child: Text(l10n.retry)),
                      ],
                    ),
                  );
                }
                final summary = state is TrainerIncomeLoaded
                    ? state.summary
                    : TrainerIncomeSummaryEntity.empty;
                return Column(
                  children: [
                    _summaryCard(c, l10n, summary),
                    const SizedBox(height: 16),
                    if (summary.sessions.isEmpty)
                      _emptyMessage(c, l10n.trainer_incomeNoData)
                    else
                      ...summary.sessions.map((s) => _IncomeRow(session: s)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(dynamic c, AppLocalizations l10n, TrainerIncomeSummaryEntity summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.trainer_incomeTotalSessions,
                    style: TextStyle(color: c.onPrimary.withOpacity(0.85), fontSize: 12.5)),
                const SizedBox(height: 4),
                Text('${summary.totalSessions}',
                    style: TextStyle(
                        color: c.onPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: c.onPrimary.withOpacity(0.25)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.trainer_incomeTotalEarning,
                    style: TextStyle(color: c.onPrimary.withOpacity(0.85), fontSize: 12.5)),
                const SizedBox(height: 4),
                Text('\$${summary.totalEarning.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: c.onPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyMessage(dynamic c, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(text, style: TextStyle(color: c.muted)),
      ),
    );
  }
}

class _IncomeRow extends StatelessWidget {
  final TrainerIncomeSessionEntity session;
  static final _dateFmt = DateFormat('MMM d, yyyy – h:mm a');

  const _IncomeRow({required this.session});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    return Card(
      color: c.surface,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.card.radius)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(session.sourceName,
                      style: TextStyle(
                          color: c.label, fontWeight: FontWeight.w600, fontSize: 14.5)),
                ),
                Text('+\$${session.trainerEarning.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: c.success, fontWeight: FontWeight.w700, fontSize: 14.5)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  session.isSalary
                      ? Icons.payments_rounded
                      : session.isClass
                          ? Icons.groups_rounded
                          : Icons.person_outline_rounded,
                  size: 13,
                  color: c.muted,
                ),
                const SizedBox(width: 4),
                Text(
                  session.isSalary
                      ? l10n.trainer_incomeSalaryPayment
                      : session.isClass
                          ? l10n.trainer_incomeClassSession
                          : (session.memberName ?? l10n.trainer_memberIdLabel),
                  style: TextStyle(color: c.body, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.event_outlined, size: 13, color: c.muted),
                const SizedBox(width: 4),
                Text(_dateFmt.format(session.startTime),
                    style: TextStyle(color: c.muted, fontSize: 12)),
                if (!session.isSalary && session.commissionPercentage != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.percent_rounded, size: 13, color: c.muted),
                  const SizedBox(width: 4),
                  Text(
                    l10n.trainer_commissionOfPrice(
                      session.commissionPercentage!.toStringAsFixed(1),
                      session.sessionPrice.toStringAsFixed(2),
                    ),
                    style: TextStyle(color: c.muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
