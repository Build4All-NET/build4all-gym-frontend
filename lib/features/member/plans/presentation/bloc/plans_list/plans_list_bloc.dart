import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_active_plans_usecase.dart';
import 'plans_list_event.dart';
import 'plans_list_state.dart';

class PlansListBloc extends Bloc<PlansListEvent, PlansListState> {
  final GetActivePlansUseCase getActivePlans;

  PlansListBloc({
    required this.getActivePlans,
  }) : super(PlansListInitial()) {
    on<LoadPlansEvent>(_onLoadPlans);
  }

  Future<void> _onLoadPlans(
    LoadPlansEvent event,
    Emitter<PlansListState> emit,
  ) async {
    emit(PlansListLoading());

    try {
      final plans = await getActivePlans();

      emit(PlansListLoaded(plans: plans));
    } catch (e) {
      emit(PlansListError(message: e.toString()));
    }
  }
}