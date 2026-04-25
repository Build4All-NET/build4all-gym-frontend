import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard_event.dart';
import '../bloc/admin_dashboard_state.dart';
import '../widgets/large_stat_cards_grid.dart';
import '../widgets/small_metric_cards_grid.dart';
import '../widgets/text_metric_rows.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_activity_feed.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<String> _periodOptions = ['Today', 'This Week', 'This Month'];
  final Map<String, String> _periodMap = {
    'Today': 'today',
    'This Week': 'week',
    'This Month': 'month',
  };
  String _selectedPeriodLabel = 'Today';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPeriodSelector(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          // TODO: open side drawer
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          );
        },
      ),
      title: Row(
        children: [
          // Branch selector pill
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon')),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_on, size: 14, color: Color(0xFF3B82F6)),
                  SizedBox(width: 4),
                  Text('Mumbai C...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Time Period', style: TextStyle(fontSize: 14, color: Colors.black54)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriodLabel,
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
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminDashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<AdminDashboardBloc>().add(
                    AdminDashboardLoadRequested(period: state.period),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is AdminDashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminDashboardBloc>().add(
                AdminDashboardRefreshRequested(period: state.period),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LargeStatCardsGrid(data: state.data),
                  const SizedBox(height: 16),
                  SmallMetricCardsGrid(data: state.data),
                  const SizedBox(height: 16),
                  TextMetricRows(data: state.data),
                  const SizedBox(height: 16),
                  QuickActionsSection(
                    onAddMember: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Coming soon')),
                    ),
                    onRecordPayment: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Coming soon')),
                    ),
                    onAddPlan: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Coming soon')),
                    ),
                    onSendAnnouncement: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Coming soon')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecentActivityFeed(activities: state.data.recentActivity.activities),
                  const SizedBox(height: 24),
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