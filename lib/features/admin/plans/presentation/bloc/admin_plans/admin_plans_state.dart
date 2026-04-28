part of 'admin_plans_bloc.dart';

abstract class AdminPlansState {}

class AdminPlansInitial extends AdminPlansState {}

class AdminPlansLoading extends AdminPlansState {}

class AdminPlansLoaded extends AdminPlansState {
  final AdminPlanStatsEntity stats;
  final List<AdminPlanListItemEntity> plans;
  final List<String> types; // for the filter dropdown
  final String? activeTypeFilter;
  final String? activeSearch;
  final bool isDeletingPlan;
  final int? deletingPlanId; // shows spinner on specific card

  AdminPlansLoaded({
    required this.stats,
    required this.plans,
    required this.types,
    this.activeTypeFilter,
    this.activeSearch,
    this.isDeletingPlan = false,
    this.deletingPlanId,
  });

  // copyWith — keeps unchanged fields when partially updating state
  AdminPlansLoaded copyWith({
    AdminPlanStatsEntity? stats,
    List<AdminPlanListItemEntity>? plans,
    List<String>? types,
    String? activeTypeFilter,
    String? activeSearch,
    bool? isDeletingPlan,
    int? deletingPlanId,
  }) {
    return AdminPlansLoaded(
      stats: stats ?? this.stats,
      plans: plans ?? this.plans,
      types: types ?? this.types,
      activeTypeFilter: activeTypeFilter ?? this.activeTypeFilter,
      activeSearch: activeSearch ?? this.activeSearch,
      isDeletingPlan: isDeletingPlan ?? this.isDeletingPlan,
      deletingPlanId: deletingPlanId ?? this.deletingPlanId,
    );
  }
}

class AdminPlansError extends AdminPlansState {
  final String message;
  AdminPlansError({required this.message});
}