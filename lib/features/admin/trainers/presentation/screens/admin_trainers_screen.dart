// FILE: lib/features/admin/trainers/presentation/screens/admin_gym_trainers_screen.dart
//
// Replaces AdminTrainersScreen entirely.
// Shows members who were promoted to Trainer via gym_user_roles.
// FAB opens MemberPickerForTrainerSheet to add more.
// Remove button on each card revokes the role.

import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/GymTrainerEntity.dart';
import '../bloc/GymTrainersCubit.dart';
import '../bloc/GymTrainersState.dart';
import '../widgets/configure_trainer_sheet.dart';
import '../widgets/member_picker_for_trainer_sheet.dart';

class AdminGymTrainersScreen extends StatefulWidget {
  const AdminGymTrainersScreen({super.key});

  @override
  State<AdminGymTrainersScreen> createState() => _AdminGymTrainersScreenState();
}

class _AdminGymTrainersScreenState extends State<AdminGymTrainersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<GymTrainersCubit>().load(),
    );
  }

  // ── Remove with confirmation ───────────────────────────────────────────────

  Future<void> _confirmRemove(GymTrainerEntity trainer) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final c = context.read<ThemeCubit>().state.tokens.colors;
        return AlertDialog(
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.admin_trainers_removeRoleTitle,
              style: TextStyle(color: c.primary, fontWeight: FontWeight.bold)),
          content: Text(
            l10n.admin_trainers_removeRoleMessage(trainer.fullName),
            style: TextStyle(color: c.error),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.general_cancel, style: TextStyle(color: c.error)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(l10n.admin_trainers_remove,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      context.read<GymTrainersCubit>().removeTrainer(trainer.userId);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens  = context.watch<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      backgroundColor: c.background,
      drawer: AdminNavigationDrawer(
        gymName:         profile.gymName,
        branchName:      profile.branchName,
        adminName:       profile.adminName,
        adminEmail:      profile.adminEmail,
        avatarUrl:       profile.avatarUrl,
        initialActiveId: 'trainers',
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AdminAppBar(title: AppLocalizations.of(context)!.navTrainers),
        ),
      ),

      // ── FAB — open member picker ─────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => MemberPickerForTrainerSheet.show(
          context,
          onAssigned: (userId, name) => ConfigureTrainerSheet.show(
            context,
            userId:       userId,
            trainerName:  name,
            onConfigured: () => context.read<GymTrainersCubit>().reload(),
          ),
        ),
        backgroundColor: c.primary,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: Text(AppLocalizations.of(context)!.admin_trainers_addTrainer,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),

      body: BlocConsumer<GymTrainersCubit, GymTrainersState>(
        listener: (context, state) {
          if (state is GymTrainerRemoveError) {
            AppToast.error(context, state.message);
          }
        },
        builder: (context, state) {
          // ── Loading ──────────────────────────────────────────────────────
          if (state is GymTrainersLoading) {
            return Center(child: CircularProgressIndicator(color: c.primary));
          }

          // ── Error ────────────────────────────────────────────────────────
          if (state is GymTrainersError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded, color: c.error, size: 48),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(context)!.admin_trainers_loadError,
                      style: TextStyle(color: c.primary, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(state.message,
                      style: TextStyle(color: c.error, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<GymTrainersCubit>().load(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(AppLocalizations.of(context)!.retry),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            );
          }

          // ── Resolve list from any loaded state ────────────────────────────
          final trainers = _resolveList(state);
          final removingId = state is GymTrainerRemoving
              ? state.removingUserId
              : null;

          // ── Empty ────────────────────────────────────────────────────────
          if (trainers.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_outlined,
                      color: c.error, size: 56),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.admin_trainers_emptyTitle,
                      style: TextStyle(
                          color: c.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.admin_trainers_emptyMessage,
                    style: TextStyle(color: c.error, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // ── List ─────────────────────────────────────────────────────────
          return RefreshIndicator(
            color: c.primary,
            onRefresh: () => context.read<GymTrainersCubit>().reload(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: trainers.length,
              itemBuilder: (_, i) => _TrainerCard(
                trainer:    trainers[i],
                isRemoving: removingId == trainers[i].userId,
                onRemove:   () => _confirmRemove(trainers[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  List<GymTrainerEntity> _resolveList(GymTrainersState state) {
    if (state is GymTrainersLoaded)      return state.trainers;
    if (state is GymTrainerRemoving)     return state.trainers;
    if (state is GymTrainerRemoveError)  return state.trainers;
    return [];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trainer Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _TrainerCard extends StatelessWidget {
  final GymTrainerEntity trainer;
  final bool             isRemoving;
  final VoidCallback     onRemove;

  const _TrainerCard({
    required this.trainer,
    required this.isRemoving,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    // Format assignedAt date if parseable
    String assignedLabel = '';
    try {
      final dt = DateTime.parse(trainer.assignedAt);
      assignedLabel = 'Trainer since ${DateFormat('MMM d, yyyy').format(dt)}';
    } catch (_) {
      assignedLabel = 'Trainer';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ── Avatar ─────────────────────────────────────────────────────
            CircleAvatar(
              radius: 26,
              backgroundColor: c.primary.withOpacity(0.15),
              child: Text(
                trainer.initials,
                style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(width: 14),

            // ── Info ────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trainer.fullName,
                      style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  const SizedBox(height: 3),
                  if (trainer.phone.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, color: c.error, size: 13),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(trainer.phone,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.error, fontSize: 12)),
                        ),
                      ],
                    ),
                  if (trainer.branchNames.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: c.muted, size: 13),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            trainer.branchNames.join(', '),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: c.muted, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: c.error, size: 13),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(assignedLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: c.error, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Trainer badge ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(AppLocalizations.of(context)!.admin_trainers_badgeLabel,
                  style: TextStyle(
                      color: c.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
            ),

            // ── Remove button ─────────────────────────────────────────────
            isRemoving
                ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : IconButton(
              icon: Icon(Icons.person_remove_outlined,
                  color: Colors.red.shade400, size: 22),
              tooltip: AppLocalizations.of(context)!.admin_trainers_removeTooltip,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}