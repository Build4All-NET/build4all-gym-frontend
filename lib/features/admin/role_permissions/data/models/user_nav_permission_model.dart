// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/data/models/user_nav_permission_model.dart
//
// JSON SHAPE (matches the backend UserNavPermissionDto):
//   { "itemId": "classes_pt", "roleDefaultAllowed": true, "override": null }
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/user_nav_permission_entity.dart';

class UserNavPermissionModel {
  final String itemId;
  final bool roleDefaultAllowed;
  final bool? override;

  const UserNavPermissionModel({
    required this.itemId,
    required this.roleDefaultAllowed,
    required this.override,
  });

  factory UserNavPermissionModel.fromJson(Map<String, dynamic> json) => UserNavPermissionModel(
    itemId: json['itemId'] as String,
    roleDefaultAllowed: json['roleDefaultAllowed'] as bool? ?? false,
    override: json['override'] as bool?,
  );

  /// Includes `override` even when null — the backend uses an explicit JSON
  /// `null` to detect "revert to default" and delete the override row.
  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'roleDefaultAllowed': roleDefaultAllowed,
    'override': override,
  };

  UserNavPermissionEntity toEntity() => UserNavPermissionEntity(
    itemId: itemId,
    roleDefaultAllowed: roleDefaultAllowed,
    override: override,
  );

  factory UserNavPermissionModel.fromEntity(UserNavPermissionEntity entity) => UserNavPermissionModel(
    itemId: entity.itemId,
    roleDefaultAllowed: entity.roleDefaultAllowed,
    override: entity.override,
  );
}
