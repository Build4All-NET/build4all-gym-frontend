// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/usecases/create_staff_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../../data/models/create_staff_request_model.dart';
import '../repositories/admin_staff_repository.dart';

class CreateStaffUseCase {
  final AdminStaffRepository _repository;

  const CreateStaffUseCase(this._repository);

  /// Returns the newly created staffId on success.
  Future<int> call(CreateStaffRequestModel request) {
    return _repository.createStaff(request);
  }
}