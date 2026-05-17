import '../../domain/entities/admin_plan_stats_entity.dart';
import '../../domain/entities/admin_plan_list_item_entity.dart';
import '../../domain/entities/admin_branch_option_entity.dart';
import '../../domain/repositories/admin_plans_repository.dart';
import '../services/admin_plans_remote_service.dart';
import '../models/CreatePlanRequestModel.dart';
import '../models/UpdatePlanRequestModel.dart';

class AdminPlansRepositoryImpl implements AdminPlansRepository {
  final AdminPlansRemoteDatasource remoteDatasource;

  AdminPlansRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AdminPlanStatsEntity> getStats() async {
    try {
      final model = await remoteDatasource.getStats();
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdminPlanListItemEntity>> getPlans(
      {String? type, String? search}) async {
    try {
      final models =
      await remoteDatasource.getPlans(type: type, search: search);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getPlanTypes() async {
    try {
      return await remoteDatasource.getPlanTypes();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdminBranchOptionEntity>> getBranches() async {
    try {
      final models = await remoteDatasource.getBranches();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createPlan(CreatePlanRequestModel request) async {
    try {
      await remoteDatasource.createPlan(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePlan(int planId, UpdatePlanRequestModel request) async {
    try {
      await remoteDatasource.updatePlan(planId, request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePlan(int planId) async {
    try {
      await remoteDatasource.deletePlan(planId);
    } catch (e) {
      // Rethrow with original message (e.g. "Cannot delete plan: 3 active members")
      rethrow;
    }
  }
}
