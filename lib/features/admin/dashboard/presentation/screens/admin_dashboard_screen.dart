// FILE: lib/features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard_event.dart';
import '../bloc/admin_dashboard_state.dart';
import '../widgets/large_stat_cards_grid.dart';
import '../widgets/small_metric_cards_grid.dart';
import '../widgets/text_metric_rows.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_activity_feed.dart';
import '../../../../../core/theme/theme_cubit.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<String> _periodOptions = ['Today', 'This Week', 'This Month', 'Custom'];
  final Map<String, String> _periodMap = {
    'Today':      'today',
    'This Week':  'week',
    'This Month': 'month',
    'Custom':     'custom',
  };
  String _selectedPeriodLabel = 'Today';

  final List<String> _branchOptions = ['All Branches', 'Mumbai Central', 'Andheri West'];
  String _selectedBranch = 'Mumbai Central';

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final sp     = tokens.spacing;
    final card   = tokens.card;

    return Scaffold(
      drawer: const AdminNavigationDrawer(
        gymName:         'Build4All Gym',
        branchName:      'Downtown',
        adminName:       'Mounir',
        adminEmail:      'mounir@gym.com',
        avatarUrl:       null,
        initialActiveId: 'dashboard',
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, c, sp, card),
            _buildPeriodSelector(context, c, sp, card),
            Expanded(child: _buildBody(context, c, sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic c, dynamic sp, dynamic card) {
    return Container(
      color:   c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon:      Icon(Icons.menu_rounded, color: c.label),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),

          const SizedBox(width: 10),

          // Branch selector pill
          Expanded(
            child: PopupMenuButton<String>(
              offset: const Offset(0, 44),
              shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(card.radius)),
              color:     c.surface,
              elevation: 8,
              onSelected: (value) => setState(() => _selectedBranch = value),
              itemBuilder: (context) => _branchOptions
                  .map((branch) => PopupMenuItem<String>(
                value: branch,
                child: Row(
                  children: [
                    Icon(
                      branch == 'All Branches'
                          ? Icons.business_rounded
                          : Icons.location_on_rounded,
                      size:  16,
                      color: c.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      branch,
                      style: TextStyle(
                        fontSize:   13,
                        fontWeight: _selectedBranch == branch
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: c.body,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedBranch == branch)
                      Icon(Icons.check_rounded, size: 16, color: c.primary),
                  ],
                ),
              ))
                  .toList(),
              child: Container(
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
                        _selectedBranch,
                        style: TextStyle(
                          fontSize:   13,
                          fontWeight: FontWeight.w600,
                          color:      c.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: c.primary),
                  ],
                ),
              ),
            ),
          ),

          Text(
            'Dashboard',
            style: TextStyle(
              fontSize:   17,
              fontWeight: FontWeight.w700,
              color:      c.label,
            ),
          ),
          const Spacer(),

          // Notification bell
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

  Widget _buildPeriodSelector(BuildContext context, dynamic c, dynamic sp, dynamic card) {
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
              'Time Period',
              style: TextStyle(
                  fontSize:   13,
                  color:      c.muted,
                  fontWeight: FontWeight.w500),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriodLabel,
                icon:  Icon(Icons.keyboard_arrow_down_rounded,
                    color: c.body, size: 18),
                isDense: true,
                style:   TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      c.label),
                items: _periodOptions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedPeriodLabel = value);
                  context.read<AdminDashboardBloc>().add(
                    AdminDashboardPeriodChanged(period: _periodMap[value]!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, dynamic c, dynamic sp) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return Center(
              child: CircularProgressIndicator(color: c.primary));
        }

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
                    style: TextStyle(color: c.body, fontSize: 14),
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
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

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
                  LargeStatCardsGrid(data: state.data),
                  const SizedBox(height: 14),
                  SmallMetricCardsGrid(data: state.data),
                  const SizedBox(height: 14),
                  TextMetricRows(data: state.data),
                  const SizedBox(height: 20),
                  QuickActionsSection(
                    onAddMember: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                    onRecordPayment: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                    onAddPlan: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                    onSendAnnouncement: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                  ),
                  const SizedBox(height: 20),
                  RecentActivityFeed(
                      activities: state.data.recentActivity.activities),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}