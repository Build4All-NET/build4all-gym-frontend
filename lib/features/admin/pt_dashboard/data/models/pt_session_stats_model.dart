// =============================================================================
// FILE: lib/features/trainer/pt_sessions/data/models/pt_session_stats_model.dart
// LAYER: Data
//
// Parses TrainerPtSessionStatsResponse JSON.
// Backend: { "total": 5, "completed": 2, "scheduled": 3 }
// =============================================================================

import '../../domain/entities/pt_session_stats_entity.dart';

class PtSessionStatsModel {
  final int total;
  final int completed;
  final int scheduled;

  const PtSessionStatsModel({
    required this.total,
    required this.completed,
    required this.scheduled,
  });

  factory PtSessionStatsModel.fromJson(Map<String, dynamic> json) {
    return PtSessionStatsModel(
      total:     (json['total']     as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      scheduled: (json['scheduled'] as num?)?.toInt() ?? 0,
    );
  }

  PtSessionStatsEntity toEntity() {
    return PtSessionStatsEntity(
      total:     total,
      completed: completed,
      scheduled: scheduled,
    );
  }
}

// =============================================================================
// FILE: create_session_request_model.dart
//
// Request body for POST /api/trainer/pt-services.
// Maps to CreateTrainerPtSessionRequest (backend).
//
// Example JSON:
// {
//   "branchId": 1,
//   "userId": 42,
//   "serviceId": 3,
//   "memberPtPackageId": 7,
//   "startTime": "2026-05-10T10:00:00",
//   "endTime":   "2026-05-10T11:00:00",
//   "notes": "Focus on upper body"
// }
// =============================================================================

class CreateSessionRequestModel {
  final int branchId;
  final int userId;
  final int? serviceId;
  final int? memberPtPackageId;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;

  const CreateSessionRequestModel({
    required this.branchId,
    required this.userId,
    this.serviceId,
    this.memberPtPackageId,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'branchId':  branchId,
      'userId':    userId,
      if (serviceId          != null) 'serviceId':          serviceId,
      if (memberPtPackageId  != null) 'memberPtPackageId':  memberPtPackageId,
      'startTime': startTime.toIso8601String().substring(0, 19),
      'endTime':   endTime.toIso8601String().substring(0, 19),
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

// =============================================================================
// FILE: update_session_status_request_model.dart
//
// Request body for PATCH /api/trainer/pt-services/{id}/status.
// Maps to UpdateTrainerPtSessionStatusRequest (backend).
//
// Example JSON: { "status": "COMPLETED" }
// Allowed values: COMPLETED | CANCELLED | NO_SHOW
// =============================================================================

class UpdateSessionStatusRequestModel {
  final String status;

  const UpdateSessionStatusRequestModel({required this.status});

  Map<String, dynamic> toJson() => {'status': status};
}
