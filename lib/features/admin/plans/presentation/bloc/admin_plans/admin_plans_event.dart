part of 'admin_plans_bloc.dart';

abstract class AdminPlansEvent {}

/// Fired on screen init — loads stats + plans + types in parallel
class LoadAdminPlansEvent extends AdminPlansEvent {}

/// User picks a type from the filter dropdown (null = "All Types")
class FilterByTypeEvent extends AdminPlansEvent {
  final String? type;
  FilterByTypeEvent({this.type});
}

/// User types in the search field (debounced in screen)
class SearchPlansEvent extends AdminPlansEvent {
  final String query;
  SearchPlansEvent({required this.query});
}

/// User confirms deleting a plan
class DeletePlanEvent extends AdminPlansEvent {
  final int planId;
  DeletePlanEvent({required this.planId});
}

/// Fired after successful create/update from PlanFormBloc — reloads list
class RefreshPlansEvent extends AdminPlansEvent {}