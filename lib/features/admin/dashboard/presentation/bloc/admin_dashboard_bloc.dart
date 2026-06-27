/*
 * PURPOSE: Business Logic Component (BLoC) for Admin Dashboard
 *
 * Manages all state and business logic for the admin dashboard screen
 *
 * RESPONSIBILITIES:
 * 1. Fetch dashboard data from backend via use case
 * 2. Handle time period filtering (today, week, month)
 * 3. Manage loading, success, and error states
 * 4. Support pull-to-refresh functionality
 *
 * EVENTS HANDLED:
 * - AdminDashboardLoadRequested: Initial data load
 * - AdminDashboardRefreshRequested: Silent refresh (pull-to-refresh)
 * - AdminDashboardPeriodChanged: User changes time period filter
 *
 * STATES EMITTED:
 * - AdminDashboardInitial: Before any data is loaded
 * - AdminDashboardLoading: While fetching data from backend
 * - AdminDashboardLoaded: Data successfully loaded
 * - AdminDashboardError: Failed to load data
 *
 * ARCHITECTURE PATTERN:
 * This follows Clean Architecture principles:
 * - BLoC depends on use case (Domain layer)
 * - Use case depends on repository (Data layer)
 * - BLoC is isolated from data sources and API details
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_dashboard_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  // Use case dependency injected via constructor
  // This use case encapsulates the business logic for fetching dashboard data
  final GetAdminDashboardUseCase getAdminDashboardUseCase;

  AdminDashboardBloc({required this.getAdminDashboardUseCase})
      : super(AdminDashboardInitial()) {
    // Register event handlers
    // Each event type has its own handler method
    on<AdminDashboardLoadRequested>(_onLoadRequested);
    on<AdminDashboardRefreshRequested>(_onRefreshRequested);
    on<AdminDashboardPeriodChanged>(_onPeriodChanged);
    on<AdminDashboardRevenuePeriodChanged>(_onRevenuePeriodChanged);
  }

  /*
   * HANDLER: Initial Load Request
   *
   * Triggered when:
   * - Screen first loads
   * - User taps retry button after error
   *
   * Flow:
   * 1. Emit loading state (shows spinner)
   * 2. Call use case to fetch data from backend
   * 3. Emit loaded state with data OR error state with message
   *
   * The period parameter determines what data range to fetch:
   * - 'today': Current day statistics
   * - 'week': Last 7 days
   * - 'month': Last 30 days
   */
  Future<void> _onLoadRequested(
      AdminDashboardLoadRequested event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());

    final result = await getAdminDashboardUseCase(
      period: event.period,
      revenuePeriod: event.revenuePeriod,
      revenueStartDate: event.revenueStartDate,
      revenueEndDate: event.revenueEndDate,
      branchId: event.branchId,
    );

    if (result.data != null) {
      emit(AdminDashboardLoaded(
        data: result.data!,
        period: event.period,
        revenuePeriod: event.revenuePeriod,
        revenueStartDate: event.revenueStartDate,
        revenueEndDate: event.revenueEndDate,
        branchId: event.branchId,
      ));
    } else {
      emit(AdminDashboardError(
        message: result.failure?.message ?? 'Unknown error occurred',
        period: event.period,
        revenuePeriod: event.revenuePeriod,
        revenueStartDate: event.revenueStartDate,
        revenueEndDate: event.revenueEndDate,
        branchId: event.branchId,
      ));
    }
  }

  /*
   * HANDLER: Refresh Request
   *
   * Triggered when:
   * - User pulls down to refresh
   *
   * Flow:
   * 1. NO loading state emitted (prevents flicker during refresh)
   * 2. Call use case to fetch fresh data
   * 3. If successful, emit loaded state with new data
   * 4. If failed, stay on current state silently (don't show error)
   *
   * This creates a smooth refresh experience:
   * - Old data remains visible while fetching
   * - RefreshIndicator handles the loading animation
   * - Errors don't interrupt user experience
   */
  Future<void> _onRefreshRequested(
      AdminDashboardRefreshRequested event,
      Emitter<AdminDashboardState> emit,
      ) async {
    final result = await getAdminDashboardUseCase(
      period: event.period,
      revenuePeriod: event.revenuePeriod,
      revenueStartDate: event.revenueStartDate,
      revenueEndDate: event.revenueEndDate,
      branchId: event.branchId,
    );

    if (result.data != null) {
      emit(AdminDashboardLoaded(
        data: result.data!,
        period: event.period,
        revenuePeriod: event.revenuePeriod,
        revenueStartDate: event.revenueStartDate,
        revenueEndDate: event.revenueEndDate,
        branchId: event.branchId,
      ));
    }
  }

  /*
   * HANDLER: Period Changed
   *
   * Triggered when:
   * - User selects different period from dropdown (Today/This Week/This Month)
   *
   * Flow:
   * 1. Emit loading state (user expects to see loading when changing period)
   * 2. Call use case with new period parameter
   * 3. Emit loaded state with filtered data OR error state
   *
   * This is similar to initial load but triggered by user action
   * Loading state is appropriate here because:
   * - User explicitly changed filter
   * - They expect data to change
   * - Brief loading indicator confirms their action was registered
   */
  Future<void> _onPeriodChanged(
      AdminDashboardPeriodChanged event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());

    final branchId = state is AdminDashboardLoaded
        ? (state as AdminDashboardLoaded).branchId
        : null;

    final result = await getAdminDashboardUseCase(
      period: event.period,
      branchId: branchId,
    );

    if (result.data != null) {
      emit(AdminDashboardLoaded(
        data: result.data!,
        period: event.period,
        branchId: branchId,
      ));
    } else {
      emit(AdminDashboardError(
        message: result.failure?.message ?? 'Failed to load data for selected period',
        period: event.period,
        branchId: branchId,
      ));
    }
  }

  /*
   * HANDLER: Revenue Period Changed
   *
   * Triggered when:
   * - User taps a segment on the Payments tab's period control
   *   (This Month / Last Month / Last 3 Months / Custom)
   *
   * Same flow as _onPeriodChanged, but only the revenue window changes —
   * the dashboard-wide `period` (used by checkins) is carried through as-is.
   */
  Future<void> _onRevenuePeriodChanged(
      AdminDashboardRevenuePeriodChanged event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());

    final result = await getAdminDashboardUseCase(
      period: event.period,
      revenuePeriod: event.revenuePeriod,
      revenueStartDate: event.revenueStartDate,
      revenueEndDate: event.revenueEndDate,
      branchId: event.branchId,
    );

    if (result.data != null) {
      emit(AdminDashboardLoaded(
        data: result.data!,
        period: event.period,
        revenuePeriod: event.revenuePeriod,
        revenueStartDate: event.revenueStartDate,
        revenueEndDate: event.revenueEndDate,
        branchId: event.branchId,
      ));
    } else {
      emit(AdminDashboardError(
        message: result.failure?.message ?? 'Failed to load data for selected period',
        period: event.period,
        revenuePeriod: event.revenuePeriod,
        revenueStartDate: event.revenueStartDate,
        revenueEndDate: event.revenueEndDate,
        branchId: event.branchId,
      ));
    }
  }
}