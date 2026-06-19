// FILE: lib/features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart
//
// Admin dashboard redesigned to match the gym design:
//   AppBar (menu + Dashboard + bell)
//   TabBar: Membership | Payments | Attendance
//   Each tab = section headers + 2-column metric card grids.
//
// Data wiring (STEP 1 — frontend only):
//   • Cards that map to data we already have from the backend show real values.
//   • Cards that need backend work we don't have yet show "0" / "₹0" and a
//     "… — coming soon" toast on tap. These are wired to real endpoints later.

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
import '../../domain/entities/admin_dashboard_summary.dart';
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

  // ── Payments period segment (local — backend wiring comes later) ───────────
  int _paymentsPeriodIndex = 0; // 0=This Month 1=Last Month 2=Last 3 Months 3=Custom

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

  void _comingSoon(String feature) =>
      AppToast.info(context, '$feature — coming soon');

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) showCreateFirstBranchDialog(context);
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
                _buildTabBar(c),
                _buildHint(c),
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
        ],
      ),
    );
  }

  // ── TabBar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar(dynamic c) {
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
        tabs: const [
          Tab(text: 'Membership'),
          Tab(text: 'Payments'),
          Tab(text: 'Attendance'),
        ],
      ),
    );
  }

  Widget _buildHint(dynamic c) {
    return Container(
      width: double.infinity,
      color: c.background,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Tap the card for additional information.',
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
                          AdminDashboardLoadRequested(period: state.period),
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
              _membershipTab(context, c, state.data),
              _paymentsTab(context, c, state.data),
              _attendanceTab(context, c, state.data),
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

  /// 2-column grid of metric cards.
  Widget _grid(List<Widget> cards) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: cards,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 1 — MEMBERSHIP
  // ════════════════════════════════════════════════════════════════════════
  Widget _membershipTab(
      BuildContext context, dynamic c, AdminDashboardSummary d) {
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context
          .read<AdminDashboardBloc>()
          .add(AdminDashboardRefreshRequested(period: d.period)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(c, 'Today – ${_todayLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.todayCheckins}',
                label: 'Attendance',
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Birthdays',
                icon: Icons.cake_rounded,
                onTap: () => _comingSoon('Birthdays'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Expires Today',
                icon: Icons.event_busy_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Expires Today'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'PT Plan Expiring Today',
                icon: Icons.event_busy_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('PT Plan Expiring Today'),
              ),
            ]),
            _sectionHeader(c, 'Attendance – ${_monthLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.attendanceCount}',
                label: 'Monthly Check-ins',
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Unique Members Attended',
                icon: Icons.groups_rounded,
                onTap: () => _comingSoon('Unique Members Attended'),
              ),
            ]),
            _sectionHeader(c, 'Membership Expiry'),
            _grid([
              DashboardMetricCard(
                value: '0',
                label: 'Expiring (1–3d)',
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Expiring (1–3d)'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Expiring (4–7d)',
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Expiring (4–7d)'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Expiring (8–15d)',
                icon: Icons.timelapse_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Expiring (8–15d)'),
              ),
            ]),
            _sectionHeader(c, 'PT Plan Expiry'),
            _grid([
              DashboardMetricCard(
                value: '0',
                label: 'PT Expiring (1–7d)',
                icon: Icons.fitness_center_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('PT Plan Expiry'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'PT Expiring (8–15d)',
                icon: Icons.fitness_center_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('PT Plan Expiry'),
              ),
            ]),
            const SizedBox(height: 20),
            _primaryButton(
              c,
              icon: Icons.assignment_turned_in_rounded,
              label: 'Record Attendance',
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
  Widget _paymentsTab(
      BuildContext context, dynamic c, AdminDashboardSummary d) {
    final rev = d.revenue;
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context
          .read<AdminDashboardBloc>()
          .add(AdminDashboardRefreshRequested(period: d.period)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(c, "Today's Collection – ${_todayLabel()}"),
            DashboardMetricCard(
              value: _money(rev?.paymentsCollected ?? 0),
              label: 'Membership Collected Today',
              icon: Icons.payments_rounded,
              highlighted: true,
              onTap: () => _comingSoon('Membership Collected Today'),
            ),
            _sectionHeader(c, _monthLabel()),
            _paymentsPeriodSegment(c),
            const SizedBox(height: 12),
            _grid([
              DashboardMetricCard(
                value: _money(0),
                label: 'Admission Fees',
                icon: Icons.how_to_reg_rounded,
                onTap: () => _comingSoon('Admission Fees'),
              ),
              DashboardMetricCard(
                value: _money(rev?.monthlyRevenue ?? 0),
                label: 'Membership Collected',
                icon: Icons.account_balance_wallet_rounded,
                onTap: () => _comingSoon('Membership Collected'),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: 'Membership Due',
                icon: Icons.wallet_rounded,
                valueColor: c.danger,
                highlighted: true,
                onTap: () => _comingSoon('Membership Due'),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: 'PT Due',
                icon: Icons.wallet_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('PT Due'),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: 'Service Paid',
                icon: Icons.receipt_long_rounded,
                onTap: () => _comingSoon('Service Paid'),
              ),
              DashboardMetricCard(
                value: _money(0),
                label: 'Service Due',
                icon: Icons.receipt_long_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Service Due'),
              ),
            ]),
            const SizedBox(height: 12),
            DashboardMetricCard(
              value: _money(0),
              label: 'Expense',
              icon: Icons.money_off_rounded,
              valueColor: c.danger,
              onTap: () => _comingSoon('Expense'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentsPeriodSegment(dynamic c) {
    const labels = ['This Month', 'Last Month', 'Last 3 Months', 'Custom'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == _paymentsPeriodIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _paymentsPeriodIndex = i);
                if (i != 0) _comingSoon(labels[i]);
              },
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

  // ════════════════════════════════════════════════════════════════════════
  // TAB 3 — ATTENDANCE
  // ════════════════════════════════════════════════════════════════════════
  Widget _attendanceTab(
      BuildContext context, dynamic c, AdminDashboardSummary d) {
    final growth = d.checkins.attendanceGrowth;
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async => context
          .read<AdminDashboardBloc>()
          .add(AdminDashboardRefreshRequested(period: d.period)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(c, 'Today – ${_todayLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.todayCheckins}',
                label: "Today's Check-ins",
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${d.checkins.upcomingPTSessions}',
                label: 'Upcoming PT Sessions',
                icon: Icons.fitness_center_rounded,
                onTap: () => _comingSoon('Upcoming PT Sessions'),
              ),
            ]),
            _sectionHeader(c, 'Attendance – ${_monthLabel()}'),
            _grid([
              DashboardMetricCard(
                value: '${d.checkins.attendanceCount}',
                label: 'Monthly Check-ins',
                icon: Icons.event_available_rounded,
                onTap: () => Navigator.pushNamed(context, AppRouter.adminCheckins),
              ),
              DashboardMetricCard(
                value: '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(0)}%',
                label: 'Attendance Growth',
                icon: Icons.trending_up_rounded,
                valueColor: growth >= 0 ? c.success : c.danger,
                onTap: () => _comingSoon('Attendance Growth'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Unique Members Attended',
                icon: Icons.groups_rounded,
                onTap: () => _comingSoon('Unique Members Attended'),
              ),
              DashboardMetricCard(
                value: '0',
                label: 'Absent Members',
                icon: Icons.person_off_rounded,
                valueColor: c.danger,
                onTap: () => _comingSoon('Absent Members'),
              ),
            ]),
            const SizedBox(height: 20),
            _primaryButton(
              c,
              icon: Icons.assignment_turned_in_rounded,
              label: 'Record Attendance',
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
