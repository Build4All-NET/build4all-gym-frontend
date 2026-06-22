// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/domain/entities/staff_account_entity.dart
//
// PURPOSE:
//   One entry in the "Specific Account" picker — a TRAINER and/or RECEPTION
//   account for this gym. A dual-role user appears once, with both roles
//   listed in [gymRoles].
// ─────────────────────────────────────────────────────────────────────────────

class StaffAccountEntity {
  final int userId;
  final String fullName;
  final String phone;
  final String email;
  final int? profileFileId;
  final List<String> gymRoles;

  const StaffAccountEntity({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profileFileId,
    required this.gymRoles,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }
}
