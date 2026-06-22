// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/repositories/trainer_income_repository_impl.dart
// LAYER: Data — Repository implementation
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/trainer_income_entity.dart';
import '../../domain/repositories/trainer_income_repository.dart';
import '../services/trainer_income_service.dart';

class TrainerIncomeRepositoryImpl implements TrainerIncomeRepository {
  final TrainerIncomeService _service;

  const TrainerIncomeRepositoryImpl({required TrainerIncomeService service})
      : _service = service;

  @override
  Future<({TrainerIncomeSummaryEntity? data, Failure? failure})> getIncome({
    required int branchId,
    int? trainerId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final model = await _service.getIncome(
        branchId: branchId,
        trainerId: trainerId,
        from: from,
        to: to,
      );
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (data: null, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }
}
