import '../entities/admin_plan_stats_entity.dart';
import '../entities/admin_plan_list_item_entity.dart';
import '../entities/admin_branch_option_entity.dart';
import '../repositories/admin_plans_repository.dart';
import '../../data/models/createplanrequestmodel.dart';
import '../../data/models/updateplanrequestmodel.dart';

// ── GA-223 ────────────────────────────────────────────────────────────────────

class GetAdminPlanStatsUseCase {
  final AdminPlansRepository repository;
  GetAdminPlanStatsUseCase({required this.repository});
  Future<AdminPlanStatsEntity> call() => repository.getStats();
}

class GetAdminPlansUseCase {
  final AdminPlansRepository repository;
  GetAdminPlansUseCase({required this.repository});
  Future<List<AdminPlanListItemEntity>> call({String? type, String? search}) =>
      repository.getPlans(type: type, search: search);
}

class GetPlanTypesUseCase {
  final AdminPlansRepository repository;
  GetPlanTypesUseCase({required this.repository});
  Future<List<String>> call() => repository.getPlanTypes();
}

class GetBranchesUseCase {
  final AdminPlansRepository repository;
  GetBranchesUseCase({required this.repository});
  Future<List<AdminBranchOptionEntity>> call() => repository.getBranches();
}

class CreatePlanUseCase {
  final AdminPlansRepository repository;
  CreatePlanUseCase({required this.repository});
  Future<void> call(CreatePlanRequestModel request) =>
      repository.createPlan(request);
}

class UpdatePlanUseCase {
  final AdminPlansRepository repository;
  UpdatePlanUseCase({required this.repository});
  Future<void> call(int planId, UpdatePlanRequestModel request) =>
      repository.updatePlan(planId, request);
}

class DeletePlanUseCase {
  final AdminPlansRepository repository;
  DeletePlanUseCase({required this.repository});
  Future<void> call(int planId) => repository.deletePlan(planId);
}