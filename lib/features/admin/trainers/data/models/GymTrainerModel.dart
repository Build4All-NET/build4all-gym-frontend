// FILE: lib/features/admin/trainers/data/models/gym_trainer_model.dart
//
// JSON shape (matches GymTrainerDto.java):
// {
//   "userId":        42,
//   "fullName":      "John Doe",
//   "phone":         "961-70-123456",
//   "email":         "john@example.com",
//   "profileFileId": null,
//   "assignedAt":    "2026-05-14T10:30:00"
// }

import '../../domain/entities/GymTrainerEntity.dart';

class GymTrainerModel {
  final int     userId;
  final String  fullName;
  final String  phone;
  final String  email;
  final int?    profileFileId;
  final String  assignedAt;

  const GymTrainerModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profileFileId,
    required this.assignedAt,
  });

  factory GymTrainerModel.fromJson(Map<String, dynamic> json) => GymTrainerModel(
    userId:        (json['userId']        as num).toInt(),
    fullName:      json['fullName']        as String? ?? '',
    phone:         json['phone']           as String? ?? '',
    email:         json['email']           as String? ?? '',
    profileFileId: (json['profileFileId'] as num?)?.toInt(),
    assignedAt:    json['assignedAt']      as String? ?? '',
  );

  GymTrainerEntity toEntity() => GymTrainerEntity(
    userId:        userId,
    fullName:      fullName,
    phone:         phone,
    email:         email,
    profileFileId: profileFileId,
    assignedAt:    assignedAt,
  );
}