import '../entities/plan_detail_entity.dart';
import '../repositories/member_plans_repository.dart';

class GetPlanDetailUseCase {
  final MemberPlansRepository repository;

  GetPlanDetailUseCase({required this.repository});

  Future<PlanDetailEntity> call(int planId) {
    return repository.getPlanDetail(planId);
  }
}