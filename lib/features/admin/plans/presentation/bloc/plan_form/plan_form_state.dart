part of 'plan_form_bloc.dart';

abstract class PlanFormState {}

class PlanFormInitial extends PlanFormState {}

/// Loading types + branches for dropdowns
class PlanFormDataLoading extends PlanFormState {}

/// Dropdowns ready — form can be filled
class PlanFormDataLoaded extends PlanFormState {
  final List<String> types;
  final List<AdminBranchOptionEntity> branches;
  PlanFormDataLoaded({required this.types, required this.branches});
}

/// Save button spinner — keep types + branches so form doesn't disappear
class PlanFormSubmitting extends PlanFormState {
  final List<String> types;
  final List<AdminBranchOptionEntity> branches;
  PlanFormSubmitting({required this.types, required this.branches});
}

/// Create or update succeeded
class PlanFormSuccess extends PlanFormState {
  final String message;
  PlanFormSuccess({required this.message});
}

/// API or validation error — keep form data so user can fix and retry
class PlanFormError extends PlanFormState {
  final String message;
  final List<String> types;
  final List<AdminBranchOptionEntity> branches;
  PlanFormError({
    required this.message,
    required this.types,
    required this.branches,
  });
}