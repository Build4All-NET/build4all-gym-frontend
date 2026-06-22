// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/repositories/trainer_income_repository.dart
// LAYER: Domain — Repository contract
// =============================================================================

import '../../../../../core/error/failures.dart';
import '../entities/trainer_income_entity.dart';

abstract class TrainerIncomeRepository {
  /// [trainerId] = null in admin mode before a trainer is picked -> empty result.
  Future<({TrainerIncomeSummaryEntity? data, Failure? failure})> getIncome({
    required int branchId,
    int? trainerId,
    required DateTime from,
    required DateTime to,
  });
}
