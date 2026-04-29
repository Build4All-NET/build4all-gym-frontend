import '../../domain/entities/coupon_validation_entity.dart';
import '../../domain/entities/my_membership_entity.dart';
import '../../domain/entities/plan_detail_entity.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/member_plans_repository.dart';
import '../services/member_plans_remote_datasource.dart';

class MemberPlansRepositoryImpl implements MemberPlansRepository {
  final MemberPlansRemoteDatasource remoteDatasource;

  MemberPlansRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<PlanEntity>> getActivePlans() async {
    final models = await remoteDatasource.getActivePlans();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PlanDetailEntity> getPlanDetail(int planId) async {
    final model = await remoteDatasource.getPlanDetail(planId);

    return model.toEntity();
  }

  @override
  Future<MyMembershipEntity> getMyMembership() async {
    final model = await remoteDatasource.getMyMembership();

    return model.toEntity();
  }

  @override
  Future<CouponValidationEntity> validateCoupon(
    String couponCode,
    int planId,
  ) async {
    final model = await remoteDatasource.validateCoupon(
      couponCode,
      planId,
    );

    return model.toEntity();
  }
}