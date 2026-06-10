// FILE: lib/features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart

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
import '../widgets/large_stat_cards_grid.dart';
import '../widgets/small_metric_cards_grid.dart';
import '../widgets/text_metric_rows.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_activity_feed.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // ── Time period filter ─────────────────────────────────────────────────────
  // API values — display labels are derived from l10n at build time.
  final List<String> _periodKeys = ['today', 'week', 'month', 'custom'];
  String _selectedPeriodKey = 'today';

  // ── Branch filter ──────────────────────────────────────────────────────────
  int? _selectedBranchId;
  bool _firstBranchDialogShown = false;

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final sp      = tokens.spacing;
    final card    = tokens.card;
    final profile = context.watch<AdminProfileCubit>().state;
    final l10n    = AppLocalizations.of(context)!;

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
      child: Scaffold(
      drawer: AdminNavigationDrawer(
        gymName:         profile.gymName,
        branchName:      profile.branchName,
        adminName:       profile.adminName,
        adminEmail:      profile.adminEmail,
        avatarUrl:       profile.avatarUrl,
        initialActiveId: 'dashboard',
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, c, sp, card, l10n),
            _buildPeriodSelector(context, c, sp, card, l10n),
            Expanded(child: _buildBody(context, c, sp, l10n)),
          ],
        ),
      ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, dynamic c, dynamic sp, dynamic card, AppLocalizations l10n) {
    return Container(
      color:   c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Hamburger menu opens the AdminNavigationDrawer
          Builder(
            builder: (context) => IconButton(
              icon:      Icon(Icons.menu_rounded, color: c.label),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),

          const SizedBox(width: 10),

          // ── Branch selector pill ─────────────────────────────────────────
          // ✅ FIX 3 (continued) — BlocBuilder reads from BranchCubit.
          //    BranchCubit is provided by MultiBlocProvider in app_router.dart
          //    for this route
          //    While loading → shows a spinner pill.
          //    On error / initial → shows an ellipsis pill.
          //    On loaded → shows a PopupMenuButton with real branch names from backend.
          Expanded(
            child: BlocBuilder<BranchCubit, BranchState>(
              builder: (context, branchState) {
                // While branches are loading from backend
                if (branchState is BranchLoading || branchState is BranchInitial) {
                  return _branchPillPlaceholder(c, isLoading: true);
                }

                // If branch fetch failed — show static "All Branches" pill
                if (branchState is! BranchLoaded) {
                  return _branchPillPlaceholder(c, isLoading: false);
                }

                // Branches loaded → build real popup menu
                final branches = (branchState as BranchLoaded).branches;

                // Derive the display name from the selected branch ID
                // null _selectedBranchId → "All Branches"
                final selectedName = _selectedBranchId == null
                    ? l10n.admin_dashboard_allBranches
                    : branches
                    .where((b) => b.id == _selectedBranchId)
                    .map((b) => b.name)
                    .firstOrNull ?? l10n.admin_dashboard_allBranches;

                return PopupMenuButton<int?>(
                  offset: const Offset(0, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(card.radius)),
                  color:     c.surface,
                  elevation: 8,
                  onSelected: (int? id) =>
                      setState(() => _selectedBranchId = id),
                  itemBuilder: (context) => [
                    // First item is always "All Branches" (id = null)
                    PopupMenuItem<int?>(
                      value: null,
                      child: _branchMenuItem(
                        context,
                        c:          c,
                        icon:       Icons.business_rounded,
                        name:       l10n.admin_dashboard_allBranches,
                        isSelected: _selectedBranchId == null,
                      ),
                    ),
                    // One item per branch returned by backend
                    ...branches.map(
                          (b) => PopupMenuItem<int?>(
                        value: b.id,
                        child: _branchMenuItem(
                          context,
                          c:          c,
                          icon:       Icons.location_on_rounded,
                          name:       b.name,
                          isSelected: b.id == _selectedBranchId,
                        ),
                      ),
                    ),
                  ],
                  // The pill itself (always visible, tapping opens the popup)
                  child: _branchPill(c, selectedName),
                );
              },
            ),
          ),

          Text(
            l10n.navDashboard,
            style: TextStyle(
              fontSize:   17,
              fontWeight: FontWeight.w700,
              color:      c.label,
            ),
          ),
          const Spacer(),

          // ── Notification bell ──────────────────────────────────────────────
          Stack(
            children: [
              Container(
                width:  36,
                height: 36,
                decoration: BoxDecoration(
                  color:        c.border.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.notifications_none_rounded,
                    color: c.body, size: 18),
              ),
              Positioned(
                top:   2,
                right: 2,
                child: Container(
                  width:  16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: c.danger,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color:      Colors.white,
                            fontSize:   9,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Branch pill helper (the collapsed button shown in the app bar) ──────────
  Widget _branchPill(dynamic c, String label) {
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        c.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 14, color: c.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      c.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: c.primary),
        ],
      ),
    );
  }

  // ── Placeholder pill shown while BranchCubit is loading or errored ─────────
  Widget _branchPillPlaceholder(dynamic c, {required bool isLoading}) {
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        c.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ? SizedBox(
        width:  14,
        height: 14,
        child:  CircularProgressIndicator(
          strokeWidth: 1.5,
          color:       c.primary,
        ),
      )
          : Text('—',
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w600,
            color:      c.primary,
          )),
    );
  }

  // ── Single popup menu row (icon + name + optional checkmark) ───────────────
  Widget _branchMenuItem(
      BuildContext context, {
        required dynamic c,
        required IconData icon,
        required String name,
        required bool isSelected,
      }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: c.primary),
        const SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            fontSize:   13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color:      c.body,
          ),
        ),
        const Spacer(),
        if (isSelected)
          Icon(Icons.check_rounded, size: 16, color: c.primary),
      ],
    );
  }

  // ── Period selector row (Today / This Week / This Month / Custom) ──────────
  Widget _buildPeriodSelector(
      BuildContext context, dynamic c, dynamic sp, dynamic card, AppLocalizations l10n) {
    return Container(
      color:   c.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding:    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:        c.background,
          borderRadius: BorderRadius.circular(10),
          border:       Border.all(color: c.border.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.admin_dashboard_timePeriod,
              style: TextStyle(
                  fontSize:   13,
                  color:      c.muted,
                  fontWeight: FontWeight.w500),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriodKey,
                icon:  Icon(Icons.keyboard_arrow_down_rounded,
                    color: c.body, size: 18),
                isDense: true,
                style:   TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      c.label),
                items: _periodKeys.map((key) {
                  final label = {
                    'today': l10n.admin_dashboard_today,
                    'week':  l10n.admin_dashboard_thisWeek,
                    'month': l10n.admin_dashboard_thisMonth,
                    'custom': l10n.admin_dashboard_custom,
                  }[key]!;
                  return DropdownMenuItem(value: key, child: Text(label));
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedPeriodKey = value);
                  context.read<AdminDashboardBloc>().add(
                    AdminDashboardPeriodChanged(period: value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main body — delegates to BlocBuilder ───────────────────────────────────
  Widget _buildBody(BuildContext context, dynamic c, dynamic sp, AppLocalizations l10n) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        // ── Loading ──
        if (state is AdminDashboardLoading) {
          return Center(
              child: CircularProgressIndicator(color: c.primary));
        }

        // ── Error with retry button ──
        if (state is AdminDashboardError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:  56,
                    height: 56,
                    decoration: BoxDecoration(
                      color:        c.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.error_outline_rounded,
                        color: c.danger, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style:     TextStyle(color: c.body, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
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

        // ── Loaded — render all dashboard sections ──
        if (state is AdminDashboardLoaded) {
          return RefreshIndicator(
            color:     c.primary,
            onRefresh: () async {
              context.read<AdminDashboardBloc>().add(
                AdminDashboardRefreshRequested(period: state.period),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 4 large cards: Active Members, Pending Renewals,
                  // Today's Check-ins, Upcoming PT
                  LargeStatCardsGrid(data: state.data),
                  const SizedBox(height: 14),

                  // 4 small metric cards: Attendance, Payments Collected,
                  // Expiring Plans, Total Members
                  SmallMetricCardsGrid(data: state.data),
                  const SizedBox(height: 14),

                  // Text rows: Total Plans, Canceled, Churn Rate, Monthly Revenue
                  TextMetricRows(data: state.data),
                  const SizedBox(height: 20),

                  // Quick Actions: AI Assistant, Record Payment, Add Plan,
                  // Send Announcement
                  QuickActionsSection(
                    onAiAssistant: () =>
                        Navigator.pushNamed(context, AppRouter.adminAiAssistant),
                    onRecordPayment: () => AppToast.info(context, 'Coming soon'),
                    onAddPlan: () =>
                        Navigator.pushNamed(context, AppRouter.adminPlans),
                    onSendAnnouncement: () => AppToast.info(context, 'Coming soon'),
                  ),
                  const SizedBox(height: 20),

                  // Recent Activity feed — last 10 events from backend
                  RecentActivityFeed(
                      activities: state.data.recentActivity.activities),
                ],
              ),
            ),
          );
        }

        // AdminDashboardInitial — very brief, BLoC fires LoadRequested immediately
        return const SizedBox.shrink();
      },
    );
  }
}