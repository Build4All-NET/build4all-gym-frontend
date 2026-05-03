// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/models/create_staff_request_model.dart
//
// Serialised into the POST /api/admin/staff request body.
//
// password:
//   Nullable by design. When null, toJson() omits the key entirely so the
//   backend knows to auto-generate a 12-char SecureRandom password and email
//   it to the new staff member. When provided, the backend BCrypt-hashes it.
// ─────────────────────────────────────────────────────────────────────────────

class CreateStaffRequestModel {
  final String fullName;
  final String email;
  final String phone;
  final String roleName;  // "Reception" | "Admin" | "Assistant"
  final int branchId;
  final String? password; // null → backend auto-generates

  const CreateStaffRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.roleName,
    required this.branchId,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'roleName': roleName,
      'branchId': branchId,
    };
    // Only include password if the user actually typed one.
    // Omitting it entirely signals the backend to auto-generate.
    if (password != null && password!.isNotEmpty) {
      map['password'] = password;
    }
    return map;
  }
}