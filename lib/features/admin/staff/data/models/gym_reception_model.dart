import '../../domain/entities/gym_reception_entity.dart';

class GymReceptionModel {
  final int     userId;
  final String  fullName;
  final String  phone;
  final String  email;
  final int?    profileFileId;
  final String  assignedAt;

  const GymReceptionModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profileFileId,
    required this.assignedAt,
  });

  factory GymReceptionModel.fromJson(Map<String, dynamic> json) => GymReceptionModel(
    userId:        (json['userId']        as num).toInt(),
    fullName:      json['fullName']        as String? ?? '',
    phone:         json['phone']           as String? ?? '',
    email:         json['email']           as String? ?? '',
    profileFileId: (json['profileFileId'] as num?)?.toInt(),
    assignedAt:    json['assignedAt']      as String? ?? '',
  );

  GymReceptionEntity toEntity() => GymReceptionEntity(
    userId:        userId,
    fullName:      fullName,
    phone:         phone,
    email:         email,
    profileFileId: profileFileId,
    assignedAt:    assignedAt,
  );
}
