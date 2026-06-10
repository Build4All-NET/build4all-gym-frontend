import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repository/branch_repository.dart';

class DeleteBranchUseCase {
  final BranchRepository repository;

  DeleteBranchUseCase(this.repository);

  Future<Either<Failure, void>> call(String branchId) {
    return repository.deleteBranch(branchId);
  }
}
