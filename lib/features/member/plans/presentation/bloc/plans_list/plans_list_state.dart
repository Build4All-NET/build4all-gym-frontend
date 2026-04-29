import '../../../domain/entities/plan_entity.dart';

/// Base class for all plans list states.
///
/// The UI listens to these states and decides what to display.
abstract class PlansListState {}

/// Initial state before anything happens.
class PlansListInitial extends PlansListState {}

/// Loading state while the plans are being fetched.
class PlansListLoading extends PlansListState {}

/// Success state when plans are loaded.
///
/// An empty list is still valid.
/// It means the backend returned no available active plans.
class PlansListLoaded extends PlansListState {
  final List<PlanEntity> plans;

  PlansListLoaded({
    required this.plans,
  });
}

/// Error state when loading plans fails.
class PlansListError extends PlansListState {
  final String message;

  PlansListError({
    required this.message,
  });
}