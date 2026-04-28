import '../../../domain/entities/plan_entity.dart';

abstract class PlansListState {}

class PlansListInitial extends PlansListState {}

class PlansListLoading extends PlansListState {}

class PlansListLoaded extends PlansListState {
  final List<PlanEntity> plans;

  PlansListLoaded({required this.plans});
}

class PlansListError extends PlansListState {
  final String message;

  PlansListError({required this.message});
}