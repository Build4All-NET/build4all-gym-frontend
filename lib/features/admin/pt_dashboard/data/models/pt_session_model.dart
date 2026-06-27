import '../../domain/entities/pt_session_entity.dart';

class PtSessionModel {
  final int       ptSessionId;
  final int?      branchId;
  final int       userId;
  final String?   memberName;
  final int?      trainerId;
  final String?   trainerName;
  final int?      serviceId;
  final int?      memberPtPackageId;
  final int?      sessionIndex;
  final DateTime  startTime;
  final DateTime  endTime;
  final String    status;
  final String?   paymentStatus;
  final String?   notes;
  final DateTime? createdAt;
  final DateTime? requestedNewDate;

  const PtSessionModel({
    required this.ptSessionId,
    this.branchId,
    required this.userId,
    this.memberName,
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
    this.requestedNewDate,
  });

  factory PtSessionModel.fromJson(Map<String, dynamic> json) {
    return PtSessionModel(
      ptSessionId:       json['ptSessionId']       as int,
      branchId:          json['branchId']           as int?,
      userId:            json['userId']             as int,
      memberName:        json['memberName']         as String?,
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
      requestedNewDate:  json['requestedNewDate'] != null
          ? DateTime.tryParse(json['requestedNewDate'] as String)
          : null,
    );
  }

  PtSessionEntity toEntity() {
    return PtSessionEntity(
      ptSessionId:          ptSessionId,
      branchId:             branchId,
      userId:               userId,
      memberName:           memberName,
      trainerId:            trainerId,
      trainerName:          trainerName,
      serviceId:            serviceId,
      serviceName:          null,
      memberPtPackageId:    memberPtPackageId,
      sessionIndex:         sessionIndex,
      totalPackageSessions: null,
      startTime:            startTime,
      endTime:              endTime,
      status:               status,
      paymentStatus:        paymentStatus,
      notes:                notes,
      createdAt:            createdAt,
      requestedNewDate:     requestedNewDate,
    );
  }
}
