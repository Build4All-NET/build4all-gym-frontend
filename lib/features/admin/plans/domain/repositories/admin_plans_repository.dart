import '../entities/admin_plan_stats_entity.dart';
import '../entities/admin_plan_list_item_entity.dart';
import '../entities/admin_branch_option_entity.dart';
import '../../data/models/createplanrequestmodel.dart';
import '../../data/models/updateplanrequestmodel.dart';

abstract class AdminPlansRepository {
  Future<AdminPlanStatsEntity> getStats();
  Future<List<AdminPlanListItemEntity>> getPlans({String? type, String? search});
  Future<List<String>> getPlanTypes();
  Future<List<AdminBranchOptionEntity>> getBranches();
  Future<void> createPlan(CreatePlanRequestModel request);
  Future<void> updatePlan(int planId, UpdatePlanRequestModel request);
  Future<void> deletePlan(int planId);
}