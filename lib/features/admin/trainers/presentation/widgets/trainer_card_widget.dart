// FILE: lib/features/admin/trainers/presentation/widgets/trainer_card_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/admin_trainer_card_entity.dart';
import '../bloc/admin_trainers_bloc.dart';
import '../bloc/admin_trainers_event.dart';

class TrainerCardWidget extends StatelessWidget {
  const TrainerCardWidget({
    super.key,
    required this.trainer,
    required this.isLoading,
    required this.onEditTap,
  });

  final AdminTrainerCardEntity trainer;
  final bool isLoading;
  final VoidCallback onEditTap;

  void _showBlockConfirmation(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:   Text(
            trainer.isBlocked ? l10n.admin_trainers_unblockConfirmTitle : l10n.admin_trainers_blockConfirmTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          trainer.isBlocked
              ? l10n.admin_trainers_unblockConfirmMessage(trainer.fullName)
              : l10n.admin_trainers_blockConfirmMessage(trainer.fullName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child:     Text(l10n.general_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<AdminTrainersBloc>()
                  .add(TrainerBlockRequested(trainer.trainerId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: trainer.isBlocked ? c.success : c.danger,
              foregroundColor: c.onPrimary,
            ),
            child: Text(trainer.isBlocked ? l10n.admin_trainers_unblockAction : l10n.admin_trainers_blockAction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;
    final l10n   = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.circular(card.radius),
        boxShadow: [
          BoxShadow(
            color:     Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset:    const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Avatar + name + status ────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius:          24,
                  backgroundColor: c.label,
                  child: Text(
                    trainer.initials,
                    style: TextStyle(
                      color:      c.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize:   15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.fullName,
                        style: TextStyle(
                          fontSize:   15,
                          fontWeight: FontWeight.w700,
                          color:      c.label,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (trainer.specialties.isNotEmpty)
                        Wrap(
                          spacing:    4,
                          runSpacing: 0,
                          children: trainer.specialties.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: c.border.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                s,
                                style: TextStyle(
                                    fontSize: 11, color: c.body),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trainer.isBlocked
                        ? c.danger.withOpacity(0.1)
                        : c.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trainer.isBlocked ? l10n.admin_trainers_blockedBadge : l10n.admin_trainers_activeBadge,
                    style: TextStyle(
                      fontSize:   11,
                      fontWeight: FontWeight.w600,
                      color:      trainer.isBlocked ? c.danger : c.success,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFB300), size: 16),
                const SizedBox(width: 4),
                Text(
                  '${trainer.avgRating.toStringAsFixed(1)}/5.0',
                  style: TextStyle(fontSize: 12, color: c.body),
                ),
              ],
            ),

            const SizedBox(height: 6),

            if (trainer.branchNames.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: c.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trainer.branchNames.join(', '),
                      style:    TextStyle(fontSize: 12, color: c.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            if (trainer.availabilityDisplay.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: c.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trainer.availabilityDisplay,
                      style:    TextStyle(fontSize: 12, color: c.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            if (isLoading)
              Center(
                child: SizedBox(
                  width:  24,
                  height: 24,
                  child:  CircularProgressIndicator(
                      strokeWidth: 2, color: c.primary),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _ActionBtn(
                      icon:    Icons.calendar_month_outlined,
                      label:   l10n.admin_trainers_scheduleAction,
                      color:   c.primary,
                      onTap:   () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionBtn(
                      icon:  Icons.edit_outlined,
                      label: l10n.admin_trainers_editAction,
                      color: c.success,
                      onTap: onEditTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionBtn(
                      icon:  trainer.isBlocked
                          ? Icons.lock_open_outlined
                          : Icons.block_outlined,
                      label: trainer.isBlocked ? l10n.admin_trainers_unblockAction : l10n.admin_trainers_blockAction,
                      color: trainer.isBlocked ? c.success : c.danger,
                      onTap: () => _showBlockConfirmation(context),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon:      Icon(icon, size: 14, color: color),
      label:     Text(label, style: TextStyle(fontSize: 11, color: color)),
      onPressed: onTap,
      style:     OutlinedButton.styleFrom(
        side:    BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}