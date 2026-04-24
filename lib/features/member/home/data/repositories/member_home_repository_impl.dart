import 'package:dartz/dartz.dart';

import 'package:build4allgym/core/exceptions/network_exception.dart';
import 'package:build4allgym/core/exceptions/server_exception.dart';
import 'package:build4allgym/core/exceptions/forbidden_exception.dart';
import 'package:build4allgym/features/auth/domain/repository/auth_repository.dart';

import '../../domain/entities/body_metric.dart';
import '../../domain/entities/member_home.dart';
import '../../domain/repositories/member_home_repository.dart';
import '../mappers/member_home_mapper.dart';
import '../services/member_home_remote_datasource.dart';

/// Real implementation of MemberHomeRepository.
///
/// Why this class exists:
/// - The domain layer defines what should happen.
/// - This data layer class defines how it actually happens.
/// - It calls the remote datasource.
/// - It converts API models into clean domain entities.
/// - It converts technical exceptions into AuthFailure so the BLoC gets one clean error type.
///
/// Flow example for getMemberHome:
/// BLoC -> GetMemberHomeUseCase -> MemberHomeRepository -> MemberHomeRepositoryImpl
/// -> MemberHomeRemoteDatasource -> backend API
/// -> MemberHomeModel -> MemberHome entity -> BLoC
class MemberHomeRepositoryImpl implements MemberHomeRepository {
  final MemberHomeRemoteDatasource datasource;

  const MemberHomeRepositoryImpl(this.datasource);

  /// Loads the member home data from the backend.
  ///
  /// Success example:
  /// API returns JSON:
  /// {
  ///   "membership": {...},
  ///   "stats": {...},
  ///   "schedule": {...},
  ///   "quote": {...}
  /// }
  ///
  /// Datasource parses it into MemberHomeModel.
  /// Repository maps it into MemberHome entity.
  /// Returns Right(MemberHome).
  ///
  /// Failure example:
  /// No internet -> NetworkException -> Left(AuthFailure(...))
  @override
  Future<Either<AuthFailure, MemberHome>> getMemberHome() async {
    try {
      final model = await datasource.getMemberHome();

      // Convert data-layer model into clean domain entity.
      // The BLoC should not receive backend models.
      final entity = model.toEntity();

      return Right(entity);
    } on NetworkException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ForbiddenException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return const Left(
        AuthFailure('Unknown error', code: 'UNKNOWN_ERROR'),
      );
    }
  }

  /// Sends a new weight value to the backend.
  ///
  /// Request example:
  /// weight = 75.5
  ///
  /// Backend response example:
  /// {
  ///   "weight": 75.5,
  ///   "recordedAt": "2024-07-15T10:30:00Z"
  /// }
  ///
  /// Datasource parses it into BodyMetricModel.
  /// Repository maps it into BodyMetric entity.
  /// Returns Right(BodyMetric).
  @override
  Future<Either<AuthFailure, BodyMetric>> logWeight({
    required double weight,
  }) async {
    try {
      final model = await datasource.logWeight(weight: weight);

      // Convert saved-weight response model into clean domain entity.
      final entity = model.toEntity();

      return Right(entity);
    } on NetworkException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ForbiddenException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return const Left(
        AuthFailure('Unknown error', code: 'UNKNOWN_ERROR'),
      );
    }
  }
}