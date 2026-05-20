part of 'plan_form_bloc.dart';

abstract class PlanFormEvent {}

/// Fired on form open — loads types + branches for dropdowns
class LoadFormDataEvent extends PlanFormEvent {}

/// User taps Save on Add form
class SubmitCreatePlanEvent extends PlanFormEvent {
  final CreatePlanRequestModel request;

  /// True when the planType was typed by the user (not picked from the dropdown).
  /// The BLoC calls POST /plans/types first to persist it to class_types.
  final bool isCustomType;

  SubmitCreatePlanEvent({
    required this.request,
    this.isCustomType = false,
  });
}

/// User taps Save on Edit form
class SubmitUpdatePlanEvent extends PlanFormEvent {
  final int planId;
  final UpdatePlanRequestModel request;
  SubmitUpdatePlanEvent({required this.planId, required this.request});
}
