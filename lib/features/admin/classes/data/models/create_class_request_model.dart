// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/models/create_class_request_model.dart
//
// PURPOSE:
//   Request body sent to POST /api/admin/classes.
//   Only toJson() — this is outbound only, never parsed from API response.
//   All required fields match the BE's CreateClassRequest validation constraints.
// ─────────────────────────────────────────────────────────────────────────────

class CreateClassRequestModel {
  final String  className;
  final int     classTypeId;
  final int     trainerId;
  final int     branchId;
  final String  date;            // "yyyy-MM-dd" format e.g. "2026-03-16"
  final String  time;            // "HH:mm" format e.g. "07:00"
  final int     durationMinutes;
  final int     capacity;
  final String? roomName;        // optional
  final String? notes;           // optional — BRD 8.2.10
  final double? commissionPercentage; // optional (0-100) — trainer's cut of this class

  const CreateClassRequestModel({
    required this.className,
    required this.classTypeId,
    required this.trainerId,
    required this.branchId,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.capacity,
    this.roomName,
    this.notes,
    this.commissionPercentage,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'className':       className,
      'classTypeId':     classTypeId,
      'trainerId':       trainerId,
      'branchId':        branchId,
      'date':            date,
      'time':            time,
      'durationMinutes': durationMinutes,
      'capacity':        capacity,
    };
    // Only include optional fields when they have a value
    if (roomName != null) map['roomName'] = roomName;
    if (notes    != null) map['notes']    = notes;
    if (commissionPercentage != null) map['commissionPercentage'] = commissionPercentage;
    return map;
  }
}