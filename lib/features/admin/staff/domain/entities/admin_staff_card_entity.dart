// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/entities/admin_staff_card_entity.dart
//
// Pure Dart domain object — no JSON, no Dio, no Flutter imports.
// The BLoC, UseCases, and UI work exclusively with this type, not the model.
// ─────────────────────────────────────────────────────────────────────────────

class AdminStaffCardEntity {
  final int staffId;
  final String fullName;
  final String? profileFileId;
  final String email;
  final String phone;
  final String roleName;    // display label: "Reception" | "Admin" | "Assistant"
  final String branchName;
  final String status;      // "ACTIVE" | "INACTIVE" | "BLOCKED"

  const AdminStaffCardEntity({
    required this.staffId,
    required this.fullName,
    this.profileFileId,
    required this.email,
    required this.phone,
    required this.roleName,
    required this.branchName,
    required this.status,
  });
}