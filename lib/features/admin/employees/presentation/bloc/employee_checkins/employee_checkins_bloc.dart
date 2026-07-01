// =============================================================================
// FILE: employee_checkins_bloc.dart
// PATH: lib/features/admin/employees/presentation/bloc/employee_checkins/employee_checkins_bloc.dart
//
// Wires events -> use cases -> states for the Employee Check-Ins screen.
// Mirrors lib/features/admin/checkins/presentation/bloc/checkins_bloc.dart
// (member check-ins) but tracks employee/payroll attendance instead.
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/employee_checkin_row_entity.dart';
import '../../../domain/usecases/employee_checkins_usecases.dart';

part 'employee_checkins_event.dart';
part 'employee_checkins_state.dart';

class EmployeeCheckinsBloc extends Bloc<EmployeeCheckinsEvent, EmployeeCheckinsState> {
  final GetTodayEmployeeCheckinsUseCase getTodayCheckins;
  final GetBranchCheckinQrUseCase getBranchQr;
  final ScanEmployeeCheckinUseCase scanCheckin;
  final ManualCheckinUseCase manualCheckin;
  final ManualCheckoutUseCase manualCheckout;

  /// The branch this screen is currently showing — seeded from the router and
  /// corrected once the admin's home branch resolves, same pattern as
  /// CheckinsBloc.branchId.
  int branchId;

  EmployeeCheckinsBloc({
    required this.getTodayCheckins,
    required this.getBranchQr,
    required this.scanCheckin,
    required this.manualCheckin,
    required this.manualCheckout,
    required this.branchId,
  }) : super(const EmployeeCheckinsInitial()) {
    on<LoadTodayEmployeeCheckins>(_onLoad);
    on<ScanEmployeeCheckinEvent>(_onScan);
    on<ManualCheckinEvent>(_onManualCheckin);
    on<ManualCheckoutEvent>(_onManualCheckout);
    on<ChangeEmployeeCheckinsBranch>(_onChangeBranch);
  }

  // ── LoadTodayEmployeeCheckins ──────────────────────────────────────────────
  Future<void> _onLoad(
      LoadTodayEmployeeCheckins event, Emitter<EmployeeCheckinsState> emit) async {
    if (!event.silent) emit(const EmployeeCheckinsLoading());
    try {
      final rows = await getTodayCheckins(branchId: branchId);
      emit(EmployeeCheckinsLoaded(rows));
    } catch (e) {
      if (!event.silent) emit(EmployeeCheckinsError(e.toString()));
    }
  }

  // ── ScanEmployeeCheckinEvent ────────────────────────────────────────────────
  Future<void> _onScan(
      ScanEmployeeCheckinEvent event, Emitter<EmployeeCheckinsState> emit) async {
    try {
      final result = await scanCheckin(token: event.token);
      final verb = result.action == 'CHECKED_IN' ? 'checked in' : 'checked out';
      emit(EmployeeCheckinsActionSuccess('${result.employeeName} $verb.'));
      add(const LoadTodayEmployeeCheckins());
    } catch (e) {
      emit(EmployeeCheckinsActionError(e.toString()));
    }
  }

  // ── ManualCheckinEvent ──────────────────────────────────────────────────────
  Future<void> _onManualCheckin(
      ManualCheckinEvent event, Emitter<EmployeeCheckinsState> emit) async {
    try {
      final result = await manualCheckin(employeeId: event.employeeId, branchId: branchId);
      emit(EmployeeCheckinsActionSuccess('${result.employeeName} checked in.'));
      add(const LoadTodayEmployeeCheckins());
    } catch (e) {
      emit(EmployeeCheckinsActionError(e.toString()));
    }
  }

  // ── ManualCheckoutEvent ─────────────────────────────────────────────────────
  Future<void> _onManualCheckout(
      ManualCheckoutEvent event, Emitter<EmployeeCheckinsState> emit) async {
    try {
      final result = await manualCheckout(employeeCheckinId: event.employeeCheckinId);
      emit(EmployeeCheckinsActionSuccess('${result.employeeName} checked out.'));
      add(const LoadTodayEmployeeCheckins());
    } catch (e) {
      emit(EmployeeCheckinsActionError(e.toString()));
    }
  }

  // ── ChangeEmployeeCheckinsBranch ────────────────────────────────────────────
  Future<void> _onChangeBranch(
      ChangeEmployeeCheckinsBranch event, Emitter<EmployeeCheckinsState> emit) async {
    if (event.branchId == branchId) return;
    branchId = event.branchId;
    add(const LoadTodayEmployeeCheckins());
  }
}
