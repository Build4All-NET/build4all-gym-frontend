// FILE: lib/features/admin/trainers/data/models/admin_trainer_detail_model.dart
// =============================================================================

import '../../domain/entities/AdminTrainerDetailEntity.dart';
class AvailabilitySlotModel {
  final int     weekday;
  final String? startTime;
  final String? endTime;
  final int?    branchId;

  const AvailabilitySlotModel({
    required this.weekday,
    this.startTime,
    this.endTime,
    this.branchId,
  });

  factory AvailabilitySlotModel.fromJson(Map<String, dynamic> json) =>
      AvailabilitySlotModel(
        weekday:   json['weekday']   as int,
        startTime: json['startTime'] as String?,
        endTime:   json['endTime']   as String?,
        branchId:  json['branchId']  as int?,
      );

  AvailabilitySlotEntity toEntity() => AvailabilitySlotEntity(
    weekday:   weekday,
    startTime: startTime,
    endTime:   endTime,
    branchId:  branchId,
  );
}

class AdminTrainerDetailModel {
  final int          trainerId;
  final String       fullName;
  final String?      email;
  final String?      phone;
  final String       status;
  final List<String> specialties;
  final List<int>    branchIds;
  final List<String> branchNames;
  final int?         yearsOfExperience;
  final String?      notes;
  final List<AvailabilitySlotModel> availabilitySchedule;

  const AdminTrainerDetailModel({
    required this.trainerId,
    required this.fullName,
    this.email,
    this.phone,
    required this.status,
    required this.specialties,
    required this.branchIds,
    required this.branchNames,
    this.yearsOfExperience,
    this.notes,
    required this.availabilitySchedule,
  });

  factory AdminTrainerDetailModel.fromJson(Map<String, dynamic> json) =>
      AdminTrainerDetailModel(
        trainerId:   json['trainerId']   as int,
        fullName:    json['fullName']    as String,
        email:       json['email']       as String?,
        phone:       json['phone']       as String?,
        status:      json['status']      as String? ?? 'ACTIVE',
        specialties: List<String>.from(json['specialties'] ?? []),
        branchIds:   List<int>.from(json['branchIds']   ?? []),
        branchNames: List<String>.from(json['branchNames'] ?? []),
        yearsOfExperience: json['yearsOfExperience'] as int?,
        notes:       json['notes']       as String?,
        availabilitySchedule: (json['availabilitySchedule'] as List<dynamic>? ?? [])
            .map((e) => AvailabilitySlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  AdminTrainerDetailEntity toEntity() => AdminTrainerDetailEntity(
    trainerId:            trainerId,
    fullName:             fullName,
    email:                email,
    phone:                phone,
    status:               status,
    specialties:          specialties,
    branchIds:            branchIds,
    branchNames:          branchNames,
    yearsOfExperience:    yearsOfExperience,
    notes:                notes,
    availabilitySchedule: availabilitySchedule.map((s) => s.toEntity()).toList(),
  );
}