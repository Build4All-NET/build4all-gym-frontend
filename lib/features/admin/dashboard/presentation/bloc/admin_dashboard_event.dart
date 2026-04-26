/*
 * PURPOSE: Event definitions for Admin Dashboard BLoC
 *
 * Events represent user actions or system triggers that cause state changes
 * Each event type triggers a specific handler in AdminDashboardBloc
 *
 * ARCHITECTURE NOTES:
 * - Events use Equatable for value comparison (helps with testing and debugging)
 * - Each event carries the minimum data needed for its operation
 * - Events are immutable (const constructors)
 * - Period field uses string format: 'today', 'week', 'month', 'custom'
 *
 * EVENT TYPES:
 * 1. AdminDashboardLoadRequested - Initial data load when screen opens
 * 2. AdminDashboardRefreshRequested - Pull-to-refresh action
 * 3. AdminDashboardPeriodChanged - User changes time period filter
 */

import 'package:equatable/equatable.dart';

/*
 * BASE EVENT CLASS
 *
 * All admin dashboard events extend this base class
 * Equatable enables comparison of events by their properties (not by reference)
 *
 * Why Equatable?
 * - BLoC can detect duplicate events and avoid redundant processing
 * - Makes testing easier (can compare expected vs actual events)
 * - Improves debugging by providing meaningful toString() output
 */
abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object?> get props => []; // Override in subclasses to include fields
}

/*
 * EVENT: Load Requested
 *
 * Triggered when:
 * - Screen initializes (via initState or provider initialization)
 * - User taps retry button after error
 *
 * Purpose:
 * Fetch fresh dashboard data from backend
 *
 * Parameters:
 * - period: Time range filter ('today', 'week', 'month')
 *   Default is 'today' to show most recent data
 *
 * Expected BLoC Response:
 * 1. Emit AdminDashboardLoading
 * 2. Call GetAdminDashboardUseCase
 * 3. Emit AdminDashboardLoaded or AdminDashboardError
 */
class AdminDashboardLoadRequested extends AdminDashboardEvent {
  final String period;

  const AdminDashboardLoadRequested({this.period = 'today'});

  @override
  List<Object?> get props => [period];
}

/*
 * EVENT: Refresh Requested
 *
 * Triggered when:
 * - User performs pull-to-refresh gesture
 *
 * Purpose:
 * Silently update dashboard data without showing loading spinner
 *
 * Parameters:
 * - period: Current time period filter (preserve user's selection)
 *   Default is 'today'
 *
 * Expected BLoC Response:
 * 1. NO loading state (to prevent flicker)
 * 2. Call GetAdminDashboardUseCase
 * 3. Emit AdminDashboardLoaded on success
 * 4. Stay on current state on failure (silent failure)
 *
 * Design Decision:
 * Refresh should be subtle and non-intrusive
 * - RefreshIndicator handles loading animation
 * - Don't show errors (user can retry with another pull)
 * - Keep old data visible during refresh
 */
class AdminDashboardRefreshRequested extends AdminDashboardEvent {
  final String period;

  const AdminDashboardRefreshRequested({this.period = 'today'});

  @override
  List<Object?> get props => [period];
}

/*
 * EVENT: Period Changed
 *
 * Triggered when:
 * - User selects different option from period dropdown
 *   (Today → This Week, This Week → This Month, etc.)
 *
 * Purpose:
 * Reload dashboard with data filtered by new time period
 *
 * Parameters:
 * - period: New time period selected by user
 *   Must be one of: 'today', 'week', 'month', 'custom'
 *
 * Expected BLoC Response:
 * 1. Emit AdminDashboardLoading (user expects feedback)
 * 2. Call GetAdminDashboardUseCase with new period
 * 3. Emit AdminDashboardLoaded with filtered data
 * 4. Emit AdminDashboardError if fetch fails
 *
 * Design Decision:
 * Show loading state because:
 * - User explicitly triggered filter change
 * - Data will visibly change (numbers will update)
 * - Brief loading confirms action was registered
 */
class AdminDashboardPeriodChanged extends AdminDashboardEvent {
  final String period; // Required field - no default value

  const AdminDashboardPeriodChanged({required this.period});

  @override
  List<Object?> get props => [period];
}