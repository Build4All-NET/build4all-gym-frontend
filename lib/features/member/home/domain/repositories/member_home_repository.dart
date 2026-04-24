import 'package:dartz/dartz.dart';
import 'package:build4allgym/features/auth/domain/repository/auth_repository.dart';

import '../entities/body_metric.dart';
import '../entities/member_home.dart';

abstract class MemberHomeRepository {
  Future<Either<AuthFailure, MemberHome>> getMemberHome();

  Future<Either<AuthFailure, BodyMetric>> logWeight({
    required double weight,
  });
}