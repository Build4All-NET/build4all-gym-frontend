// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/usecase/get_branches_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entity/branch_entity.dart';
import '../entity/branch_stats_entity.dart';
import '../repository/branch_repository.dart';

class GetBranchesUseCase {
  final BranchRepository repository;

  // CRITICAL: repository must be passed at construction — no default/lazy init
  GetBranchesUseCase(this.repository);

  Future<Either<Failure, ({BranchStatsEntity stats, List<BranchEntity> branches})>>
  call({String? status, String? search}) {
    return repository.getBranches(status: status, search: search);
  }
}