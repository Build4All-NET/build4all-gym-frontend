// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/income/trainer_income_event.dart
// =============================================================================

part of 'trainer_income_bloc.dart';

abstract class TrainerIncomeEvent extends Equatable {
  const TrainerIncomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load income for [trainerId] (null in admin mode before a trainer is picked)
/// over the [from, to] date range.
class TrainerIncomeLoadRequested extends TrainerIncomeEvent {
  final int branchId;
  final int? trainerId;
  final DateTime from;
  final DateTime to;

  const TrainerIncomeLoadRequested({
    required this.branchId,
    this.trainerId,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [branchId, trainerId, from, to];
}
