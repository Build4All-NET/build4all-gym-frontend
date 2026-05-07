// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/usecase/get_branch_detail_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entity/branch_detail_entity.dart';
import '../repository/branch_repository.dart';

class GetBranchDetailUseCase {
  final BranchRepository repository;

  GetBranchDetailUseCase(this.repository);

  Future<Either<Failure, BranchDetailEntity>> call(String branchId) {
    return repository.getBranchDetail(branchId);
  }
}