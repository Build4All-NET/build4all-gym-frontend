// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/screens/trainer_dashboard_screen.dart
//
// DESIGN: Images 1-2 — Dashboard tab.
//
// Sections:
//   1. AppBar — hamburger menu + branch selector + notification bell + avatar
//   2. Stat cards 2×2 grid: Today Sessions | Completed | Upcoming | Revenue Today
//   3. Today's Schedule — up to 3 live sessions with time badge, progress bar,
//      payment badge, Check In + Complete buttons
//   4. Quick Actions 2×2 grid — tap switches bottom-nav tab (or opens sheet)
//   5. Upcoming Clients — horizontal scroll
//
// Navigation:
//   [onTabSwitch] is provided by TrainerMainScreen so quick actions switch the
//   active tab without pushing a new route.  The user returns by tapping any
//   other tab in the bottom nav.
//
//   Tab indices (must stay in sync with trainer_main_screen.dart):
//     0  Dashboard
//     1  Sessions
//     2  Packages
//     3  Schedule
//     4  More / Services
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_state.dart';
import '../widgets/book_session_sheet_widget.dart';

class TrainerDashboardScreen extends StatelessWidget {
  /// Called with a tab index when a quick action requests tab navigation.
  /// Provided by [TrainerMainScreen].
  final ValueChanged<int> onTabSwitch;

  const TrainerDashboardScreen({
    super.key,
    required this.onTabSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const _DashboardAppBar(),
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
                _StatCardsGrid(stats: stats),
                const SizedBox(height: 24),
                _TodayScheduleSection(sessions: sessions),
                const SizedBox(height: 24),
                _QuickActionsSection(onTabSwitch: onTabSwitch),
                const SizedBox(height: 24),
                const _UpcomingClientsSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1A2E)),
        onPressed: () {},
      ),
      title: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mumbai Centre',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: Color(0xFF4B5563)),
            ],
          ),
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Color(0xFF1A1A2E)),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFF4F46E5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outline,
              color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

// ── Stat cards 2×2 grid ───────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  final PtSessionStatsEntity stats;
  const _StatCardsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _StatCard(
          icon: Icons.calendar_month_outlined,
          value: '${stats.total}',
          label: 'Today Sessions',
          gradient: const [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ),
        _StatCard(
          icon: Icons.check_circle_outline,
          value: '${stats.completed}',
          label: 'Completed',
          gradient: const [Color(0xFF059669), Color(0xFF10B981)],
        ),
        _StatCard(
          icon: Icons.access_time_rounded,
          value: '${stats.scheduled}',
          label: 'Upcoming',
          gradient: const [Color(0xFFD97706), Color(0xFFF59E0B)],
        ),
        _StatCard(
          icon: Icons.attach_money_rounded,
          value: r'$450', // TODO: replace with revenue endpoint value
          label: 'Revenue Today',
          gradient: const [Color(0xFF7C3AED), Color(0xFF9333EA)],
          largeValue: true,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final List<Color> gradient;
  final bool largeValue;

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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: largeValue ? 22 : 30,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
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

// ── Today's Schedule ──────────────────────────────────────────────────────────

class _TodayScheduleSection extends StatelessWidget {
  final List<PtSessionEntity> sessions;
  const _TodayScheduleSection({required this.sessions});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          )
        else
          ...active.map((s) => _ScheduleRow(session: s)),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final PtSessionEntity session;
  const _ScheduleRow({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time badge + vertical connector
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('hh a').format(session.startTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 2,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _MiniAvatar(initials: session.initials),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            session.serviceName ??
                                session.notes ??
                                'PT Session',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Package progress bar
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
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4F46E5)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${session.sessionIndex}/'
                      '${session.totalPackageSessions}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[500]),
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                Row(
                  children: [
                    if (session.paymentStatus != null)
                      _StatusBadge(
                        label: session.paymentStatus!.toUpperCase(),
                        bg: const Color(0xFFD1FAE5),
                        fg: const Color(0xFF059669),
                      ),
                    if (session.isScheduled) ...[
                      const SizedBox(width: 6),
                      const _StatusBadge(
                        label: 'CONFIRMED',
                        bg: Color(0xFFEEF2FF),
                        fg: Color(0xFF4F46E5),
                      ),
                    ],
                    const Spacer(),
                    if (session.isScheduled) ...[
                      _ActionBtn(
                        icon: Icons.how_to_reg_outlined,
                        label: 'Check In',
                        filled: true,
                        color: const Color(0xFF4F46E5),
                        onTap: () {},
                      ),
                      const SizedBox(width: 6),
                      _ActionBtn(
                        icon: Icons.check_rounded,
                        label: 'Complete',
                        filled: false,
                        color: const Color(0xFF4B5563),
                        onTap: () {},
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
  final String initials;
  const _MiniAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF8B5CF6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _StatusBadge({
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.filled,
    required this.color,
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
        icon: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: shape,
          padding: pad,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.4)),
        shape: shape,
        padding: pad,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ── Quick Actions 2×2 grid ────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  final ValueChanged<int> onTabSwitch;
  const _QuickActionsSection({required this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    final items = <_QAItem>[
      _QAItem(
        icon: Icons.inventory_2_outlined,
        label: 'Create Package',
        bg: const Color(0xFFEEF2FF),
        iconColor: const Color(0xFF4F46E5),
        onTap: () => onTabSwitch(2), // → Packages tab
      ),
      _QAItem(
        icon: Icons.calendar_month_outlined,
        label: 'Add Availability',
        bg: const Color(0xFFF0FDF4),
        iconColor: const Color(0xFF059669),
        onTap: () => onTabSwitch(3), // → Schedule tab
      ),
      _QAItem(
        icon: Icons.sports_gymnastics_rounded,
        label: 'Add PT Service',
        bg: const Color(0xFFFFF7ED),
        iconColor: const Color(0xFFD97706),
        onTap: () => onTabSwitch(4), // → More / Services tab
      ),
      _QAItem(
        icon: Icons.event_available_outlined,
        label: 'Create Session',
        bg: const Color(0xFFF5F3FF),
        iconColor: const Color(0xFF7C3AED),
        onTap: () => BookSessionSheet.show(
          context,
          branchId: 1, // TODO: real branchId
          selectedDate: DateTime.now(),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.75,
          children: items.map((item) => _QACard(item: item)).toList(),
        ),
      ],
    );
  }
}

class _QAItem {
  final IconData icon;
  final String label;
  final Color bg;
  final Color iconColor;
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
  final _QAItem item;
  const _QACard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: item.bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Upcoming Clients horizontal scroll ───────────────────────────────────────

class _UpcomingClientsSection extends StatelessWidget {
  const _UpcomingClientsSection();

  static const _clients = <_ClientData>[
    _ClientData(
      initials: 'LI',
      name: 'Layla Ibrahim',
      package: 'Premium Package',
      remaining: 12,
      nextDate: 'May 11, 2026',
    ),
    _ClientData(
      initials: 'KM',
      name: 'Khalid Mahmoud',
      package: 'Standard Package',
      remaining: 5,
      nextDate: 'May 12, 2026',
    ),
    _ClientData(
      initials: 'FS',
      name: 'Fatima Saleh',
      package: 'Elite Package',
      remaining: 20,
      nextDate: 'May 13, 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Clients',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Text(
                'View All',
                style: TextStyle(fontSize: 13, color: Color(0xFF4F46E5)),
              ),
              label: const Icon(Icons.chevron_right_rounded,
                  size: 18, color: Color(0xFF4F46E5)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 176,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _clients.length,
            itemBuilder: (_, i) => _ClientCard(client: _clients[i]),
          ),
        ),
      ],
    );
  }
}

class _ClientData {
  final String initials;
  final String name;
  final String package;
  final int remaining;
  final String nextDate;

  const _ClientData({
    required this.initials,
    required this.name,
    required this.package,
    required this.remaining,
    required this.nextDate,
  });
}

class _ClientCard extends StatelessWidget {
  final _ClientData client;
  const _ClientCard({super.key, required this.client});

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
    return Container(
      width: 158,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _colorFor(client.initials),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              client.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            client.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF1A1A2E),
            ),
          ),
          Text(
            client.package,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Remaining Sessions',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
          Text(
            '${client.remaining}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F46E5),
            ),
          ),
          Text(
            'Next: ${client.nextDate}',
            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
