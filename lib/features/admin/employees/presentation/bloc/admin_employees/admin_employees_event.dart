part of 'admin_employees_bloc.dart';

abstract class AdminEmployeesEvent {}

/// Fired on screen init — loads employees + types in parallel.
class LoadAdminEmployeesEvent extends AdminEmployeesEvent {}

/// User picks a type from the filter dropdown (null = "All Types").
class FilterByTypeEvent extends AdminEmployeesEvent {
  final String? employeeType;
  FilterByTypeEvent({this.employeeType});
}

/// User picks a branch from the filter dropdown (null = "All Branches").
class FilterByBranchEvent extends AdminEmployeesEvent {
  final int? branchId;
  FilterByBranchEvent({this.branchId});
}

/// User toggles Active/Inactive/All.
class FilterByStatusEvent extends AdminEmployeesEvent {
  final String? status;
  FilterByStatusEvent({this.status});
}

/// User types in the search field (debounced in screen).
class SearchEmployeesEvent extends AdminEmployeesEvent {
  final String query;
  SearchEmployeesEvent({required this.query});
}

/// User confirms deleting (soft-removing) an employee.
class DeleteEmployeeEvent extends AdminEmployeesEvent {
  final int employeeId;
  DeleteEmployeeEvent({required this.employeeId});
}

/// User confirms a "Pay" action from PayEmployeeDialog.
class PayEmployeeEvent extends AdminEmployeesEvent {
  final int employeeId;
  final PayEmployeeRequestModel request;
  PayEmployeeEvent({required this.employeeId, required this.request});
}

/// Fired after successful create/update from EmployeeFormBottomSheet — reloads list.
class RefreshEmployeesEvent extends AdminEmployeesEvent {}
