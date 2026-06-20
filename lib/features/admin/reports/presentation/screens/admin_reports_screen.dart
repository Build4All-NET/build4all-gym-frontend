// FILE: lib/features/admin/reports/presentation/screens/admin_reports_screen.dart
//
// Admin Reports screen — analytics over a selectable date range.
//   AppBar + period selector (This Month / Last Month / Last 3 Months / Custom)
//   TabBar: Financial | Attendance
//   Each tab: responsive KPI tiles + dependency-free bar charts.
// All numbers come from /api/admin/reports/{financial,attendance}.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_reports/admin_reports_bloc.dart';
import '../widgets/report_bar_chart_widget.dart';
import '../widgets/report_stat_tile_widget.dart';
import '../../domain/entities/financial_report_entity.dart';
import '../../domain/entities/attendance_report_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _money(num v) => '₹${v.toStringAsFixed(0)}';

  String _rangeText(DateTime from, DateTime to) =>
      '${from.day} ${_months[from.month - 1]} – ${to.day} ${_months[to.month - 1]} ${to.year}';

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
    );
    if (picked != null && context.mounted) {
      context.read<AdminReportsBloc>().add(
            ChangeReportPeriodEvent(ReportPeriod.custom,
                from: picked.start, to: picked.end),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AdminNavigationDrawer(
          gymName: profile.gymName,
          branchName: profile.branchName,
          adminName: profile.adminName,
          adminEmail: profile.adminEmail,
          avatarUrl: profile.avatarUrl,
          initialActiveId: 'reports',
        ),
        backgroundColor: c.background,
        body: SafeArea(
          child: Column(
            children: [
              AdminAppBar(title: l10n.navReports, notificationCount: 0),
              Container(
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
                    Tab(text: l10n.reports_tabFinancial),
                    Tab(text: l10n.reports_tabAttendance),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<AdminReportsBloc, AdminReportsState>(
                  builder: (context, state) {
                    if (state is AdminReportsLoading ||
                        state is AdminReportsInitial) {
                      return Center(
                          child: CircularProgressIndicator(color: c.primary));
                    }
                    if (state is AdminReportsError) {
                      return _errorView(context, c, l10n, state.message);
                    }
                    state as AdminReportsLoaded;
                    return Column(
                      children: [
                        _periodSelector(context, c, l10n, state),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _financialTab(context, c, l10n, state.financial),
                              _attendanceTab(context, c, l10n, state.attendance),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Period selector ──────────────────────────────────────────────────────
  Widget _periodSelector(BuildContext context, dynamic c, AppLocalizations l10n,
      AdminReportsLoaded state) {
    final labels = [
      l10n.admin_dashboard_thisMonth,
      l10n.admin_dashboard_lastMonth,
      l10n.admin_dashboard_last3Months,
      l10n.admin_dashboard_custom,
    ];
    const periods = [
      ReportPeriod.thisMonth,
      ReportPeriod.lastMonth,
      ReportPeriod.last3Months,
      ReportPeriod.custom,
    ];
    return Container(
      width: double.infinity,
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border.withOpacity(0.15)),
            ),
            child: Row(
              children: List.generate(labels.length, (i) {
                final selected = state.period == periods[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (periods[i] == ReportPeriod.custom) {
                        _pickCustomRange(context);
                      } else {
                        context
                            .read<AdminReportsBloc>()
                            .add(ChangeReportPeriodEvent(periods[i]));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: selected ? c.onPrimary : c.muted,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _rangeText(state.from, state.to),
            style: TextStyle(fontSize: 12, color: c.muted),
          ),
        ],
      ),
    );
  }

  // ── Financial tab ──────────────────────────────────────────────────────────
  Widget _financialTab(BuildContext context, dynamic c, AppLocalizations l10n,
      FinancialReportEntity f) {
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async =>
          context.read<AdminReportsBloc>().add(const RefreshReportsEvent()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _statsWrap(context, [
            ReportStatTile(
                label: l10n.reports_collected,
                value: _money(f.collected),
                icon: Icons.payments_rounded,
                valueColor: c.success),
            ReportStatTile(
                label: l10n.reports_expense,
                value: _money(f.expense),
                icon: Icons.money_off_rounded,
                valueColor: c.danger),
            ReportStatTile(
                label: l10n.reports_net,
                value: _money(f.net),
                icon: Icons.account_balance_wallet_rounded,
                valueColor: f.net >= 0 ? c.success : c.danger),
            ReportStatTile(
                label: l10n.admin_dashboard_membershipDue,
                value: _money(f.membershipDue),
                icon: Icons.wallet_rounded,
                valueColor: c.danger),
            ReportStatTile(
                label: l10n.admin_dashboard_ptDue,
                value: _money(f.ptDue),
                icon: Icons.wallet_rounded,
                valueColor: c.danger),
          ]),
          const SizedBox(height: 20),
          _chartSection(c, l10n.reports_collectedOverTime,
              ReportBarChartWidget(
                points: f.collectedSeries,
                emptyLabel: l10n.reports_noData,
                barColor: c.primary,
                valueFormatter: (v) => _money(v),
              )),
          const SizedBox(height: 20),
          _chartSection(c, l10n.reports_expenseByCategory,
              ReportBarChartWidget(
                points: f.expenseByCategory,
                emptyLabel: l10n.reports_noData,
                barColor: c.danger,
                valueFormatter: (v) => _money(v),
              )),
        ],
      ),
    );
  }

  // ── Attendance tab ───────────────────────────────────────────────────────────
  Widget _attendanceTab(BuildContext context, dynamic c, AppLocalizations l10n,
      AttendanceReportEntity a) {
    return RefreshIndicator(
      color: c.primary,
      onRefresh: () async =>
          context.read<AdminReportsBloc>().add(const RefreshReportsEvent()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _statsWrap(context, [
            ReportStatTile(
                label: l10n.reports_totalCheckins,
                value: '${a.totalCheckins}',
                icon: Icons.event_available_rounded),
            ReportStatTile(
                label: l10n.reports_uniqueMembers,
                value: '${a.uniqueMembers}',
                icon: Icons.groups_rounded),
            ReportStatTile(
                label: l10n.reports_avgPerDay,
                value: a.avgPerDay.toStringAsFixed(1),
                icon: Icons.trending_up_rounded),
          ]),
          const SizedBox(height: 20),
          _chartSection(c, l10n.reports_checkinsOverTime,
              ReportBarChartWidget(
                points: a.checkinsSeries,
                emptyLabel: l10n.reports_noData,
                barColor: c.primary,
              )),
        ],
      ),
    );
  }

  // ── Shared pieces ──────────────────────────────────────────────────────────
  /// Responsive KPI grid: 2 tiles per row, reflowing to fit the width.
  Widget _statsWrap(BuildContext context, List<Widget> tiles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: tiles
              .map((t) => SizedBox(width: tileWidth, child: t))
              .toList(),
        );
      },
    );
  }

  Widget _chartSection(dynamic c, String title, Widget chart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: c.label)),
          const SizedBox(height: 14),
          chart,
        ],
      ),
    );
  }

  Widget _errorView(BuildContext context, dynamic c, AppLocalizations l10n,
      String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: c.danger),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center, style: TextStyle(color: c.muted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<AdminReportsBloc>().add(const LoadReportsEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
