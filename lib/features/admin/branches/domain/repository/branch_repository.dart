// FILE: features/admin/branches/domain/repository/branch_repository.dart
// Abstract contract — implemented in data layer
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dartz/dartz.dart';
import '../entity/branch_entity.dart';
import '../entity/branch_detail_entity.dart';
import '../entity/branch_stats_entity.dart';
// Adjust import path to your project's Failure class location
import '../../../../../core/error/failures.dart';

abstract class BranchRepository {
  Future<Either<Failure, ({BranchStatsEntity stats, List<BranchEntity> branches})>>
  getBranches({String? status, String? search});

  Future<Either<Failure, BranchDetailEntity>> getBranchDetail(String branchId);

  Future<Either<Failure, BranchEntity>> createBranch({
    required String name,
    required String city,
    required String phone,
    required String email,
    required String address,
    required String openingTime,
    required String closingTime,
    required String status,
  });

  Future<Either<Failure, BranchEntity>> updateBranch({
    required String branchId,
    required String name,
    required String city,
    required String phone,
    required String email,
    required String address,
    required String openingTime,
    required String closingTime,
    required String status,
  });

  Future<Either<Failure, void>> deleteBranch(String branchId);
}