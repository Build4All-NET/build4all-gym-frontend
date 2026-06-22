// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/entities/user_nav_permission_entity.dart
//
// PURPOSE:
//   One row of a specific staff account's per-item permission override, for
//   the "Specific Account" mode of the Staff Access Control screen.
//   override == null means "Use Default" (no override row on the backend) —
//   falls back to roleDefaultAllowed.
// ─────────────────────────────────────────────────────────────────────────────

class UserNavPermissionEntity {
  final String itemId;
  final bool roleDefaultAllowed;
  final bool? override;

  const UserNavPermissionEntity({
    required this.itemId,
    required this.roleDefaultAllowed,
    required this.override,
  });

  /// `null` is a legitimate target value for [override] (means "Use
  /// Default"), so a plain `bool? override` param can't distinguish "don't
  /// change" from "set to null" — pass a value-returning function instead.
  UserNavPermissionEntity copyWith({bool? Function()? override}) =>
      UserNavPermissionEntity(
        itemId: itemId,
        roleDefaultAllowed: roleDefaultAllowed,
        override: override != null ? override() : this.override,
      );
}
