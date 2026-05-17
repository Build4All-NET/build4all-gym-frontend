// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/repositories/admin_staff_repository.dart
//
// Abstract contract. The domain layer depends on this interface — never on
// the impl. Dependency inversion: high-level policy, low-level detail.
//
// The usecases accept models from the data layer for request payloads because
// those models carry the toJson() logic that the service needs. If you want
// pure domain, introduce request domain objects — for now the team uses models
// as the request payload (same pattern as the rest of the project).
// ─────────────────────────────────────────────────────────────────────────────

import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';
import '../entities/admin_staff_list_result_entity.dart';

abstract class AdminStaffRepository {
  /// Returns the filtered staff list plus branch-scoped stats.
  Future<AdminStaffListResultEntity> getStaff({
    int? branchId,
    String? search,
  });

  /// Creates a staff member; returns the new staffId.
  Future<int> createStaff(CreateStaffRequestModel request);

  /// Partially updates a staff member — only non-null fields applied.
  Future<void> updateStaff(int staffId, UpdateStaffRequestModel request);

  /// Soft-deletes a staff member.
  Future<void> removeStaff(int staffId);
}