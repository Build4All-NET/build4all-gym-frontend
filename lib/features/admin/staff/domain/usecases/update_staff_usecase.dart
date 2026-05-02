// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/usecases/update_staff_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../../data/models/update_staff_request_model.dart';
import '../repositories/admin_staff_repository.dart';

class UpdateStaffUseCase {
  final AdminStaffRepository _repository;

  const UpdateStaffUseCase(this._repository);

  Future<void> call(int staffId, UpdateStaffRequestModel request) {
    return _repository.updateStaff(staffId, request);
  }
}