import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/admin_branch_option_entity.dart';
import '../../../domain/usecases/admin_plans_usecases.dart';
import '../../../data/models/createplanrequestmodel.dart';
import '../../../data/models/updateplanrequestmodel.dart';

part 'plan_form_event.dart';
part 'plan_form_state.dart';

class PlanFormBloc extends Bloc<PlanFormEvent, PlanFormState> {
  final GetPlanTypesUseCase getPlanTypes;
  final GetBranchesUseCase getBranches;
  final CreatePlanUseCase createPlan;
  final UpdatePlanUseCase updatePlan;

  PlanFormBloc({
    required this.getPlanTypes,
    required this.getBranches,
    required this.createPlan,
    required this.updatePlan,
  }) : super(PlanFormInitial()) {
    on<LoadFormDataEvent>(_onLoadFormData);
    on<SubmitCreatePlanEvent>(_onSubmitCreate);
    on<SubmitUpdatePlanEvent>(_onSubmitUpdate);
  }

  // ── Load types + branches for dropdowns ───────────────────────────────────
  Future<void> _onLoadFormData(
      LoadFormDataEvent event,
      Emitter<PlanFormState> emit,
      ) async {
    emit(PlanFormDataLoading());
    try {
      final results = await Future.wait([
        getPlanTypes(),
        getBranches(),
      ]);
      emit(PlanFormDataLoaded(
        types: results[0] as List<String>,
        branches: results[1] as List<AdminBranchOptionEntity>,
      ));
    } catch (e) {
      emit(PlanFormError(
        message: _extractMessage(e),
        types: [],
        branches: [],
      ));
    }
  }

  // ── Create plan ───────────────────────────────────────────────────────────
  Future<void> _onSubmitCreate(
      SubmitCreatePlanEvent event,
      Emitter<PlanFormState> emit,
      ) async {
    final current = state;
    final types = current is PlanFormDataLoaded
        ? current.types
        : current is PlanFormError
        ? current.types
        : <String>[];
    final branches = current is PlanFormDataLoaded
        ? current.branches
        : current is PlanFormError
        ? current.branches
        : <AdminBranchOptionEntity>[];

    emit(PlanFormSubmitting(types: types, branches: branches));
    try {
      await createPlan(event.request);
      emit(PlanFormSuccess(message: 'Plan created successfully'));
    } catch (e) {
      emit(PlanFormError(
        message: _extractMessage(e),
        types: types,
        branches: branches,
      ));
    }
  }

  // ── Update plan ───────────────────────────────────────────────────────────
  Future<void> _onSubmitUpdate(
      SubmitUpdatePlanEvent event,
      Emitter<PlanFormState> emit,
      ) async {
    final current = state;
    final types = current is PlanFormDataLoaded
        ? current.types
        : current is PlanFormError
        ? current.types
        : <String>[];
    final branches = current is PlanFormDataLoaded
        ? current.branches
        : current is PlanFormError
        ? current.branches
        : <AdminBranchOptionEntity>[];

    emit(PlanFormSubmitting(types: types, branches: branches));
    try {
      await updatePlan(event.planId, event.request);
      emit(PlanFormSuccess(message: 'Plan updated successfully'));
    } catch (e) {
      emit(PlanFormError(
        message: _extractMessage(e),
        types: types,
        branches: branches,
      ));
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.replaceFirst('Exception: ', '');
    return msg;
  }
}