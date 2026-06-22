import '../../domain/entities/eligible_staff_entity.dart';

class EligibleStaffModel {
  final int userId;
  final String fullName;
  final String? phone;
  final String? email;
  final int? profileFileId;
  final String gymRole;

  const EligibleStaffModel({
    required this.userId,
    required this.fullName,
    this.phone,
    this.email,
    this.profileFileId,
    required this.gymRole,
  });

  factory EligibleStaffModel.fromJson(Map<String, dynamic> json) {
    return EligibleStaffModel(
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      profileFileId: (json['profileFileId'] as num?)?.toInt(),
      gymRole: json['gymRole'] as String,
    );
  }

  EligibleStaffEntity toEntity() => EligibleStaffEntity(
        userId: userId,
        fullName: fullName,
        phone: phone,
        email: email,
        profileFileId: profileFileId,
        gymRole: gymRole,
      );
}
