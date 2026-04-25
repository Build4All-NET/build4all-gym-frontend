import 'package:dartz/dartz.dart';

import 'package:build4allgym/features/auth/domain/repository/auth_repository.dart';
import '../entities/member_home.dart';
import '../repositories/member_home_repository.dart';

/// Use case for loading the member home screen data.
///
/// Why this exists:
/// - The BLoC should call a use case, not the repositories directly.
/// - This keeps business actions clear and reusable.
/// - Later, if we add validation, caching rules, or analytics, they go here.
class GetMemberHomeUseCase {
  final MemberHomeRepository repository;

  const GetMemberHomeUseCase(this.repository);

  /// Executes the use case.
  Future<Either<AuthFailure, MemberHome>> call() {
    return repository.getMemberHome();
  }
}