import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/admin_plan_stats_entity.dart';
import '../../../domain/entities/admin_plan_list_item_entity.dart';
import '../../../domain/usecases/admin_plans_usecases.dart';

part 'admin_plans_event.dart';
part 'admin_plans_state.dart';

class AdminPlansBloc extends Bloc<AdminPlansEvent, AdminPlansState> {
  final GetAdminPlanStatsUseCase getStats;
  final GetAdminPlansUseCase getPlans;
  final GetPlanTypesUseCase getPlanTypes;
  final DeletePlanUseCase deletePlan;

  AdminPlansBloc({
    required this.getStats,
    required this.getPlans,
    required this.getPlanTypes,
    required this.deletePlan,
  }) : super(AdminPlansInitial()) {
    on<LoadAdminPlansEvent>(_onLoad);
    on<FilterByTypeEvent>(_onFilterByType);
    on<SearchPlansEvent>(_onSearch);
    on<DeletePlanEvent>(_onDeletePlan);
    on<RefreshPlansEvent>(_onRefresh);
  }

  // ── Load (initial) ─────────────────────────────────────────────────────────
  Future<void> _onLoad(
      LoadAdminPlansEvent event,
      Emitter<AdminPlansState> emit,
      ) async {
    emit(AdminPlansLoading());
    try {
      // Load stats + plans + types in parallel
      final results = await Future.wait([
        getStats(),
        getPlans(),
        getPlanTypes(),
      ]);
      emit(AdminPlansLoaded(
        stats: results[0] as AdminPlanStatsEntity,
        plans: results[1] as List<AdminPlanListItemEntity>,
        types: results[2] as List<String>,
      ));
    } catch (e) {
      emit(AdminPlansError(message: _extractMessage(e)));
    }
  }

  // ── Filter by type ─────────────────────────────────────────────────────────
  Future<void> _onFilterByType(
      FilterByTypeEvent event,
      Emitter<AdminPlansState> emit,
      ) async {
    final current = state;
    if (current is! AdminPlansLoaded) return;

    try {
      final plans = await getPlans(
        type: event.type,
        search: current.activeSearch,
      );
      emit(current.copyWith(
        plans: plans,
        activeTypeFilter: event.type,
        isDeletingPlan: false,
        deletingPlanId: null,
      ));
    } catch (e) {
      emit(AdminPlansError(message: _extractMessage(e)));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Future<void> _onSearch(
      SearchPlansEvent event,
      Emitter<AdminPlansState> emit,
      ) async {
    final current = state;
    if (current is! AdminPlansLoaded) return;

    try {
      final plans = await getPlans(
        type: current.activeTypeFilter,
        search: event.query.isEmpty ? null : event.query,
      );
      emit(current.copyWith(
        plans: plans,
        activeSearch: event.query.isEmpty ? null : event.query,
        isDeletingPlan: false,
        deletingPlanId: null,
      ));
    } catch (e) {
      emit(AdminPlansError(message: _extractMessage(e)));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  Future<void> _onDeletePlan(
      DeletePlanEvent event,
      Emitter<AdminPlansState> emit,
      ) async {
    final current = state;
    if (current is! AdminPlansLoaded) return;

    // Show spinner on the specific card
    emit(current.copyWith(
      isDeletingPlan: true,
      deletingPlanId: event.planId,
    ));

    try {
      await deletePlan(event.planId);
      // Success → refresh the list
      add(RefreshPlansEvent());
    } catch (e) {
      // Restore state + pass error back so screen can show Snackbar
      emit(current.copyWith(
        isDeletingPlan: false,
        deletingPlanId: null,
      ));
      // Re-emit error so BlocListener in screen can show the message
      emit(AdminPlansError(message: _extractMessage(e)));
      // Restore loaded state so screen doesn't go blank
      emit(current.copyWith(isDeletingPlan: false, deletingPlanId: null));
    }
  }

  // ── Refresh (after create/update) ─────────────────────────────────────────
  Future<void> _onRefresh(
      RefreshPlansEvent event,
      Emitter<AdminPlansState> emit,
      ) async {
    final current = state;
    // Keep current filters when refreshing
    final currentType =
    current is AdminPlansLoaded ? current.activeTypeFilter : null;
    final currentSearch =
    current is AdminPlansLoaded ? current.activeSearch : null;
    final currentTypes =
    current is AdminPlansLoaded ? current.types : <String>[];

    try {
      final results = await Future.wait([
        getStats(),
        getPlans(type: currentType, search: currentSearch),
      ]);
      emit(AdminPlansLoaded(
        stats: results[0] as AdminPlanStatsEntity,
        plans: results[1] as List<AdminPlanListItemEntity>,
        types: currentTypes,
        activeTypeFilter: currentType,
        activeSearch: currentSearch,
      ));
    } catch (e) {
      emit(AdminPlansError(message: _extractMessage(e)));
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.replaceFirst('Exception: ', '');
    return msg;
  }
}