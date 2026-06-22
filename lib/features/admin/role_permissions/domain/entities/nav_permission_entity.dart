// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/entities/nav_permission_entity.dart
//
// PURPOSE:
//   One row of the staff nav-permission matrix: whether TRAINER and/or
//   RECEPTION are allowed to see/open a given admin-drawer nav item, for the
//   currently authenticated gym.
// ─────────────────────────────────────────────────────────────────────────────

class NavPermissionEntity {
  final String itemId;
  final bool trainerAllowed;
  final bool receptionAllowed;

  const NavPermissionEntity({
    required this.itemId,
    required this.trainerAllowed,
    required this.receptionAllowed,
  });

  NavPermissionEntity copyWith({bool? trainerAllowed, bool? receptionAllowed}) =>
      NavPermissionEntity(
        itemId: itemId,
        trainerAllowed: trainerAllowed ?? this.trainerAllowed,
        receptionAllowed: receptionAllowed ?? this.receptionAllowed,
      );
}
