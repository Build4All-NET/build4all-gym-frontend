// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/models/update_staff_request_model.dart
//
// Serialised into the PUT /api/admin/staff/{staffId} request body.
//
// PARTIAL UPDATE PATTERN:
//   All fields are nullable. toJson() excludes null fields so the backend
//   applies only the fields that were actually changed. This mirrors the
//   service-layer behaviour: "if (request.getFullName() != null) user.setFullName(...)".
// ─────────────────────────────────────────────────────────────────────────────

class UpdateStaffRequestModel {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? roleName;
  final int? branchId;

  const UpdateStaffRequestModel({
    this.fullName,
    this.email,
    this.phone,
    this.roleName,
    this.branchId,
  });

  // Only serialises non-null fields — the backend ignores absent keys
  // and leaves those fields unchanged on the User record.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fullName != null) map['fullName'] = fullName;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (roleName != null) map['roleName'] = roleName;
    if (branchId != null) map['branchId'] = branchId;
    return map;
  }
}