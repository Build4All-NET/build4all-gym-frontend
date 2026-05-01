// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/domain/entities/admin_class_card_entity.dart
//
// PURPOSE:
//   Pure Dart class — no JSON, no Flutter, no imports.
//   This is the DOMAIN representation of a class card. The repository converts
//   the model (data layer) into this entity before passing it to the BLoC.
//   The BLoC and UI only ever see entities, never raw models.
// ─────────────────────────────────────────────────────────────────────────────

class AdminClassCardEntity {
  final int     sessionId;
  final String  className;
  final String  typeName;
  final String  trainerName;
  final String  branchName;
  final String? roomName;
  final String  startTime;
  final String  endTime;
  final int     durationMinutes;
  final int     capacity;
  final int     bookedCount;
  final String  status;
  final bool    nearlyFull;

  const AdminClassCardEntity({
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
}
