// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/usecases/get_staff_usecase.dart
//
// Single-responsibility: delegates to the repository and returns the entity.
// The BLoC calls this, not the repository directly — keeping domain logic
// decoupled from HTTP and injection details.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/admin_staff_list_result_entity.dart';
import '../repositories/admin_staff_repository.dart';

class GetStaffUseCase {
  final AdminStaffRepository _repository;

  const GetStaffUseCase(this._repository);

  Future<AdminStaffListResultEntity> call({
    int? branchId,
    String? search,
  }) {
    return _repository.getStaff(branchId: branchId, search: search);
  }
}