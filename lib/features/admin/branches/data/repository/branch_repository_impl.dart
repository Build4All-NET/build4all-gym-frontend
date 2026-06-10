// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/repository/branch_repository_impl.dart
//
// Uses AdminBranchesService directly — no datasource wrapper in between.
// Same pattern as other feature repositories in this project.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entity/branch_entity.dart';
import '../../domain/entity/branch_detail_entity.dart';
import '../../domain/entity/branch_stats_entity.dart';
import '../../domain/repository/branch_repository.dart';
import '../model/create_branch_request_model.dart';

import '../service/branch_remote_service.dart';

class BranchRepositoryImpl implements BranchRepository {
  final AdminBranchesService _service;

  BranchRepositoryImpl() : _service = AdminBranchesService();

  @override
  Future<Either<Failure, ({BranchStatsEntity stats, List<BranchEntity> branches})>>
  getBranches({String? status, String? search}) async {
    try {
      final response =
      await _service.getBranches(status: status, search: search);
      return Right((
      stats:    response.stats,
      branches: response.branches,
      ));
    } on UnauthorizedException {
      return Left(const AuthFailure('Unauthorized. Please log in again.'));
    } on ForbiddenException {
      return Left(const ForbiddenFailure('You do not have permission to view branches.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure('No internet connection. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, BranchDetailEntity>> getBranchDetail(
      String branchId) async {
    try {
      final detail = await _service.getBranchDetail(branchId);
      return Right(detail);
    } on UnauthorizedException {
      return Left(const AuthFailure('Unauthorized. Please log in again.'));
    } on ForbiddenException {
      return Left(const ForbiddenFailure('You do not have permission to view this branch.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure('No internet connection. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> createBranch({
    required String name,
    required String city,
    required String phone,
    required String email,
    required String address,
    String? openingTime,
    String? closingTime,
    bool isOpen24Hours = false,
    required String status,
  }) async {
    try {
      final request = CreateBranchRequestModel(
        name:          name,
        city:          city,
        phone:         phone,
        email:         email,
        address:       address,
        openingTime:   openingTime,
        closingTime:   closingTime,
        isOpen24Hours: isOpen24Hours,
        status:        status,
      );
      final branch = await _service.createBranch(request);
      return Right(branch);
    } on UnauthorizedException {
      return Left(const AuthFailure('Unauthorized. Please log in again.'));
    } on ForbiddenException {
      return Left(const ForbiddenFailure('You do not have permission to create a branch.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure('No internet connection. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> updateBranch({
    required String branchId,
    required String name,
    required String city,
    required String phone,
    required String email,
    required String address,
    String? openingTime,
    String? closingTime,
    bool isOpen24Hours = false,
    required String status,
  }) async {
    try {
      final request = CreateBranchRequestModel(
        name:          name,
        city:          city,
        phone:         phone,
        email:         email,
        address:       address,
        openingTime:   openingTime,
        closingTime:   closingTime,
        isOpen24Hours: isOpen24Hours,
        status:        status,
      );
      final branch = await _service.updateBranch(branchId, request);
      return Right(branch);
    } on UnauthorizedException {
      return Left(const AuthFailure('Unauthorized. Please log in again.'));
    } on ForbiddenException {
      return Left(const ForbiddenFailure('You do not have permission to update this branch.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure('No internet connection. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBranch(String branchId) async {
    try {
      await _service.deleteBranch(branchId);
      return const Right(null);
    } on UnauthorizedException {
      return Left(const AuthFailure('Unauthorized. Please log in again.'));
    } on ForbiddenException {
      return Left(const ForbiddenFailure('You do not have permission to delete this branch.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure('No internet connection. Please try again.'));
    }
  }
}