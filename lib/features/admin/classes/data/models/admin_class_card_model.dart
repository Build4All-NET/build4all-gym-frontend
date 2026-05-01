// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/models/admin_class_card_model.dart
//
// PURPOSE:
//   JSON ↔ Dart mapping for ONE class session card returned by the API.
//   This is the raw data shape — it knows about JSON but knows nothing about
//   the UI or business logic. The repository maps it to AdminClassCardEntity.
//
// EVERY FIELD matches a key returned by GET /api/admin/classes.
// ─────────────────────────────────────────────────────────────────────────────

class AdminClassCardModel {
  final int    sessionId;
  final String className;
  final String typeName;
  final String trainerName;
  final String branchName;
  final String? roomName;       // nullable — room is optional on a session
  final String startTime;       // pre-formatted string from BE e.g. "7:00 AM"
  final String endTime;         // pre-formatted string e.g. "8:00 AM"
  final int    durationMinutes;
  final int    capacity;
  final int    bookedCount;
  final String status;          // "SCHEDULED" | "ONGOING" | "COMPLETED" | "CANCELLED"
  final bool   nearlyFull;      // true when bookedCount/capacity >= 0.8

  const AdminClassCardModel({
    required this.sessionId,
    required this.className,
    required this.typeName,
    required this.trainerName,
    required this.branchName,
    this.roomName,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.capacity,
    required this.bookedCount,
    required this.status,
    required this.nearlyFull,
  });

  // fromJson — called once per object[] item in the "classes" array from the API
  factory AdminClassCardModel.fromJson(Map<String, dynamic> json) {
    return AdminClassCardModel(
      sessionId:       json['sessionId']       as int,
      className:       json['className']       as String,
      typeName:        json['typeName']        as String,
      trainerName:     json['trainerName']     as String,
      branchName:      json['branchName']      as String,
      roomName:        json['roomName']        as String?,
      startTime:       json['startTime']       as String,
      endTime:         json['endTime']         as String,
      durationMinutes: json['durationMinutes'] as int,
      capacity:        json['capacity']        as int,
      bookedCount:     json['bookedCount']     as int,
      status:          json['status']          as String,
      nearlyFull:      json['nearlyFull']      as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionId':       sessionId,
    'className':       className,
    'typeName':        typeName,
    'trainerName':     trainerName,
    'branchName':      branchName,
    'roomName':        roomName,
    'startTime':       startTime,
    'endTime':         endTime,
    'durationMinutes': durationMinutes,
    'capacity':        capacity,
    'bookedCount':     bookedCount,
    'status':          status,
    'nearlyFull':      nearlyFull,
  };
}