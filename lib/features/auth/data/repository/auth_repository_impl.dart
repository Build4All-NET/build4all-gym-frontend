import 'package:dartz/dartz.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../services/auth_api_service.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/exceptions/auth_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<Either<AuthFailure, void>> sendVerificationCode({
    String? email,
    required String password,
    required int ownerProjectLinkId,
  }) async {
    try {
      await _api.sendVerificationCode(
        email: email,
        password: password,
        ownerProjectLinkId: ownerProjectLinkId,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on AppException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<AuthFailure, int>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final id = await _api.verifyEmailCode(email: email, code: code);
      return Right(id);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on AppException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<Either<AuthFailure, int>> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final id =
      await _api.verifyPhoneCode(phoneNumber: phoneNumber, code: code);
      return Right(id);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on AppException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    }
  }

  @override
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
    required int ownerProjectLinkId,
  }) {
    return _api.loginWithEmail(
      email: email,
      password: password,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }

  @override
  Future<UserEntity> completeProfile({
    required int pendingId,
    required String username,
    required String firstName,
    required String lastName,
    required bool isPublicProfile,
    required int ownerProjectLinkId,
    String? profileImagePath,
  }) {
    return _api.completeUserProfile(
      pendingId: pendingId,
      username: username,
      firstName: firstName,
      lastName: lastName,
      isPublicProfile: isPublicProfile,
      ownerProjectLinkId: ownerProjectLinkId,
      profileImagePath: profileImagePath,
    );
  }
}