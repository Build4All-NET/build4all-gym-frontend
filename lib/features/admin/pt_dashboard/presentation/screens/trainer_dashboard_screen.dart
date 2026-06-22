// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_dashboard_screen.dart
//
// CHANGES:
//   1. Fixed loading forever - BlocBuilder now handles ALL states properly
//   2. Quick Actions pass correct params to BookSessionSheet
//   3. Uses effective branchId from profile instead of hardcoded 1
//   4. Trainer badge shown on services for admin view
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../../admin/AppBar/presentation/admin_app_bar.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
import '../../../../admin/navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_event.dart';
import '../widgets/book_session_sheet_widget.dart';

class TrainerDashboardScreen extends StatelessWidget {
  final ValueChanged<int>     onTabSwitch;
  final ValueChanged<int?> onBranchChanged;
  final bool               isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int                trainerId;

  const TrainerDashboardScreen({
    super.key,
    required this.onTabSwitch,
    required this.onBranchChanged,
    required this.isAdmin,
    required this.trainers,
    required this.trainerId,
  });

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer: AdminNavigationDrawer(
        gymName:         profile.gymName,
        branchName:      profile.branchName,
        adminName:       profile.adminName,
        adminEmail:      profile.adminEmail,
        avatarUrl:       profile.avatarUrl,
        initialActiveId: 'pt_sessions',
      ),
      backgroundColor: c.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AdminAppBar(
            title: isAdmin ? AppLocalizations.of(context)!.trainer_ptDashboardAllTitle : AppLocalizations.of(context)!.trainer_ptDashboardTitle,
            selectedBranchId: context.watch<AdminProfileCubit>().state.branchId,
            onBranchChanged:  onBranchChanged,
            notificationCount: 0,
            actions: [
              Builder(builder: (context) {
                final name     = context.watch<AdminProfileCubit>().state.adminName;
                final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
                return Container(
                  margin: const EdgeInsetsDirectional.only(start: 6),
                  width:  36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color:      c.onPrimary,
                      fontSize:   14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      body: BlocBuilder<TrainerPtSessionsBloc, TrainerPtSessionsState>(
        builder: (context, state) {
          // ── Loading / initial state ──────────────────────────────────────
          if (state is PtSessionsLoading || state is PtSessionsInitial) {
            return Center(child: CircularProgressIndicator(color: c.primary));
          }

          // ── Error state ──────────────────────────────────────────────────
          if (state is PtSessionsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: c.danger),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: c.muted, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final bloc = context.read<TrainerPtSessionsBloc>();
                        final currentState = bloc.state;
                        if (currentState is PtSessionsLoaded) {
                          bloc.add(PtSessionsStarted(
                            branchId: currentState.selectedDate.day == DateTime.now().day
                                ? (context.read<AdminProfileCubit>().state.branchId ?? 1)
                                : 1,
                            trainerId: isAdmin ? 0 : trainerId,
                            trainerNames: isAdmin
                                ? {for (final t in trainers) t.trainerId: t.fullName}
                                : const {},
                          ));
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Action loading/success/error states - show previous data ─────
          if (state is PtSessionActionLoading ||
              state is PtSessionActionSuccess ||
              state is PtSessionActionError) {
            // Extract the loaded state from action states
            PtSessionsLoaded? loadedState;
            if (state is PtSessionActionLoading) loadedState = state.previousState;
            if (state is PtSessionActionSuccess) loadedState = state.updatedState;
            if (state is PtSessionActionError) loadedState = state.previousState;

            if (loadedState != null) {
              return _buildContent(context, loadedState, c, tokens);
            }
            return Center(child: CircularProgressIndicator(color: c.primary));
          }

          // ── Loaded ───────────────────────────────────────────────────────
          if (state is PtSessionsLoaded) {
            return _buildContent(context, state, c, tokens);
          }

          // Fallback - should not reach here
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PtSessionsLoaded state, dynamic c, AppThemeTokens tokens) {
    final sessions = state.sessions;
    final stats = state.stats;
    final effectiveBranchId = context.read<AdminProfileCubit>().state.branchId ?? 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatCardsGrid(stats: stats, tokens: tokens),
          const SizedBox(height: 24),
          _TodayScheduleSection(sessions: sessions, tokens: tokens, isAdmin: isAdmin),
          const SizedBox(height: 24),
          _QuickActionsSection(
            onTabSwitch: onTabSwitch,
            tokens:     tokens,
            isAdmin:    isAdmin,
            trainers:   trainers,
            trainerId:  trainerId,
            branchId:   effectiveBranchId,
          ),
          const SizedBox(height: 24),
          _UpcomingClientsSection(sessions: state.upcomingSessions, tokens: tokens, isAdmin: isAdmin),
          const SizedBox(height: 24),
          _PendingRequestsSection(
            requests: state.requestedSessions,
            tokens:   tokens,
            isAdmin:  isAdmin,
          ),
        ],
      ),
    );
  }
}

// ── Stat cards 2x2 grid ────────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  final PtSessionStatsEntity stats;
  final AppThemeTokens       tokens;
  const _StatCardsGrid({required this.stats, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final primaryLight = Color.lerp(c.primary,  Colors.white, 0.25)!;
    final successLight = Color.lerp(c.success,  Colors.white, 0.25)!;
    final warningBase  = Color.lerp(c.danger,   c.primary,    0.5)!;
    final warningLight = Color.lerp(warningBase, Colors.white, 0.25)!;
    final mutedBase    = Color.lerp(c.muted,    c.label,      0.3)!;
    final mutedLight   = Color.lerp(mutedBase,  Colors.white, 0.25)!;

    final cancelled = (stats.total - stats.completed - stats.scheduled)
        .clamp(0, stats.total);

    return GridView(
      shrinkWrap: true,
      physics:    const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        // Fixed height (not childAspectRatio) so the 2-line label never
        // gets squeezed into overflow on narrow screens.
        mainAxisExtent: 116,
      ),
      children: [
        _StatCard(icon: Icons.calendar_month_outlined, value: '${stats.total}',
            label: AppLocalizations.of(context)!.trainer_todaySessions, gradient: [c.primary, primaryLight]),
        _StatCard(icon: Icons.check_circle_outline, value: '${stats.completed}',
            label: AppLocalizations.of(context)!.trainer_tabCompleted, gradient: [c.success, successLight]),
        _StatCard(icon: Icons.access_time_rounded, value: '${stats.scheduled}',
            label: AppLocalizations.of(context)!.trainer_tabUpcoming, gradient: [warningBase, warningLight]),
        _StatCard(icon: Icons.cancel_outlined, value: '$cancelled',
            label: AppLocalizations.of(context)!.trainer_cancelledNoShow, gradient: [mutedBase, mutedLight]),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData    icon;
  final String      value;
  final String      label;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin:  AlignmentDirectional.topStart,
          end:    AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(value,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
              ),
              const SizedBox(height: 2),
              Text(label,
                  maxLines:  2,
                  overflow:  TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Today's Schedule ───────────────────────────────────────────────────────────

class _TodayScheduleSection extends StatelessWidget {
  final List<PtSessionEntity> sessions;
  final AppThemeTokens         tokens;
  final bool                   isAdmin;
  const _TodayScheduleSection({
    required this.sessions,
    required this.tokens,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final active = sessions
        .where((s) =>
    s.startTime.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
        s.startTime.isBefore(todayEnd) &&
        !s.isCompleted && !s.isCancelled)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.trainer_todayScheduleHeader,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: c.label)),
            Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                style: TextStyle(fontSize: 12, color: c.muted)),
          ],
        ),
        const SizedBox(height: 12),
        if (active.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(AppLocalizations.of(context)!.trainer_noServicesScheduled,
                  style: TextStyle(color: c.muted, fontSize: 14)),
            ),
          )
        else
          ...active.map((s) => _ScheduleRow(session: s, tokens: tokens, isAdmin: isAdmin)),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final PtSessionEntity session;
  final AppThemeTokens  tokens;
  final bool            isAdmin;
  const _ScheduleRow({super.key, required this.session, required this.tokens, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Container(
      margin:  const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding:    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  DateFormat('hh a').format(session.startTime),
                  style: TextStyle(color: c.onPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 2, height: 34,
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _MiniAvatar(initials: session.initials, tokens: tokens),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.displayName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14, color: c.label)),
                          Text(session.serviceName ?? session.notes ?? AppLocalizations.of(context)!.trainer_ptSession,
                              style: TextStyle(fontSize: 12, color: c.muted)),
                          // Trainer badge for admin
                          if (isAdmin &&
                              session.trainerName != null &&
                              session.trainerName!.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:        c.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.trainer_byName(session.trainerName!),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: c.primary),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (session.sessionIndex != null && session.totalPackageSessions != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (session.sessionIndex! / session.totalPackageSessions!)
                          .clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: c.border.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(c.primary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '${session.sessionIndex}/${session.totalPackageSessions}',
                      style: TextStyle(fontSize: 11, color: c.muted),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (session.paymentStatus != null)
                      _StatusBadge(
                        label: session.paymentStatus!.toUpperCase(),
                        bg: c.success.withOpacity(0.15),
                        fg: c.success,
                      ),
                    if (session.isScheduled) ...[
                      const SizedBox(width: 6),
                      _StatusBadge(
                        label: AppLocalizations.of(context)!.trainer_confirmedBadge,
                        bg: c.primary.withOpacity(0.1),
                        fg: c.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String         initials;
  final AppThemeTokens tokens;
  const _MiniAvatar({required this.initials, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Container(
      width:  36,
      height: 36,
      decoration: BoxDecoration(
        color: Color.lerp(c.primary, c.label, 0.3)!,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(initials,
          style: TextStyle(
              color: c.onPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color  bg;
  final Color  fg;
  const _StatusBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

// ── Quick Actions 2x2 grid ─────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  final ValueChanged<int>          onTabSwitch;
  final AppThemeTokens             tokens;
  final bool                       isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int                        trainerId;
  final int                        branchId;

  const _QuickActionsSection({
    required this.onTabSwitch,
    required this.tokens,
    required this.isAdmin,
    required this.trainers,
    required this.trainerId,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final tokenStore = AdminTokenStore();

    // For admin: default trainer for BookSessionSheet = first trainer in list
    // For trainer: use their own trainerId
    final defaultTrainerIdForSheet = (isAdmin && trainers.isNotEmpty)
        ? trainers.first.trainerId
        : trainerId;

    final l10n = AppLocalizations.of(context)!;

    // Tab order differs by role (see TrainerMainScreen._MainShell):
    //   Admin:   0 Dashboard, 1 Sessions, 2 Packages, 3 Schedule, 4 Services, 5 Income
    //   Trainer: 0 Dashboard, 1 Sessions, 2 Schedule, 3 Income (no Packages/Services)
    final items = <_QAItem>[
      if (isAdmin)
        _QAItem(
          icon: Icons.inventory_2_outlined,
          label: l10n.trainer_createPackage,
          bg:        c.primary.withOpacity(0.08),
          iconColor: c.primary,
          onTap:     () => onTabSwitch(2),
        ),
      _QAItem(
        icon: Icons.calendar_month_outlined,
        label: l10n.trainer_addAvailabilityButton,
        bg:        c.success.withOpacity(0.08),
        iconColor: c.success,
        onTap:     () => onTabSwitch(isAdmin ? 3 : 2),
      ),
      if (isAdmin)
        _QAItem(
          icon: Icons.sports_gymnastics_rounded,
          label: l10n.trainer_addPtService,
          bg:        Color.lerp(c.danger, c.primary, 0.5)!.withOpacity(0.1),
          iconColor: Color.lerp(c.danger, c.primary, 0.5)!,
          onTap:     () => onTabSwitch(4),
        ),
      if (!isAdmin)
        _QAItem(
          icon: Icons.payments_outlined,
          label: l10n.trainer_navIncome,
          bg:        Color.lerp(c.danger, c.primary, 0.5)!.withOpacity(0.1),
          iconColor: Color.lerp(c.danger, c.primary, 0.5)!,
          onTap:     () => onTabSwitch(3),
        ),
      _QAItem(
        icon: Icons.event_available_outlined,
        label: l10n.trainer_createSession,
        bg:        Color.lerp(c.primary, c.label, 0.3)!.withOpacity(0.1),
        iconColor: Color.lerp(c.primary, c.label, 0.3)!,
        onTap: () {
          final tenantIdStr = tokenStore.getTenantId();
          final tenantId = int.tryParse(tenantIdStr.toString()) ?? 1;
          BookSessionSheet.show(
            context,
            branchId:     branchId,
            tenantId:     tenantId,
            trainerId:    defaultTrainerIdForSheet,
            isAdmin:      isAdmin,
            trainers:     trainers,
            selectedDate: DateTime.now(),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.admin_dashboard_quickActions,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: c.label)),
        const SizedBox(height: 12),
        GridView(
          shrinkWrap: true,
          physics:    const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   2,
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
            // Fixed height (not childAspectRatio) so the label never gets
            // squeezed into overflow on narrow screens.
            mainAxisExtent: 100,
          ),
          children: items
              .map((item) => _QACard(item: item, tokens: tokens))
              .toList(),
        ),
      ],
    );
  }
}

class _QAItem {
  final IconData     icon;
  final String       label;
  final Color        bg;
  final Color        iconColor;
  final VoidCallback onTap;
  const _QAItem({
    required this.icon,
    required this.label,
    required this.bg,
    required this.iconColor,
    required this.onTap,
  });
}

class _QACard extends StatelessWidget {
  final _QAItem        item;
  final AppThemeTokens tokens;
  const _QACard({super.key, required this.item, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        item.bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:  46,
              height: 46,
              decoration: BoxDecoration(
                color:        item.iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: c.label)),
          ],
        ),
      ),
    );
  }
}

// ── Pending Requests ───────────────────────────────────────────────────────────

class _PendingRequestsSection extends StatelessWidget {
  final List<PtSessionEntity> requests;
  final AppThemeTokens         tokens;
  final bool                   isAdmin;
  const _PendingRequestsSection({
    required this.requests,
    required this.tokens,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.trainer_pendingRequests,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: c.label)),
            if (requests.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:        const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${requests.length}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        if (requests.isEmpty)
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color:        c.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(AppLocalizations.of(context)!.trainer_noPendingRequests,
                  style: TextStyle(color: c.muted, fontSize: 14)),
            ),
          )
        else
          ...requests.map(
            (req) => _RequestCard(request: req, tokens: tokens, isAdmin: isAdmin),
          ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  final PtSessionEntity request;
  final AppThemeTokens  tokens;
  final bool            isAdmin;
  const _RequestCard({
    super.key,
    required this.request,
    required this.tokens,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final bloc = context.read<TrainerPtSessionsBloc>();

    return Container(
      margin:  const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: const Color(0xFFEF4444).withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:  42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  request.initials,
                  style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: c.label)),
                    Text(
                      request.serviceName ?? request.notes ?? AppLocalizations.of(context)!.trainer_ptSession,
                      style: TextStyle(fontSize: 12, color: c.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isAdmin &&
                        request.trainerName != null &&
                        request.trainerName!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:        c.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.trainer_byName(request.trainerName!),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: c.primary),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:        const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('MMM d, h:mm a').format(request.startTime),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => bloc.add(
                      PtSessionDeclineRequested(sessionId: request.ptSessionId)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(AppLocalizations.of(context)!.trainer_declineButton, style: const TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => bloc.add(
                      PtSessionAcceptRequested(sessionId: request.ptSessionId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(AppLocalizations.of(context)!.trainer_acceptButton, style: const TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Upcoming Clients ───────────────────────────────────────────────────────────

class _UpcomingClientsSection extends StatelessWidget {
  final List<PtSessionEntity> sessions;
  final AppThemeTokens         tokens;
  final bool                   isAdmin;
  const _UpcomingClientsSection({required this.sessions, required this.tokens, required this.isAdmin});

  static const _avatarColors = [
    Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFFEC4899),
    Color(0xFF10B981), Color(0xFFF59E0B),
  ];

  Color _colorFor(String initials) {
    final idx = initials.codeUnits.fold(0, (a, b) => a + b) % _avatarColors.length;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final now = DateTime.now();
    final tomorrowStart = DateTime(now.year, now.month, now.day + 1);
    final upcoming = sessions
        .where((s) => !s.startTime.isBefore(tomorrowStart))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.trainer_upcomingClients,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: c.label)),
            TextButton.icon(
              onPressed: () {},
              icon:  Text(AppLocalizations.of(context)!.admin_dashboard_viewAll, style: TextStyle(fontSize: 13, color: c.primary)),
              label: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 18,
                  color: c.primary),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcoming.isEmpty)
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color:        c.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(AppLocalizations.of(context)!.trainer_noUpcomingClients,
                  style: TextStyle(color: c.muted, fontSize: 14)),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:       upcoming.length,
              itemBuilder: (_, i) {
                final session     = upcoming[i];
                final avatarColor = _colorFor(session.initials);
                return Container(
                  width:   170,
                  margin:  const EdgeInsetsDirectional.only(end: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:        c.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color:     Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset:    const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width:  46, height: 46,
                        decoration: BoxDecoration(
                            color: avatarColor, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(session.initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      Text(session.displayName,
                          textAlign: TextAlign.center,
                          maxLines:  1,
                          overflow:  TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: c.label)),
                      Text(
                          session.serviceName ?? session.notes ?? AppLocalizations.of(context)!.trainer_ptSession,
                          textAlign: TextAlign.center,
                          maxLines:  1,
                          overflow:  TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: c.muted)),
                      // Trainer badge for admin
                      if (isAdmin &&
                          session.trainerName != null &&
                          session.trainerName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            session.trainerName!,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: c.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (session.sessionIndex != null &&
                          session.totalPackageSessions != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:        c.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.trainer_sessionOfTotal(session.sessionIndex!, session.totalPackageSessions!),
                            style: TextStyle(fontSize: 10, color: c.primary),
                          ),
                        ),
                      Text(
                        DateFormat('MMM d, h:mm a').format(session.startTime),
                        style: TextStyle(fontSize: 10, color: c.muted),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}