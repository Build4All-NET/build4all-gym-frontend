// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/repositories/role_permissions_repository.dart
//
// Abstract contract the domain layer depends on — same Dependency Inversion
// pattern as AdminSettingsRepository.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/nav_permission_entity.dart';
import '../entities/staff_account_entity.dart';
import '../entities/user_nav_permission_entity.dart';

abstract class RolePermissionsRepository {
  /// Fetches the current staff nav-permission matrix for this gym.
  Future<List<NavPermissionEntity>> getPermissions();

  /// Replaces the staff nav-permission matrix with [permissions] (HTTP PUT).
  Future<void> savePermissions(List<NavPermissionEntity> permissions);

  /// Fetches every TRAINER/RECEPTION account for this gym, for the
  /// "Specific Account" picker.
  Future<List<StaffAccountEntity>> getStaffAccounts();

  /// Fetches the per-item override state for one specific staff account.
  Future<List<UserNavPermissionEntity>> getUserOverrides(int userId);

  /// Replaces [userId]'s overrides with [overrides] (HTTP PUT). An entry
  /// with `override == null` reverts that item to the role-wide default.
  Future<void> saveUserOverrides(int userId, List<UserNavPermissionEntity> overrides);
}
