import '../entities/plan_entity.dart';
import '../repositories/member_plans_repository.dart';

class GetActivePlansUseCase {
  final MemberPlansRepository repository;

  GetActivePlansUseCase({required this.repository});

  Future<List<PlanEntity>> call() {
    return repository.getActivePlans();
  }
}