/*
 * PURPOSE: Main screen for the Admin Dashboard
 *
 * This screen displays comprehensive gym management statistics including:
 * - Active members, pending renewals, check-ins, and PT sessions
 * - Revenue metrics, attendance data, and member analytics
 * - Quick action buttons for common admin tasks
 * - Recent activity feed showing latest member actions
 *
 * DESIGN FEATURES:
 * - Branch selector dropdown in AppBar for multi-location gyms
 * - Time period filter (Today/This Week/This Month/Custom)
 * - Responsive grid layouts for stat cards
 * - Pull-to-refresh functionality
 * - Loading, error, and success states via BLoC pattern
 *
 * ARCHITECTURE:
 * Uses BLoC pattern for state management with three main states:
 * - AdminDashboardLoading: Shows loading indicator
 * - AdminDashboardLoaded: Displays all dashboard widgets
 * - AdminDashboardError: Shows error message with retry option
 */

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
  // Period options for the dropdown filter
  // Maps user-friendly labels to API-compatible period values
  final List<String> _periodOptions = ['Today', 'This Week', 'This Month', 'Custom'];
  final Map<String, String> _periodMap = {
    'Today': 'today',
    'This Week': 'week',
    'This Month': 'month',
    'Custom': 'custom',
  };
  String _selectedPeriodLabel = 'Today';

  // Branch selection options for multi-location gym management
  // In production, this would be fetched from backend based on admin's access
  final List<String> _branchOptions = ['All Branches', 'Mumbai Central', 'Andheri West'];
  String _selectedBranch = 'Mumbai Central';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background for the entire screen
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPeriodSelector(), // Time period filter section
          Expanded(child: _buildBody()), // Main scrollable content area
        ],
      ),
    );
  }

  /*
   * APP BAR COMPONENT
   *
   * Builds the top navigation bar with:
   * - Menu icon (left): Opens side drawer for navigation
   * - Branch selector pill (center-left): Dropdown to switch between gym branches
   * - Location icon and branch name displayed in a blue pill-shaped container
   * - Notifications icon (right): Shows notification count badge
   */
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1, // Subtle shadow below AppBar
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          // TODO: Implement drawer navigation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          );
        },
      ),
      title: Row(
        children: [
          // Branch selector - pill-shaped button with dropdown
          PopupMenuButton<String>(
            offset: const Offset(0, 50), // Position dropdown below the button
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              setState(() => _selectedBranch = value);
              // TODO: Implement branch switching logic to filter dashboard data
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Switched to $value')),
              );
            },
            itemBuilder: (context) => _branchOptions.map((branch) {
              return PopupMenuItem<String>(
                value: branch,
                child: Row(
                  children: [
                    Icon(
                      branch == 'All Branches' ? Icons.business : Icons.location_on,
                      size: 18,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      branch,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _selectedBranch == branch ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedBranch == branch)
                      const Icon(Icons.check, size: 18, color: Color(0xFF3B82F6)),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF), // Light blue background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 6),
                  // Truncate long branch names with ellipsis
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      _selectedBranch,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black87),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Branch address subtitle
          const Text(
            '123 MG Road, Mumbai',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black45,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        // Notification icon with badge counter
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {
                // TODO: Navigate to notifications screen
              },
            ),
            // Red badge with notification count
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /*
   * TIME PERIOD SELECTOR
   *
   * White container with dropdown to filter dashboard data by time period
   * Options: Today, This Week, This Month, Custom
   *
   * When changed, triggers AdminDashboardPeriodChanged event which:
   * 1. Emits loading state
   * 2. Fetches new data from backend with selected period
   * 3. Updates all dashboard widgets with filtered data
   */
  Widget _buildPeriodSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Time Period',
            style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          // Dropdown button without underline for cleaner look
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriodLabel,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
              items: _periodOptions.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Row(
                    children: [
                      Text(
                        period,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      if (_selectedPeriodLabel == period)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.check, size: 16, color: Color(0xFF3B82F6)),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                // Update UI immediately
                setState(() => _selectedPeriodLabel = value);

                // Trigger BLoC event to fetch new data for selected period
                context.read<AdminDashboardBloc>().add(
                  AdminDashboardPeriodChanged(period: _periodMap[value]!),
                );

                // TODO: If "Custom" selected, show date range picker dialog
                if (value == 'Custom') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Custom date range picker coming soon')),
                  );
                }
              },
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  /*
   * MAIN BODY CONTENT
   *
   * Uses BlocBuilder to react to state changes from AdminDashboardBloc
   *
   * Three states handled:
   * 1. AdminDashboardLoading: Shows centered loading spinner
   * 2. AdminDashboardError: Shows error message with retry button
   * 3. AdminDashboardLoaded: Displays all dashboard widgets in scrollable column
   *
   * The loaded state includes:
   * - Pull-to-refresh functionality
   * - Large stat cards (Active Members, Pending Renewals, Check-ins, PT Sessions)
   * - Small metric cards (Attendance, Payments, Expiring Plans, Total Members)
   * - Text metric rows (Total Plans, Canceled, Churn Rate, Monthly Revenue)
   * - Quick Actions grid (Add Member, Record Payment, Add Plan, Send Announcement)
   * - Recent Activity feed showing latest member activities
   */
  Widget _buildBody() {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        // LOADING STATE
        // Display while fetching data from backend
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ERROR STATE
        // Shows error message with retry button to reload data
        if (state is AdminDashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<AdminDashboardBloc>().add(
                    AdminDashboardLoadRequested(period: state.period),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // LOADED STATE
        // Display all dashboard components with actual data
        if (state is AdminDashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              // Pull-to-refresh triggers silent data refresh
              context.read<AdminDashboardBloc>().add(
                AdminDashboardRefreshRequested(period: state.period),
              );
            },
            child: SingleChildScrollView(
              // AlwaysScrollableScrollPhysics enables pull-to-refresh even when content doesn't fill screen
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large stat cards: 2x2 grid showing key metrics
                  LargeStatCardsGrid(data: state.data),
                  const SizedBox(height: 16),

                  // Small metric cards: 2x2 grid with icons and badges
                  SmallMetricCardsGrid(data: state.data),
                  const SizedBox(height: 16),

                  // Text metric rows: Simple list of additional metrics
                  TextMetricRows(data: state.data),
                  const SizedBox(height: 16),

                  // Quick Actions: 2x2 grid of action buttons
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

                  // Recent Activity: List of latest member actions
                  RecentActivityFeed(activities: state.data.recentActivity.activities),
                  const SizedBox(height: 24), // Extra bottom padding for comfortable scrolling
                ],
              ),
            ),
          );
        }

        // Fallback for unexpected states
        return const SizedBox.shrink();
      },
    );
  }
}