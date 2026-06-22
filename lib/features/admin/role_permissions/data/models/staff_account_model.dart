// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/data/models/staff_account_model.dart
//
// JSON SHAPE (matches the backend StaffAccountDto):
//   { "userId": 1, "fullName": "...", "phone": "...", "email": "...",
//     "profileFileId": null, "gymRoles": ["TRAINER", "RECEPTION"] }
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/staff_account_entity.dart';

class StaffAccountModel {
  final int userId;
  final String fullName;
  final String phone;
  final String email;
  final int? profileFileId;
  final List<String> gymRoles;

  const StaffAccountModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profileFileId,
    required this.gymRoles,
  });

  factory StaffAccountModel.fromJson(Map<String, dynamic> json) => StaffAccountModel(
    userId: json['userId'] as int,
    fullName: json['fullName'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String? ?? '',
    profileFileId: json['profileFileId'] as int?,
    gymRoles: (json['gymRoles'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
  );

  StaffAccountEntity toEntity() => StaffAccountEntity(
    userId: userId,
    fullName: fullName,
    phone: phone,
    email: email,
    profileFileId: profileFileId,
    gymRoles: gymRoles,
  );
}
