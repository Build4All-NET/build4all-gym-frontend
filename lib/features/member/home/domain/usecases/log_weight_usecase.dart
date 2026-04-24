import 'package:dartz/dartz.dart';

import 'package:build4allgym/features/auth/domain/repository/auth_repository.dart';
import '../entities/body_metric.dart';
import '../repositories/member_home_repository.dart';

/// Use case for logging a new body weight.
///
/// Why this exists:
/// - The BLoC should not call the repository directly.
/// - This keeps the action "log weight" isolated and testable.
/// - If validation is added later, it belongs here before calling the repository.
class LogWeightUseCase {
  final MemberHomeRepository repository;

  const LogWeightUseCase(this.repository);

  /// Sends the weight to the repository.
  Future<Either<AuthFailure, BodyMetric>> call({
    required double weight,
  }) {
    return repository.logWeight(weight: weight);
  }
}