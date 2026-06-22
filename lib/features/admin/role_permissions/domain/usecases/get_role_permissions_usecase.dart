// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/usecases/get_role_permissions_usecase.dart
//
// Both use-cases live in this one file for brevity, mirroring
// get_admin_settings_usecase.dart.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/nav_permission_entity.dart';
import '../entities/user_nav_permission_entity.dart';
import '../repositories/role_permissions_repository.dart';

/// Fetches the gym's current staff nav-permission matrix.
class GetRolePermissionsUseCase {
  final RolePermissionsRepository _repository;
  const GetRolePermissionsUseCase(this._repository);

  Future<List<NavPermissionEntity>> call() => _repository.getPermissions();
}

/// Persists the gym's staff nav-permission matrix to the backend.
class SaveRolePermissionsUseCase {
  final RolePermissionsRepository _repository;
  const SaveRolePermissionsUseCase(this._repository);

  Future<void> call(List<NavPermissionEntity> permissions) =>
      _repository.savePermissions(permissions);
}

/// Fetches the per-item override state for one specific staff account.
class GetUserOverridesUseCase {
  final RolePermissionsRepository _repository;
  const GetUserOverridesUseCase(this._repository);

  Future<List<UserNavPermissionEntity>> call(int userId) => _repository.getUserOverrides(userId);
}

/// Persists one staff account's per-item permission overrides.
class SaveUserOverridesUseCase {
  final RolePermissionsRepository _repository;
  const SaveUserOverridesUseCase(this._repository);

  Future<void> call(int userId, List<UserNavPermissionEntity> overrides) =>
      _repository.saveUserOverrides(userId, overrides);
}
