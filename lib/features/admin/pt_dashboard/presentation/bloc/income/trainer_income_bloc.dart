// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/income/trainer_income_bloc.dart
// =============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/trainer_income_entity.dart';
import '../../../domain/usecases/trainer_income_usecases.dart';

part 'trainer_income_event.dart';
part 'trainer_income_state.dart';

class TrainerIncomeBloc extends Bloc<TrainerIncomeEvent, TrainerIncomeState> {
  final GetTrainerIncomeUseCase _getIncome;

  TrainerIncomeBloc({required GetTrainerIncomeUseCase getIncome})
      : _getIncome = getIncome,
        super(const TrainerIncomeInitial()) {
    on<TrainerIncomeLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    TrainerIncomeLoadRequested event,
    Emitter<TrainerIncomeState> emit,
  ) async {
    emit(const TrainerIncomeLoading());

    if (event.trainerId == null) {
      emit(const TrainerIncomeLoaded(TrainerIncomeSummaryEntity.empty));
      return;
    }

    final result = await _getIncome(
      branchId: event.branchId,
      trainerId: event.trainerId,
      from: event.from,
      to: event.to,
    );

    if (result.failure != null) {
      emit(TrainerIncomeError(result.failure!.message));
      return;
    }

    emit(TrainerIncomeLoaded(result.data ?? TrainerIncomeSummaryEntity.empty));
  }
}
