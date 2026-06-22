part of 'admin_employees_bloc.dart';

abstract class AdminEmployeesState {}

class AdminEmployeesInitial extends AdminEmployeesState {}

class AdminEmployeesLoading extends AdminEmployeesState {}

class AdminEmployeesLoaded extends AdminEmployeesState {
  final List<EmployeeEntity> employees;
  final List<String> types; // built-in + any custom type the owner created
  final String? activeTypeFilter;
  final int? activeBranchFilter;
  final String? activeStatusFilter;
  final String? activeSearch;
  final bool isDeletingEmployee;
  final int? deletingEmployeeId; // shows spinner on specific card
  final bool isPayingEmployee;
  final int? payingEmployeeId; // shows spinner on specific card

  AdminEmployeesLoaded({
    required this.employees,
    required this.types,
    this.activeTypeFilter,
    this.activeBranchFilter,
    this.activeStatusFilter,
    this.activeSearch,
    this.isDeletingEmployee = false,
    this.deletingEmployeeId,
    this.isPayingEmployee = false,
    this.payingEmployeeId,
  });

  AdminEmployeesLoaded copyWith({
    List<EmployeeEntity>? employees,
    List<String>? types,
    String? activeTypeFilter,
    int? activeBranchFilter,
    String? activeStatusFilter,
    String? activeSearch,
    bool? isDeletingEmployee,
    int? deletingEmployeeId,
    bool? isPayingEmployee,
    int? payingEmployeeId,
  }) {
    return AdminEmployeesLoaded(
      employees: employees ?? this.employees,
      types: types ?? this.types,
      activeTypeFilter: activeTypeFilter ?? this.activeTypeFilter,
      activeBranchFilter: activeBranchFilter ?? this.activeBranchFilter,
      activeStatusFilter: activeStatusFilter ?? this.activeStatusFilter,
      activeSearch: activeSearch ?? this.activeSearch,
      isDeletingEmployee: isDeletingEmployee ?? this.isDeletingEmployee,
      deletingEmployeeId: deletingEmployeeId ?? this.deletingEmployeeId,
      isPayingEmployee: isPayingEmployee ?? this.isPayingEmployee,
      payingEmployeeId: payingEmployeeId ?? this.payingEmployeeId,
    );
  }
}

class AdminEmployeesError extends AdminEmployeesState {
  final String message;
  AdminEmployeesError({required this.message});
}
