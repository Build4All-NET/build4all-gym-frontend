/*
 * PURPOSE: State definitions for Admin Dashboard BLoC
 *
 * States represent the current condition of the dashboard screen
 * UI rebuilds whenever state changes (via BlocBuilder)
 *
 * ARCHITECTURE NOTES:
 * - States use Equatable for comparison (prevents unnecessary rebuilds)
 * - Each state is immutable (const constructors where possible)
 * - Loaded and Error states carry period info to support retry/refresh
 *
 * STATE TYPES:
 * 1. AdminDashboardInitial - Before any data is requested
 * 2. AdminDashboardLoading - Fetching data from backend
 * 3. AdminDashboardLoaded - Data successfully retrieved
 * 4. AdminDashboardError - Failed to retrieve data
 *
 * STATE FLOW:
 * Initial → Loading → Loaded (success path)
 * Initial → Loading → Error (failure path)
 * Loaded → Loading → Loaded (period change)
 * Loaded → Loaded (silent refresh)
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

/*
 * BASE STATE CLASS
 *
 * All admin dashboard states extend this base class
 * Equatable allows comparison by value instead of reference
 *
 * Why Equatable?
 * - BlocBuilder can detect when state actually changed
 * - Prevents unnecessary widget rebuilds
 * - Makes testing easier (compare states by content)
 * - Provides useful toString() for debugging
 */
abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object?> get props => []; // Override in subclasses
}

/*
 * STATE: Initial
 *
 * When this state is active:
 * - Screen has just been created
 * - No data has been requested yet
 * - Usually very brief - immediately transitions to Loading
 *
 * UI Behavior:
 * - Could show a blank screen
 * - Or show a placeholder skeleton
 * - Typically BlocBuilder shows nothing (SizedBox.shrink())
 *
 * Next State:
 * - Loading (when AdminDashboardLoadRequested event fires)
 */
class AdminDashboardInitial extends AdminDashboardState {}

/*
 * STATE: Loading
 *
 * When this state is active:
 * - Data is being fetched from backend
 * - User is waiting for response
 *
 * UI Behavior:
 * - Show centered CircularProgressIndicator
 * - Could show shimmer loading skeletons for better UX
 *
 * Triggered by:
 * - AdminDashboardLoadRequested event (initial load)
 * - AdminDashboardPeriodChanged event (filter change)
 * - NOT by AdminDashboardRefreshRequested (silent refresh)
 *
 * Next State:
 * - Loaded (on successful API response)
 * - Error (on failed API response)
 *
 * Design Note:
 * This state is intentionally NOT emitted during refresh
 * to prevent flicker while old data remains visible
 */
class AdminDashboardLoading extends AdminDashboardState {}

/*
 * STATE: Loaded
 *
 * When this state is active:
 * - Data successfully fetched from backend
 * - All dashboard metrics are available
 * - User can interact with the dashboard
 *
 * UI Behavior:
 * - Display all dashboard widgets with actual data
 * - Enable pull-to-refresh
 * - Show all stat cards, charts, and activity feed
 *
 * Properties:
 * - data: AdminDashboardSummary containing all dashboard metrics
 *   Includes: members, checkins, revenue, plans, recent activity
 * - period: Current time period filter (for refresh/retry operations)
 *
 * Next State:
 * - Loading (user changes period filter)
 * - Loaded (silent refresh with new data)
 * - Error (refresh fails - though typically stays on current state)
 *
 * Design Note:
 * Period is stored in state so that:
 * - Pull-to-refresh knows what period to reload
 * - Error state can show retry button with correct period
 * - UI can display current filter selection
 */
class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardSummary data;
  final String period;

  // Currently selected Payments-tab segment (This Month / Last Month /
  // Last 3 Months / Custom) — kept here (not on the entity) so pull-to-refresh
  // and retry reuse the user's selection instead of resetting to default.
  final String revenuePeriod;
  final String? revenueStartDate;
  final String? revenueEndDate;

  const AdminDashboardLoaded({
    required this.data,
    required this.period,
    this.revenuePeriod = 'this_month',
    this.revenueStartDate,
    this.revenueEndDate,
  });

  @override
  List<Object?> get props =>
      [data, period, revenuePeriod, revenueStartDate, revenueEndDate];
}

/*
 * STATE: Error
 *
 * When this state is active:
 * - Failed to fetch data from backend
 * - Could be: network error, server error, timeout, auth error
 *
 * UI Behavior:
 * - Show error icon and error message
 * - Display retry button to attempt reload
 * - User can tap retry to trigger AdminDashboardLoadRequested
 *
 * Properties:
 * - message: Human-readable error description from backend/repository
 *   Examples: "No internet connection", "Server error", "Session expired"
 * - period: Period that failed to load (for retry operation)
 *
 * Next State:
 * - Loading (user taps retry button)
 *
 * Design Note:
 * Error state preserves period so retry button can:
 * - Reload the same period user was trying to view
 * - Maintain user's filter selection context
 *
 * Error Message Sources:
 * 1. Repository failure message (from API error response)
 * 2. Network error message (from Dio exception)
 * 3. Fallback: "Unknown error occurred"
 */
class AdminDashboardError extends AdminDashboardState {
  final String message;
  final String period;
  final String revenuePeriod;
  final String? revenueStartDate;
  final String? revenueEndDate;

  const AdminDashboardError({
    required this.message,
    required this.period,
    this.revenuePeriod = 'this_month',
    this.revenueStartDate,
    this.revenueEndDate,
  });

  @override
  List<Object?> get props =>
      [message, period, revenuePeriod, revenueStartDate, revenueEndDate];
}