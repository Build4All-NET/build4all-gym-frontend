import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/employee_entity.dart';
import '../../../domain/usecases/admin_employees_usecases.dart';
import '../../../data/models/pay_employee_request_model.dart';

part 'admin_employees_event.dart';
part 'admin_employees_state.dart';

class AdminEmployeesBloc extends Bloc<AdminEmployeesEvent, AdminEmployeesState> {
  final GetEmployeesUseCase getEmployees;
  final GetEmployeeTypesUseCase getTypes;
  final DeleteEmployeeUseCase deleteEmployee;
  final PayEmployeeUseCase payEmployee;

  AdminEmployeesBloc({
    required this.getEmployees,
    required this.getTypes,
    required this.deleteEmployee,
    required this.payEmployee,
  }) : super(AdminEmployeesInitial()) {
    on<LoadAdminEmployeesEvent>(_onLoad);
    on<FilterByTypeEvent>(_onFilterByType);
    on<FilterByBranchEvent>(_onFilterByBranch);
    on<FilterByStatusEvent>(_onFilterByStatus);
    on<SearchEmployeesEvent>(_onSearch);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<PayEmployeeEvent>(_onPayEmployee);
    on<RefreshEmployeesEvent>(_onRefresh);
  }

  // ── Load (initial) ─────────────────────────────────────────────────────────
  Future<void> _onLoad(
    LoadAdminEmployeesEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    emit(AdminEmployeesLoading());
    try {
      final results = await Future.wait([
        getEmployees(),
        getTypes(),
      ]);
      emit(AdminEmployeesLoaded(
        employees: results[0] as List<EmployeeEntity>,
        types: results[1] as List<String>,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  // ── Filter by type ─────────────────────────────────────────────────────────
  // NOTE: built directly (not via copyWith) because copyWith's `??` fallback
  // can't tell "field not provided" from "explicitly clear to null" — that
  // would make clearing a filter back to "All" silently keep the old value.
  Future<void> _onFilterByType(
    FilterByTypeEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    try {
      final employees = await getEmployees(
        branchId: current.activeBranchFilter,
        employeeType: event.employeeType,
        status: current.activeStatusFilter,
        search: current.activeSearch,
      );
      emit(AdminEmployeesLoaded(
        employees: employees,
        types: current.types,
        activeTypeFilter: event.employeeType,
        activeBranchFilter: current.activeBranchFilter,
        activeStatusFilter: current.activeStatusFilter,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  // ── Filter by branch ───────────────────────────────────────────────────────
  Future<void> _onFilterByBranch(
    FilterByBranchEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    try {
      final employees = await getEmployees(
        branchId: event.branchId,
        employeeType: current.activeTypeFilter,
        status: current.activeStatusFilter,
        search: current.activeSearch,
      );
      emit(AdminEmployeesLoaded(
        employees: employees,
        types: current.types,
        activeTypeFilter: current.activeTypeFilter,
        activeBranchFilter: event.branchId,
        activeStatusFilter: current.activeStatusFilter,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  // ── Filter by status ───────────────────────────────────────────────────────
  Future<void> _onFilterByStatus(
    FilterByStatusEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    try {
      final employees = await getEmployees(
        branchId: current.activeBranchFilter,
        employeeType: current.activeTypeFilter,
        status: event.status,
        search: current.activeSearch,
      );
      emit(AdminEmployeesLoaded(
        employees: employees,
        types: current.types,
        activeTypeFilter: current.activeTypeFilter,
        activeBranchFilter: current.activeBranchFilter,
        activeStatusFilter: event.status,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Future<void> _onSearch(
    SearchEmployeesEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    try {
      final query = event.query.isEmpty ? null : event.query;
      final employees = await getEmployees(
        branchId: current.activeBranchFilter,
        employeeType: current.activeTypeFilter,
        status: current.activeStatusFilter,
        search: query,
      );
      emit(AdminEmployeesLoaded(
        employees: employees,
        types: current.types,
        activeTypeFilter: current.activeTypeFilter,
        activeBranchFilter: current.activeBranchFilter,
        activeStatusFilter: current.activeStatusFilter,
        activeSearch: query,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    emit(current.copyWith(
      isDeletingEmployee: true,
      deletingEmployeeId: event.employeeId,
    ));

    try {
      await deleteEmployee(event.employeeId);
      add(RefreshEmployeesEvent());
    } catch (e) {
      emit(current.copyWith(isDeletingEmployee: false, deletingEmployeeId: null));
      emit(AdminEmployeesError(message: _extractMessage(e)));
      emit(current.copyWith(isDeletingEmployee: false, deletingEmployeeId: null));
    }
  }

  // ── Pay ────────────────────────────────────────────────────────────────────
  Future<void> _onPayEmployee(
    PayEmployeeEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    if (current is! AdminEmployeesLoaded) return;

    emit(current.copyWith(
      isPayingEmployee: true,
      payingEmployeeId: event.employeeId,
    ));

    try {
      await payEmployee(event.employeeId, event.request);
      add(RefreshEmployeesEvent());
    } catch (e) {
      emit(current.copyWith(isPayingEmployee: false, payingEmployeeId: null));
      emit(AdminEmployeesError(message: _extractMessage(e)));
      emit(current.copyWith(isPayingEmployee: false, payingEmployeeId: null));
    }
  }

  // ── Refresh (after create/update/pay) ─────────────────────────────────────
  Future<void> _onRefresh(
    RefreshEmployeesEvent event,
    Emitter<AdminEmployeesState> emit,
  ) async {
    final current = state;
    final currentType = current is AdminEmployeesLoaded ? current.activeTypeFilter : null;
    final currentBranch = current is AdminEmployeesLoaded ? current.activeBranchFilter : null;
    final currentStatus = current is AdminEmployeesLoaded ? current.activeStatusFilter : null;
    final currentSearch = current is AdminEmployeesLoaded ? current.activeSearch : null;

    try {
      final results = await Future.wait([
        getEmployees(
          branchId: currentBranch,
          employeeType: currentType,
          status: currentStatus,
          search: currentSearch,
        ),
        getTypes(),
      ]);
      emit(AdminEmployeesLoaded(
        employees: results[0] as List<EmployeeEntity>,
        types: results[1] as List<String>,
        activeTypeFilter: currentType,
        activeBranchFilter: currentBranch,
        activeStatusFilter: currentStatus,
        activeSearch: currentSearch,
      ));
    } catch (e) {
      emit(AdminEmployeesError(message: _extractMessage(e)));
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.replaceFirst('Exception: ', '');
    return msg;
  }
}
