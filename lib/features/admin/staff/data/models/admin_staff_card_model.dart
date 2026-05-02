// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/models/admin_staff_card_model.dart
//
// WHY A SEPARATE MODEL?
//   The model lives in the data layer and handles JSON serialisation only.
//   The entity (domain layer) is a pure Dart class with no JSON logic.
//   The repository impl converts model → entity so the rest of the app never
//   depends on raw JSON shapes.
//
// profileFileId:
//   The backend sends this as a String (or null). The UI uses it to resolve
//   a profile photo URL — that resolution happens in the widget, not here.
// ─────────────────────────────────────────────────────────────────────────────

class AdminStaffCardModel {
  final int staffId;
  final String fullName;
  final String? profileFileId; // nullable — staff may not have uploaded a photo
  final String email;
  final String phone;
  final String roleName;   // display label: "Reception" | "Admin" | "Assistant"
  final String branchName;
  final String status;     // "ACTIVE" | "INACTIVE" | "BLOCKED"

  const AdminStaffCardModel({
    required this.staffId,
    required this.fullName,
    this.profileFileId,
    required this.email,
    required this.phone,
    required this.roleName,
    required this.branchName,
    required this.status,
  });

  factory AdminStaffCardModel.fromJson(Map<String, dynamic> json) {
    return AdminStaffCardModel(
      // The backend sends user_id / staffId as a number; safe-cast via int.parse
      // in case the driver serialises it as a String in some environments.
      staffId: (json['staffId'] as num).toInt(),
      fullName: json['fullName'] as String,
      profileFileId: json['profileFileId'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String,
      roleName: json['roleName'] as String,
      branchName: json['branchName'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'staffId': staffId,
    'fullName': fullName,
    if (profileFileId != null) 'profileFileId': profileFileId,
    'email': email,
    'phone': phone,
    'roleName': roleName,
    'branchName': branchName,
    'status': status,
  };
}