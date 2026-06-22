part of 'employee_checkins_bloc.dart';

// =============================================================================
// FILE: employee_checkins_state.dart
// =============================================================================

abstract class EmployeeCheckinsState {
  const EmployeeCheckinsState();
}

class EmployeeCheckinsInitial extends EmployeeCheckinsState {
  const EmployeeCheckinsInitial();
}

class EmployeeCheckinsLoading extends EmployeeCheckinsState {
  const EmployeeCheckinsLoading();
}

class EmployeeCheckinsLoaded extends EmployeeCheckinsState {
  final List<EmployeeCheckinRowEntity> rows;
  const EmployeeCheckinsLoaded(this.rows);
}

class EmployeeCheckinsError extends EmployeeCheckinsState {
  final String message;
  const EmployeeCheckinsError(this.message);
}

/// Transient — caught by a BlocListener for a snackbar, never builds UI off it.
class EmployeeCheckinsActionSuccess extends EmployeeCheckinsState {
  final String message;
  const EmployeeCheckinsActionSuccess(this.message);
}

/// Transient — caught by a BlocListener for a snackbar, never builds UI off it.
class EmployeeCheckinsActionError extends EmployeeCheckinsState {
  final String message;
  const EmployeeCheckinsActionError(this.message);
}
