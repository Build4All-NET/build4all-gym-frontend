// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/data/models/nav_permission_model.dart
//
// JSON SHAPE (matches the backend NavPermissionDto):
//   { "itemId": "dashboard", "trainerAllowed": false, "receptionAllowed": false }
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/nav_permission_entity.dart';

class NavPermissionModel {
  final String itemId;
  final bool trainerAllowed;
  final bool receptionAllowed;

  const NavPermissionModel({
    required this.itemId,
    required this.trainerAllowed,
    required this.receptionAllowed,
  });

  factory NavPermissionModel.fromJson(Map<String, dynamic> json) => NavPermissionModel(
    itemId: json['itemId'] as String,
    trainerAllowed: json['trainerAllowed'] as bool? ?? false,
    receptionAllowed: json['receptionAllowed'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'trainerAllowed': trainerAllowed,
    'receptionAllowed': receptionAllowed,
  };

  NavPermissionEntity toEntity() => NavPermissionEntity(
    itemId: itemId,
    trainerAllowed: trainerAllowed,
    receptionAllowed: receptionAllowed,
  );

  factory NavPermissionModel.fromEntity(NavPermissionEntity entity) => NavPermissionModel(
    itemId: entity.itemId,
    trainerAllowed: entity.trainerAllowed,
    receptionAllowed: entity.receptionAllowed,
  );
}
