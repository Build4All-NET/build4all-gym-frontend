// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/usecases/get_staff_accounts_usecase.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/staff_account_entity.dart';
import '../repositories/role_permissions_repository.dart';

/// Fetches every TRAINER/RECEPTION account for this gym, for the
/// "Specific Account" picker.
class GetStaffAccountsUseCase {
  final RolePermissionsRepository _repository;
  const GetStaffAccountsUseCase(this._repository);

  Future<List<StaffAccountEntity>> call() => _repository.getStaffAccounts();
}
