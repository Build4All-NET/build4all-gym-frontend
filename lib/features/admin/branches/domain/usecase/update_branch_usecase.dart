import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entity/branch_entity.dart';
import '../repository/branch_repository.dart';

class UpdateBranchParams {
  final String branchId;
  final String name;
  final String city;
  final String phone;
  final String email;
  final String address;
  final String openingTime;
  final String closingTime;
  final String status;

  const UpdateBranchParams({
    required this.branchId,
    required this.name,
    required this.city,
    required this.phone,
    required this.email,
    required this.address,
    required this.openingTime,
    required this.closingTime,
    this.status = 'ACTIVE',
  });
}

class UpdateBranchUseCase {
  final BranchRepository repository;

  UpdateBranchUseCase(this.repository);

  Future<Either<Failure, BranchEntity>> call(UpdateBranchParams params) {
    return repository.updateBranch(
      branchId:    params.branchId,
      name:        params.name,
      city:        params.city,
      phone:       params.phone,
      email:       params.email,
      address:     params.address,
      openingTime: params.openingTime,
      closingTime: params.closingTime,
      status:      params.status,
    );
  }
}
