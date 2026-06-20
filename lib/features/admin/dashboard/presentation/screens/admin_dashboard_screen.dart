// FILE: lib/features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart
//
// Admin dashboard redesigned to match the gym design:
//   AppBar (menu + Dashboard + bell)
//   TabBar: Membership | Payments | Attendance
//   Each tab = section headers + 2-column metric card grids.
//
// Data wiring:
//   • Every card is backed by a real /api/admin/dashboard field, except
//     Admission Fees, Service Paid and Service Due — there is no
//     admission-fee / generic "service" concept anywhere in the schema
//     yet, so those 3 still show "₹0" + a "… — coming soon" toast.

import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_router.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../branches/presentation/widgets/create_first_branch_dialog.dart';
import '../bloc/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard_event.dart';
import '../bloc/admin_dashboard_state.dart';
import '../widgets/dashboard_metric_card.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // ── First-run branch dialog guard ──────────────────────────────────────────
  bool _firstBranchDialogShown = false;

  // Maps a Payments-tab segment index to the ?revenuePeriod value sent to the backend.
  static const _revenuePeriodKeys = [
    'this_month', 'last_month', 'last_3_months', 'custom',
  ];

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _todayLabel() {
    final n = DateTime.now();
    return '${n.day} ${_months[n.month - 1]} ${n.year}';
  }

  String _monthLabel() {
    final n = DateTime.now();
    return '${_months[n.month - 1]} ${n.year}';
  }

  String _money(num v) => '₹${v.toStringAsFixed(0)}';

  void _comingSoon(String feature) {
    final l10n = AppLocalizations.of(context)!;
    AppToast.info(context, '$feature — ${l10n.admin_dashboard_comingSoon}');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<BranchCubit, BranchState>(
      listenWhen: (_, s) => s is BranchLoaded,
      listener: (context, state) {
        if (state is BranchLoaded &&
            state.branches.isEmpty &&
            !_firstBranchDialogShown) {
          _firstBranchDialogShown = true;
          final p = context.read<AdminProfileCubit>().state;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              showCreateFirstBranchDialog(
                context,
                initialName: p.gymName,
                initialEmail: p.adminEmail,
              );
            }
          });
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: AdminNavigationDrawer(
            gymName: profile.gymName,
            branchName: profile.branchName,
            adminName: profile.adminName,
            adminEmail: profile.adminEmail,
            avatarUrl: profile.avatarUrl,
            initialActiveId: 'dashboard',
          ),
          backgroundColor: c.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, c, l10n),
                _buildTabBar(c, l10n),
                _buildHint(c, l10n),
                Expanded(child: _buildBody(context, c, l10n)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, dynamic c, AppLocalizations l10n) {
    return Container(
      color: c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: c.label),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Expanded(
            child: Text(
              l10n.navDashboard,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.label,
              ),
            ),
          ),
          // Notification bell
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.adminNotifications),
              child: Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.border.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.notifications_none_rounded,
                        color: c.body, size: 18),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: c.danger,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('3',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TabBar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar(dynamic c, AppLocalizations l10n) {
    return Container(
      color: c.surface,
      child: TabBar(
        labelColor: c.primary,
        unselectedLabelColor: c.muted,
        indicatorColor: c.primary,
        indicatorWeight: 2.5,
        labelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        tabs: [
          Tab(text: l10n.admin_dashboard_tabMembership),
          Tab(text: l10n.admin_dashboard_tabPayments),
          Tab(text: l10n.admin_dashboard_tabAttendance),
        ],
      ),
    );
  }

  Widget _buildHint(dynamic c, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      color: c.background,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        l10n.admin_dashboard_cardHint,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: c.muted),
      ),
    );
  }

  // ── Body — handles loading / error / loaded then renders the 3 tabs ────────
  Widget _buildBody(BuildContext context, dynamic c, AppLocalizations l10n) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return Center(child: CircularProgressIndicator(color: c.primary));
        }

        if (state is AdminDashboardError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.error_outline_rounded,
                        color: c.danger, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: TextStyle(color: c.body, fontSize: 14),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AdminDashboardBloc>().add(
                          AdminDashboardLoadRequested(
                            period: state.period,
                            revenuePeriod: state.revenuePeriod,
                            revenueStartDate: state.revenueStartDate,
                            revenueEndDate: state.revenueEndDate,
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: c.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AdminDashboardLoaded) {
          return TabBarView(
            children: [
              _membershipTab(context, c, l10n, state),
              _paymentsTab(context, c, l10n, state),
              _attendanceTab(context, c, l10n, state),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ── Shared layout helpers ──────────────────────────────────────────────────
  Widget _sectionHeader(dynamic c, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: c.label,
          ),
        ),
      );

  /// 2-column grid of metric cards. Uses a fixed card height (mainAxisExtent)
  /// so cards stay consistent and never overflow regardless of screen width.
  Widget _grid(List<Widget> cards) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 104,
      ),
      itemBuilder: (_, i) => cards[i],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 1 — MEMBERSHIP
  // ════════════════════════════════════════════════════════════════════════
  Widget _membershipTab(BuildContext context, dynamic c,
      AppLocalizations l10n, AdminDashboardLoaded state) {
    final d = state.data;
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context.read<AdminDashboardBloc>().add(
            AdminDashboardRefreshRequested(
              period: state.period,
              revenuePeriod: state.revenuePeriod,
              revenueStartDate: state.revenueStartDate,
              revenueEndDate: state.revenueEndDate,
            ),
          ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
                c, '${l10n.admin_dashboard_sectionToday} – ${_todayLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.todayCheckins}',
                label: l10n.admin_dashboard_attendance,
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.members.birthdaysToday}',
                label: l10n.admin_dashboard_birthdays,
                icon: Icons.cake_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
              DashboardMetricCard(
                value: '${d.members.expiringToday}',
                label: l10n.admin_dashboard_expiresToday,
                icon: Icons.event_busy_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
              DashboardMetricCard(
                value: '${d.members.ptExpiringToday}',
                label: l10n.admin_dashboard_ptExpiringToday,
                icon: Icons.event_busy_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminPtSessions),
              ),
            ]),
            _sectionHeader(c,
                '${l10n.admin_dashboard_sectionAttendance} – ${_monthLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.attendanceCount}',
                label: l10n.admin_dashboard_monthlyCheckins,
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.checkins.uniqueMembersAttended}',
                label: l10n.admin_dashboard_uniqueMembersAttended,
                icon: Icons.groups_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
            ]),
            _sectionHeader(c, l10n.admin_dashboard_sectionMembershipExpiry),
            _grid([
              DashboardMetricCard(
                value: '${d.members.expiring1to3Days}',
                label: l10n.admin_dashboard_expiring1to3,
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
              DashboardMetricCard(
                value: '${d.members.expiring4to7Days}',
                label: l10n.admin_dashboard_expiring4to7,
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
              DashboardMetricCard(
                value: '${d.members.expiring8to15Days}',
                label: l10n.admin_dashboard_expiring8to15,
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
            ]),
            _sectionHeader(c, l10n.admin_dashboard_sectionPtPlanExpiry),
            _grid([
              DashboardMetricCard(
                value: '${d.members.ptExpiring1to7Days}',
                label: l10n.admin_dashboard_ptExpiring1to7,
                icon: Icons.fitness_center_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminPtSessions),
              ),
              DashboardMetricCard(
                value: '${d.members.ptExpiring8to15Days}',
                label: l10n.admin_dashboard_ptExpiring8to15,
                icon: Icons.fitness_center_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminPtSessions),
              ),
            ]),
            const SizedBox(height: 20),
            _primaryButton(
              c,
              icon: Icons.assignment_turned_in_rounded,
              label: l10n.admin_dashboard_recordAttendance,
              onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 2 — PAYMENTS
  // ════════════════════════════════════════════════════════════════════════
  Widget _paymentsTab(BuildContext context, dynamic c, AppLocalizations l10n,
      AdminDashboardLoaded state) {
    final d = state.data;
    final rev = d.revenue;
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context.read<AdminDashboardBloc>().add(
            AdminDashboardRefreshRequested(
              period: state.period,
              revenuePeriod: state.revenuePeriod,
              revenueStartDate: state.revenueStartDate,
              revenueEndDate: state.revenueEndDate,
            ),
          ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(c,
                '${l10n.admin_dashboard_sectionTodaysCollection} – ${_todayLabel()}'),
            DashboardMetricCard(
              value: _money(rev?.paymentsCollected ?? 0),
              label: l10n.admin_dashboard_membershipCollectedToday,
              icon: Icons.payments_rounded,
              highlighted: true,
              onTap: () => Navigator.pushNamed(context, '/admin/invoices'),
            ),
            _sectionHeader(c, _revenuePeriodLabel(state)),
            _paymentsPeriodSegment(context, c, l10n, state),
            const SizedBox(height: 12),
            _grid([
              DashboardMetricCard(
                value: _money(0),
                label: l10n.admin_dashboard_admissionFees,
                icon: Icons.how_to_reg_rounded,
                onTap: () => _comingSoon(l10n.admin_dashboard_admissionFees),
              ),
              DashboardMetricCard(
                value: _money(rev?.monthlyRevenue ?? 0),
                label: l10n.admin_dashboard_membershipCollected,
                icon: Icons.account_balance_wallet_rounded,
                onTap: () => Navigator.pushNamed(context, '/admin/invoices'),
              ),
              DashboardMetricCard(
                value: _money(rev?.membershipDue ?? 0),
                label: l10n.admin_dashboard_membershipDue,
                icon: Icons.wallet_rounded,
                valueColor: c.danger,
                highlighted: true,
                onTap: () => Navigator.pushNamed(context, '/admin/invoices'),
              ),
              DashboardMetricCard(
                value: _money(rev?.ptDue ?? 0),
                label: l10n.admin_dashboard_ptDue,
                icon: Icons.wallet_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, '/admin/invoices'),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: l10n.admin_dashboard_servicePaid,
                icon: Icons.receipt_long_rounded,
                onTap: () => _comingSoon(l10n.admin_dashboard_servicePaid),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: l10n.admin_dashboard_serviceDue,
                icon: Icons.receipt_long_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon(l10n.admin_dashboard_serviceDue),
              ),
            ]),
            const SizedBox(height: 12),
            DashboardMetricCard(
              value: _money(rev?.monthlyExpense ?? 0),
              label: l10n.admin_dashboard_expense,
              icon: Icons.money_off_rounded,
              valueColor: c.danger,
              onTap: () => Navigator.pushNamed(context, AppRouter.adminExpenses),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentsPeriodSegment(BuildContext context, dynamic c,
      AppLocalizations l10n, AdminDashboardLoaded state) {
    final labels = [
      l10n.admin_dashboard_thisMonth,
      l10n.admin_dashboard_lastMonth,
      l10n.admin_dashboard_last3Months,
      l10n.admin_dashboard_custom,
    ];
    final selectedIndex = _revenuePeriodKeys.indexOf(state.revenuePeriod);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onRevenuePeriodTap(context, state, i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? c.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? c.onPrimary : c.muted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Tapping "Custom" opens a date range picker; the other 3 segments refetch
  // the dashboard immediately with the matching ?revenuePeriod value.
  Future<void> _onRevenuePeriodTap(
      BuildContext context, AdminDashboardLoaded state, int index) async {
    final key = _revenuePeriodKeys[index];

    if (key == 'custom') {
      final now = DateTime.now();
      final initialRange = (state.revenueStartDate != null &&
              state.revenueEndDate != null)
          ? DateTimeRange(
              start: DateTime.parse(state.revenueStartDate!),
              end: DateTime.parse(state.revenueEndDate!),
            )
          : DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);

      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(now.year - 5),
        lastDate: now,
        initialDateRange: initialRange,
      );
      if (picked == null || !context.mounted) return;

      context.read<AdminDashboardBloc>().add(AdminDashboardRevenuePeriodChanged(
            period: state.period,
            revenuePeriod: 'custom',
            revenueStartDate: _isoDate(picked.start),
            revenueEndDate: _isoDate(picked.end),
          ));
      return;
    }

    context.read<AdminDashboardBloc>().add(AdminDashboardRevenuePeriodChanged(
          period: state.period,
          revenuePeriod: key,
        ));
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  // Section-header label above the segment control, e.g. "Jun 2026",
  // "May 2026", "Last 3 Months", or "3 Apr – 19 Jun 2026" for a custom range.
  String _revenuePeriodLabel(AdminDashboardLoaded state) {
    switch (state.revenuePeriod) {
      case 'last_month':
        final now = DateTime.now();
        final lastMonth = DateTime(now.year, now.month - 1);
        return '${_months[lastMonth.month - 1]} ${lastMonth.year}';
      case 'last_3_months':
        return AppLocalizations.of(context)!.admin_dashboard_last3Months;
      case 'custom':
        final start = state.revenueStartDate;
        final end = state.revenueEndDate;
        if (start != null && end != null) {
          final s = DateTime.parse(start);
          final e = DateTime.parse(end);
          return '${s.day} ${_months[s.month - 1]} – ${e.day} ${_months[e.month - 1]} ${e.year}';
        }
        return AppLocalizations.of(context)!.admin_dashboard_custom;
      default:
        return _monthLabel();
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 3 — ATTENDANCE
  // ════════════════════════════════════════════════════════════════════════
  Widget _attendanceTab(BuildContext context, dynamic c, AppLocalizations l10n,
      AdminDashboardLoaded state) {
    final d = state.data;
    final growth = d.checkins.attendanceGrowth;
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context.read<AdminDashboardBloc>().add(
            AdminDashboardRefreshRequested(
              period: state.period,
              revenuePeriod: state.revenuePeriod,
              revenueStartDate: state.revenueStartDate,
              revenueEndDate: state.revenueEndDate,
            ),
          ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
                c, '${l10n.admin_dashboard_sectionToday} – ${_todayLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.todayCheckins}',
                label: l10n.admin_dashboard_todayCheckins,
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.checkins.upcomingPTSessions}',
                label: l10n.admin_dashboard_upcomingPtSessions,
                icon: Icons.fitness_center_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminPtSessions),
              ),
            ]),
            _sectionHeader(c,
                '${l10n.admin_dashboard_sectionAttendance} – ${_monthLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.attendanceCount}',
                label: l10n.admin_dashboard_monthlyCheckins,
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(0)}%',
                label: l10n.admin_dashboard_attendanceGrowth,
                icon: Icons.trending_up_rounded,
                valueColor: growth >= 0 ? c.success : c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.checkins.uniqueMembersAttended}',
                label: l10n.admin_dashboard_uniqueMembersAttended,
                icon: Icons.groups_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.checkins.absentMembers}',
                label: l10n.admin_dashboard_absentMembers,
                icon: Icons.person_off_rounded,
                valueColor: c.danger,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminMembers),
              ),
            ]),
            const SizedBox(height: 20),
            _primaryButton(
              c,
              icon: Icons.assignment_turned_in_rounded,
              label: l10n.admin_dashboard_recordAttendance,
              onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
            ),
          ],
        ),
      ),
    );
  }

  // ── Primary action button ──────────────────────────────────────────────────
  Widget _primaryButton(dynamic c,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
