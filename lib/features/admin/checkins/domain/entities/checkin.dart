// =============================================================================
// FILE: checkin.dart
// PATH: lib/features/admin/checkins/domain/entities/checkin.dart
// LAYER: Domain Layer → Entities
//
// PURPOSE:
//   Pure Dart class — no framework deps, no JSON parsing.
//   This is what the BLoC and widgets work with.
//   The data layer maps raw JSON → CheckinModel → Checkin entity.
// =============================================================================

class Checkin {
  final int    checkinId;
  final int    userId;
  final String fullName;
  final String avatarInitials; // e.g. "RK" — pre-computed by backend
  final String checkinTime;    // "07:50" — display-ready string from backend
  final String status;         // "ACTIVE" | "CHECKED_OUT"
  final String phone;
  final String? entryType;     // "GYM" (plan) | "CLASS" | "PT" | null
  final int?    durationMinutes; // minutes between check-in/out; null while ACTIVE
  final int     visitCount;      // lifetime check-ins for this member

  const Checkin({
    required this.checkinId,
    required this.userId,
    required this.fullName,
    required this.avatarInitials,
    required this.checkinTime,
    required this.status,
    required this.phone,
    this.entryType,
    this.durationMinutes,
    this.visitCount = 0,
  });

  /// Convenience: true when member is still inside.
  bool get isActive => status == 'ACTIVE';
}
