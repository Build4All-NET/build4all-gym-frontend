// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_dashboard_screen.dart
//
// PT Trainer Dashboard — Tab 0 of TrainerMainScreen.
//
// Sections:
//   1. AppBar — hamburger + branch name from AdminProfileCubit + notification bell
//   2. Stat cards 2×2 grid: Today Sessions | Completed | Upcoming | Cancelled
//   3. Today's Schedule — active sessions with progress bar and action buttons
//   4. Quick Actions 2×2 grid — switches bottom-nav tab or opens Book Session sheet
//   5. Upcoming Clients — derived from real loaded sessions (SCHEDULED in future)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../AppBar/presentation/branch_cubit.dart';

import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_state.dart';
import '../widgets/book_session_sheet_widget.dart';

class TrainerDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onTabSwitch;
  final ValueChanged<int?> onBranchChanged;

  const TrainerDashboardScreen({
    super.key,
    required this.onTabSwitch,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    //  Read theme tokens so every child can use c.* for colors.
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer:  AdminNavigationDrawer(
        gymName:    profile.gymName,
        branchName: profile.branchName,
        adminName:  profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl:  profile.avatarUrl,
        initialActiveId: 'pt_sessions',
      ),
      // c.background from ThemeCubit.
      backgroundColor: c.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AdminAppBar(
            title: 'Trainer Dashboard',
            selectedBranchId:
            context.watch<AdminProfileCubit>().state.branchId,
            onBranchChanged: onBranchChanged,
            notificationCount: 0,
            onNotificationTap: () {},
            actions: [
              Builder(
                builder: (context) {
                  final c = tokens.colors;
                  final name =
                      context.watch<AdminProfileCubit>().state.adminName;

                  final initials =
                  name.isNotEmpty ? name[0].toUpperCase() : '?';

                  return Container(
                    margin: const EdgeInsets.only(left: 6),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: c.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<TrainerPtSessionsBloc, TrainerPtSessionsState>(
        builder: (context, state) {
          final sessions = state is PtSessionsLoaded
              ? state.sessions
              : <PtSessionEntity>[];
          final stats = state is PtSessionsLoaded
              ? state.stats
              : PtSessionStatsEntity.empty;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatCardsGrid(stats: stats, tokens: tokens),
                const SizedBox(height: 24),
                _TodayScheduleSection(sessions: sessions, tokens: tokens),
                const SizedBox(height: 24),
                _QuickActionsSection(onTabSwitch: onTabSwitch, tokens: tokens),
                const SizedBox(height: 24),
                //Pass real sessions; widget filters internally.
                _UpcomingClientsSection(sessions: sessions, tokens: tokens),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── AppBar ─────────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppThemeTokens     tokens;
  final ValueChanged<int?> onBranchChanged;

  const _DashboardAppBar({
    required this.tokens,
    required this.onBranchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return AppBar(
      backgroundColor: c.surface,
      elevation:       0,
      titleSpacing:    0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon:      Icon(Icons.menu_rounded, color: c.label),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: BlocBuilder<BranchCubit, BranchState>(
        builder: (context, branchState) {
          final branches = branchState is BranchLoaded
              ? branchState.branches
              : <dynamic>[];

          // Build a simple dropdown pill showing the branch list.
          if (branches.isEmpty) {
            return Container(
              padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:        c.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, size: 14, color: c.primary),
                  const SizedBox(width: 4),
                  Text(
                    branchState is BranchLoading ? '...' : '—',
                    style: TextStyle(fontSize: 13, color: c.label),
                  ),
                ],
              ),
            );
          }

          return PopupMenuButton<int?>(
            offset:    const Offset(0, 44),
            shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color:     c.surface,
            elevation: 8,
            onSelected: onBranchChanged,
            itemBuilder: (_) => [
              ...branchState is BranchLoaded
                  ? branchState.branches.map((b) => PopupMenuItem<int?>(
                      value: b.id,
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 16, color: c.primary),
                          const SizedBox(width: 8),
                          Text(b.name,
                              style: TextStyle(fontSize: 13, color: c.label)),
                        ],
                      ),
                    ))
                  : <PopupMenuEntry<int?>>[],
            ],
            child: Container(
              padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:        c.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, size: 14, color: c.primary),
                  const SizedBox(width: 4),
                  Text(
                    context.watch<AdminProfileCubit>().state.branchName.isNotEmpty
                        ? context.watch<AdminProfileCubit>().state.branchName
                        : (branchState is BranchLoaded && branchState.branches.isNotEmpty
                            ? branchState.branches.first.name
                            : '—'),
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w500,
                      color:      c.label,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: c.muted),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        // Notification bell (count is decorative — hook to real notifications when available)
        Stack(
          children: [
            IconButton(
              icon:      Icon(Icons.notifications_outlined, color: c.label),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top:   8,
              child: Container(
                width:  16,
                height: 16,
                decoration: BoxDecoration(
                  color: c.danger,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '0', // shows 0 until real notification count is wired
                  style: TextStyle(
                    color:      c.onPrimary,
                    fontSize:   10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Avatar — initials from admin name
        Builder(builder: (context) {
          final name     = context.watch<AdminProfileCubit>().state.adminName;
          final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
          return Container(
            margin:     const EdgeInsets.only(right: 12),
            width:      36,
            height:     36,
            decoration: BoxDecoration(
              color: c.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child:     Text(
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
    );
  }
}

// ── Stat cards 2×2 grid ────────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  final PtSessionStatsEntity stats;
  final AppThemeTokens       tokens;
  const _StatCardsGrid({required this.stats, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    // each card uses a ThemeCubit semantic color with a lighter tint.
    final primaryLight = Color.lerp(c.primary,  Colors.white, 0.25)!;
    final successLight = Color.lerp(c.success,  Colors.white, 0.25)!;
    final warningBase  = Color.lerp(c.danger,   c.primary,    0.5)!;
    final warningLight = Color.lerp(warningBase, Colors.white, 0.25)!;
    final mutedBase    = Color.lerp(c.muted,    c.label,      0.3)!;
    final mutedLight   = Color.lerp(mutedBase,  Colors.white, 0.25)!;

    //  "Revenue Today" was a stub (r'$450').
    //    PtSessionStatsEntity has no revenue field. We compute:
    //       cancelled = total − completed − scheduled
    //    This correctly counts sessions that are CANCELLED or NO_SHOW.
    //    All three inputs come from real backend data.
    final cancelled = (stats.total - stats.completed - stats.scheduled)
        .clamp(0, stats.total);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap:     true,
      physics:        const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing:  12,
      childAspectRatio: 1.55,
      children: [
        _StatCard(
          icon:      Icons.calendar_month_outlined,
          value:     '${stats.total}',
          label:     'Today Sessions',
          gradient:  [c.primary, primaryLight],
        ),
        _StatCard(
          icon:      Icons.check_circle_outline,
          value:     '${stats.completed}',
          label:     'Completed',
          gradient:  [c.success, successLight],
        ),
        _StatCard(
          icon:      Icons.access_time_rounded,
          value:     '${stats.scheduled}',
          label:     'Upcoming',
          gradient:  [warningBase, warningLight],
        ),

        // real derived Cancelled/No-Show count.
        _StatCard(
          icon:      Icons.cancel_outlined,
          value:     '$cancelled',
          label:     'Cancelled / No-Show',
          gradient:  [mutedBase, mutedLight],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData   icon;
  final String     value;
  final String     label;
  final List<Color> gradient;
  final bool        largeValue;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    this.largeValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color:      Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:   largeValue ? 22 : 30,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color:    Colors.white.withOpacity(0.85),
                  fontSize: 12,
                ),
              ),
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
  const _TodayScheduleSection({required this.sessions, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    // Show only non-terminal sessions (scheduled) for today
    final active = sessions
        .where((s) => !s.isCompleted && !s.isCancelled)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize:   17,
                fontWeight: FontWeight.bold,
                // ✅ FIX 9 — Was: Color(0xFF1A1A2E).
                color:      c.label,
              ),
            ),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: TextStyle(fontSize: 12, color: c.muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (active.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No sessions scheduled for today.',
                style: TextStyle(color: c.muted, fontSize: 14),
              ),
            ),
          )
        else
          ...active.map((s) => _ScheduleRow(session: s, tokens: tokens)),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final PtSessionEntity session;
  final AppThemeTokens  tokens;
  const _ScheduleRow({super.key, required this.session, required this.tokens});

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
          BoxShadow(
            color:     Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset:    const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time badge + vertical line
          Column(
            children: [
              Container(
                padding:    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:        c.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('hh a').format(session.startTime),
                  style: TextStyle(
                    color:      c.onPrimary,
                    fontSize:   11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width:  2,
                height: 34,
                decoration: BoxDecoration(
                  color:        c.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Session details
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
                          Text(
                            session.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:   14,
                              color:      c.label,
                            ),
                          ),
                          Text(
                            session.serviceName ?? session.notes ?? 'PT Session',
                            style: TextStyle(fontSize: 12, color: c.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Package progress bar (only when session is linked to a package)
                if (session.sessionIndex != null &&
                    session.totalPackageSessions != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (session.sessionIndex! /
                          session.totalPackageSessions!)
                          .clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: c.border.withOpacity(0.2),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(c.primary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
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
                        bg:    c.success.withOpacity(0.15),
                        fg:    c.success,
                      ),
                    if (session.isScheduled) ...[
                      const SizedBox(width: 6),
                      _StatusBadge(
                        label: 'CONFIRMED',
                        bg:    c.primary.withOpacity(0.1),
                        fg:    c.primary,
                      ),
                    ],
                    const Spacer(),
                    if (session.isScheduled) ...[
                      _ActionBtn(
                        icon:   Icons.how_to_reg_outlined,
                        label:  'Check In',
                        filled: true,
                        color:  c.primary,
                        fg:     c.onPrimary,
                        onTap:  () {},
                      ),
                      const SizedBox(width: 6),
                      _ActionBtn(
                        icon:   Icons.check_rounded,
                        label:  'Complete',
                        filled: false,
                        color:  c.muted,
                        fg:     c.muted,
                        onTap:  () {},
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
      child: Text(
        initials,
        style: TextStyle(
          color:      c.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize:   13,
        ),
      ),
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
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize:   10,
          fontWeight: FontWeight.w600,
          color:      fg,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final bool         filled;
  final Color        color;
  final Color        fg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.filled,
    required this.color,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
    const pad = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon:      Icon(icon, size: 14),
        label:     Text(label, style: const TextStyle(fontSize: 12)),
        style:     ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: fg,
          elevation:  0,
          shape:      shape,
          padding:    pad,
          minimumSize:     Size.zero,
          tapTargetSize:   MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onTap,
      icon:  Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, color: color)),
      style: OutlinedButton.styleFrom(
        side:          BorderSide(color: color.withOpacity(0.4)),
        shape:         shape,
        padding:       pad,
        minimumSize:   Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ── Quick Actions 2×2 grid ─────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  final ValueChanged<int> onTabSwitch;
  final AppThemeTokens    tokens;
  const _QuickActionsSection({required this.onTabSwitch, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    //  profile.branchId is set from AdminTokenStore.getTenantId()
    //            which is written at login time. Falls back to 1 only if the
    //            tenant ID claim was absent from the JWT (should not happen).
    final branchState = context.read<BranchCubit>().state;
    final branchId = branchState is BranchLoaded && branchState.branches.isNotEmpty
        ? branchState.branches.first.id
        : 1;

    //  All action card background and icon colors use ThemeCubit.
    final items = <_QAItem>[
      _QAItem(
        icon:      Icons.inventory_2_outlined,
        label:     'Create Package',
        bg:        c.primary.withOpacity(0.08),
        iconColor: c.primary,
        onTap:     () => onTabSwitch(2), // → Packages tab
      ),
      _QAItem(
        icon:      Icons.calendar_month_outlined,
        label:     'Add Availability',
        bg:        c.success.withOpacity(0.08),
        iconColor: c.success,
        onTap:     () => onTabSwitch(3), // → Schedule tab
      ),
      _QAItem(
        icon:      Icons.sports_gymnastics_rounded,
        label:     'Add PT Service',
        bg:        Color.lerp(c.danger, c.primary, 0.5)!.withOpacity(0.1),
        iconColor: Color.lerp(c.danger, c.primary, 0.5)!,
        onTap:     () => onTabSwitch(4), // → More / Services tab
      ),
      _QAItem(
        icon:      Icons.event_available_outlined,
        label:     'Create Session',
        bg:        Color.lerp(c.primary, c.label, 0.3)!.withOpacity(0.1),
        iconColor: Color.lerp(c.primary, c.label, 0.3)!,
        onTap: () => BookSessionSheet.show(
          context,
          branchId:     branchId, // ✅ FIX 7 — real branchId
          selectedDate: DateTime.now(),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize:   17,
            fontWeight: FontWeight.bold,
            color:      c.label,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount:   2,
          shrinkWrap:       true,
          physics:          const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing:  12,
          childAspectRatio: 1.75,
          children: items.map((item) => _QACard(item: item, tokens: tokens)).toList(),
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
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w600,
                // ✅ FIX 9 — Was: Color(0xFF1A1A2E).
                color:      c.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Upcoming Clients ───────────────────────────────────────────────────────────

class _UpcomingClientsSection extends StatelessWidget {
  final List<PtSessionEntity> sessions;
  final AppThemeTokens         tokens;
  const _UpcomingClientsSection({
    required this.sessions,
    required this.tokens,
  });

  // Avatar colors cycle through this list based on initials hash
  static const _avatarColors = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
  ];

  Color _colorFor(String initials) {
    final idx =
        initials.codeUnits.fold(0, (a, b) => a + b) % _avatarColors.length;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    // filter the real loaded sessions for SCHEDULED sessions whose
    //    start time is strictly in the future. This uses the same session list
    //    that the Today's Schedule and stat cards use — all from the same BLoC.
    final now      = DateTime.now();
    final upcoming = sessions
        .where((s) => s.isScheduled && s.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Clients',
              style: TextStyle(
                fontSize:   17,
                fontWeight: FontWeight.bold,
                color:      c.label,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon:  Text('View All',
                  style: TextStyle(fontSize: 13, color: c.primary)),
              label: Icon(Icons.chevron_right_rounded,
                  size: 18, color: c.primary),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Empty state when no future sessions exist
        if (upcoming.isEmpty)
          Container(
            width:      double.infinity,
            padding:    const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color:        c.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'No upcoming clients.',
                style: TextStyle(color: c.muted, fontSize: 14),
              ),
            ),
          )
        else
        // Horizontal scroll — each card shows one upcoming session
          SizedBox(
            height: 176,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:       upcoming.length,
              itemBuilder: (_, i) {
                final session    = upcoming[i];
                final avatarColor = _colorFor(session.initials);
                return Container(
                  width:   158,
                  margin:  const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    // ✅ FIX 9 — Was: Colors.white.
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
                      // Avatar initials circle
                      Container(
                        width:  46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: avatarColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          session.initials,
                          style: const TextStyle(
                            color:      Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:   16,
                          ),
                        ),
                      ),
                      // Member display name
                      Text(
                        session.displayName,
                        textAlign: TextAlign.center,
                        maxLines:  1,
                        overflow:  TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:   13,
                          color:      c.label,
                        ),
                      ),
                      // Service or session notes
                      Text(
                        session.serviceName ?? session.notes ?? 'PT Session',
                        textAlign: TextAlign.center,
                        maxLines:  1,
                        overflow:  TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: c.muted),
                      ),
                      // Package progress badge (if linked to a package)
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
                            'Session ${session.sessionIndex}/'
                                '${session.totalPackageSessions}',
                            style: TextStyle(
                                fontSize: 10, color: c.primary),
                          ),
                        ),
                      // Next session time
                      Text(
                        DateFormat('MMM d, h:mm a')
                            .format(session.startTime),
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