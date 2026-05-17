// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/models/availability_model.dart
// LAYER: Data — Model
//
// Maps trainer_availability DB table response.
// toEntity() converts to domain entity.
// =============================================================================

import '../../domain/entities/availability_entity.dart';

class AvailabilityModel {
  final int availabilityId;
  final int trainerId;
  final int branchId;
  final int weekday;        // 1=Mon … 7=Sun
  final String startTime;  // "HH:mm"
  final String endTime;    // "HH:mm"
  final bool isRecurring;
  final DateTime? specificDate;

  const AvailabilityModel({
    required this.availabilityId,
    required this.trainerId,
    required this.branchId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    this.specificDate,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      availabilityId: (json['availabilityId'] as num?)?.toInt()
          ?? (json['id']             as num?)?.toInt()
          ?? 0,
      trainerId:  (json['trainerId']  as num?)?.toInt() ?? 0,
      branchId:   (json['branchId']   as num?)?.toInt() ?? 0,
      weekday:    (json['weekday']    as num?)?.toInt() ?? 1,
      startTime:  json['startTime']   as String? ?? '00:00',
      endTime:    json['endTime']     as String? ?? '00:00',
      isRecurring:(json['isRecurring'] as bool?) ?? (json['recurring'] as bool?) ?? true,
      specificDate: json['specificDate'] != null
          ? DateTime.tryParse(json['specificDate'] as String)
          : null,
    );
  }

  // ── model → entity ────────────────────────────────────────────────────────

  AvailabilityEntity toEntity() {
    return AvailabilityEntity(
      availabilityId: availabilityId,
      trainerId:      trainerId,
      branchId:       branchId,
      weekday:        weekday,
      startTime:      startTime,
      endTime:        endTime,
      isRecurring:    isRecurring,
      specificDate:   specificDate,
    );
  }
}