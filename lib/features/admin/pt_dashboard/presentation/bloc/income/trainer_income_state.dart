// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/income/trainer_income_state.dart
// =============================================================================

part of 'trainer_income_bloc.dart';

abstract class TrainerIncomeState extends Equatable {
  const TrainerIncomeState();

  @override
  List<Object?> get props => [];
}

class TrainerIncomeInitial extends TrainerIncomeState {
  const TrainerIncomeInitial();
}

class TrainerIncomeLoading extends TrainerIncomeState {
  const TrainerIncomeLoading();
}

class TrainerIncomeLoaded extends TrainerIncomeState {
  final TrainerIncomeSummaryEntity summary;

  const TrainerIncomeLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class TrainerIncomeError extends TrainerIncomeState {
  final String message;

  const TrainerIncomeError(this.message);

  @override
  List<Object?> get props => [message];
}
