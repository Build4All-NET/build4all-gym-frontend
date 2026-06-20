// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/usecases/trainer_income_usecases.dart
// LAYER: Domain — Use Cases
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/trainer_income_entity.dart';
import '../repositories/trainer_income_repository.dart';

class GetTrainerIncomeUseCase {
  final TrainerIncomeRepository _repository;
  const GetTrainerIncomeUseCase(this._repository);

  Future<({TrainerIncomeSummaryEntity? data, Failure? failure})> call({
    required int branchId,
    int? trainerId,
    required DateTime from,
    required DateTime to,
  }) =>
      _repository.getIncome(
        branchId: branchId,
        trainerId: trainerId,
        from: from,
        to: to,
      );
}
