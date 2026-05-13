// =============================================================================
// FILE: lib/features/trainer/pt_sessions/data/models/pt_session_model.dart
// LAYER: Data
//
// Parses TrainerPtSessionResponse JSON from the backend.
//
// Backend JSON shape:
// {
//   "ptSessionId": 1,
//   "branchId": 1,
//   "userId": 42,
//   "serviceId": 3,
//   "memberPtPackageId": 7,       ← nullable
//   "sessionIndex": 3,             ← nullable
//   "startTime": "2026-05-10T10:00:00",
//   "endTime":   "2026-05-10T11:00:00",
//   "status": "SCHEDULED",
//   "paymentStatus": "UNPAID",     ← nullable
//   "notes": "Focus on upper body",← nullable
//   "createdAt": "2026-05-09T12:00:00"
// }
// =============================================================================

import '../../domain/entities/pt_session_entity.dart';

class PtSessionModel {
  final int ptSessionId;
  final int? branchId;
  final int userId;
  final int? trainerId;
  final String? trainerName;
  final int? serviceId;
  final int? memberPtPackageId;
  final int? sessionIndex;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String? paymentStatus;
  final String? notes;
  final DateTime? createdAt;

  const PtSessionModel({
    required this.ptSessionId,
    this.branchId,
    required this.userId,
    this.trainerId,
    this.trainerName,
    this.serviceId,
    this.memberPtPackageId,
    this.sessionIndex,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.paymentStatus,
    this.notes,
    this.createdAt,
  });

  factory PtSessionModel.fromJson(Map<String, dynamic> json) {
    return PtSessionModel(
      ptSessionId:       json['ptSessionId']       as int,
      branchId:          json['branchId']           as int?,
      userId:            json['userId']             as int,
      trainerId:         json['trainerId']          as int?,
      trainerName:       json['trainerName']        as String?,
      serviceId:         json['serviceId']          as int?,
      memberPtPackageId: json['memberPtPackageId']  as int?,
      sessionIndex:      json['sessionIndex']       as int?,
      startTime:         DateTime.parse(json['startTime'] as String),
      endTime:           DateTime.parse(json['endTime']   as String),
      status:            json['status']             as String? ?? 'SCHEDULED',
      paymentStatus:     json['paymentStatus']      as String?,
      notes:             json['notes']              as String?,
      createdAt:         json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  PtSessionEntity toEntity() {
    return PtSessionEntity(
      ptSessionId:       ptSessionId,
      branchId:          branchId,
      userId:            userId,
      memberName:        null,
      trainerId:         trainerId,
      trainerName:       trainerName,
      serviceId:         serviceId,
      serviceName:       null,
      memberPtPackageId: memberPtPackageId,
      sessionIndex:      sessionIndex,
      totalPackageSessions: null,
      startTime:         startTime,
      endTime:           endTime,
      status:            status,
      paymentStatus:     paymentStatus,
      notes:             notes,
      createdAt:         createdAt,
    );
  }
}
