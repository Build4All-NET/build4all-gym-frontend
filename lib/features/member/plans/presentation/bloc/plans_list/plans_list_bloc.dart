import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_active_plans_usecase.dart';
import 'plans_list_event.dart';
import 'plans_list_state.dart';

/// BLoC responsible for loading the list of active membership plans.
///
/// This class only talks to the domain use case.
/// It does NOT call datasource or repository directly.
class PlansListBloc extends Bloc<PlansListEvent, PlansListState> {
  final GetActivePlansUseCase getActivePlans;

  PlansListBloc({
    required this.getActivePlans,
  }) : super(PlansListInitial()) {
    /// Register handler for loading plans.
    on<LoadPlansEvent>(_onLoadPlans);
  }

  /// Handles LoadPlansEvent.
  ///
  /// Flow:
  /// 1. Emit loading state
  /// 2. Call GetActivePlansUseCase
  /// 3. Emit loaded state if successful
  /// 4. Emit error state if something fails
  Future<void> _onLoadPlans(
      LoadPlansEvent event,
      Emitter<PlansListState> emit,
      ) async {
    emit(PlansListLoading());

    try {
      final plans = await getActivePlans();

      emit(
        PlansListLoaded(
          plans: plans,
        ),
      );
    } catch (e) {
      emit(
        PlansListError(
          message: e.toString(),
        ),
      );
    }
  }
}