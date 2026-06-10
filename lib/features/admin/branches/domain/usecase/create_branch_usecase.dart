// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/usecase/create_branch_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entity/branch_entity.dart';
import '../repository/branch_repository.dart';

class CreateBranchParams {
  final String name;
  final String city;
  final String phone;
  final String email;
  final String address;
  final String? openingTime;
  final String? closingTime;
  final bool isOpen24Hours;
  final String status;

  const CreateBranchParams({
    required this.name,
    required this.city,
    required this.phone,
    required this.email,
    required this.address,
    this.openingTime,
    this.closingTime,
    this.isOpen24Hours = false,
    this.status = 'ACTIVE',
  });
}

class CreateBranchUseCase {
  final BranchRepository repository;

  CreateBranchUseCase(this.repository);

  Future<Either<Failure, BranchEntity>> call(CreateBranchParams params) {
    return repository.createBranch(
      name: params.name,
      city: params.city,
      phone: params.phone,
      email: params.email,
      address: params.address,
      openingTime: params.openingTime,
      closingTime: params.closingTime,
      isOpen24Hours: params.isOpen24Hours,
      status: params.status,
    );
  }
}