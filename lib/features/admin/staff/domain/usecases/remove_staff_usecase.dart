// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/usecases/remove_staff_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../repositories/admin_staff_repository.dart';

class RemoveStaffUseCase {
  final AdminStaffRepository _repository;

  const RemoveStaffUseCase(this._repository);

  Future<void> call(int staffId) {
    return _repository.removeStaff(staffId);
  }
}