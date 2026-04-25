import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_dashboard_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetAdminDashboardUseCase getAdminDashboardUseCase;

  AdminDashboardBloc({required this.getAdminDashboardUseCase})
      : super(AdminDashboardInitial()) {
    on<AdminDashboardLoadRequested>(_onLoadRequested);
    on<AdminDashboardRefreshRequested>(_onRefreshRequested);
    on<AdminDashboardPeriodChanged>(_onPeriodChanged);
  }

  Future<void> _onLoadRequested(
      AdminDashboardLoadRequested event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    final result = await getAdminDashboardUseCase(period: event.period);
    if (result.data != null) {
      emit(AdminDashboardLoaded(data: result.data!, period: event.period));
    } else {
      emit(AdminDashboardError(
        message: result.failure?.message ?? 'Unknown error',
        period: event.period,
      ));
    }
  }

  Future<void> _onRefreshRequested(
      AdminDashboardRefreshRequested event,
      Emitter<AdminDashboardState> emit,
      ) async {
    // No loading emit — silent refresh to prevent flicker
    final result = await getAdminDashboardUseCase(period: event.period);
    if (result.data != null) {
      emit(AdminDashboardLoaded(data: result.data!, period: event.period));
    }
    // On failure, stay on current state silently
  }

  Future<void> _onPeriodChanged(
      AdminDashboardPeriodChanged event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    final result = await getAdminDashboardUseCase(period: event.period);
    if (result.data != null) {
      emit(AdminDashboardLoaded(data: result.data!, period: event.period));
    } else {
      emit(AdminDashboardError(
        message: result.failure?.message ?? 'Unknown error',
        period: event.period,
      ));
    }
  }
}