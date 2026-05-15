// =============================================================================
// FILE: lib/features/trainer/pt_sessions/domain/entities/pt_session_entity.dart
// LAYER: Domain — pure Dart, zero framework dependencies
//
// Maps to TrainerPtSessionResponse (backend).
//
// Fields present in backend response:
//   ptSessionId, branchId, userId, serviceId, memberPtPackageId,
//   sessionIndex, startTime, endTime, status, paymentStatus, notes, createdAt
//
// Fields NOT in backend (UI-only helpers):
//   memberName   → derived from member lookup or placeholder "Member #userId"
//   serviceName  → derived from service lookup or notes fallback
// =============================================================================

class PtSessionEntity {
  final int ptSessionId;
  final int? branchId;

  /// userId from the backend — the member attending this session.
  final int userId;

  /// Not returned by backend; enriched by member lookup or shown as placeholder.
  /// Example: "Ahmed Hassan"
  final String? memberName;

  /// Trainer who owns this session (included in backend response).
  final int? trainerId;
  final String? trainerName;

  final int? serviceId;

  /// Not returned by backend; enriched by service lookup.
  /// Example: "Strength Training"
  final String? serviceName;

  /// Present when this session is linked to a MemberPtPackage.
  final int? memberPtPackageId;

  /// 1-based index within the package. Shows "Session 3 of 16".
  final int? sessionIndex;

  /// Total services in the linked package (not returned by backend; fetched separately).
  final int? totalPackageSessions;

  final DateTime startTime;
  final DateTime endTime;

  /// SCHEDULED | COMPLETED | CANCELLED | NO_SHOW
  final String status;

  /// UNPAID | PARTIAL | PAID | REFUNDED — nullable
  final String? paymentStatus;

  final String? notes;
  final DateTime? createdAt;

  const PtSessionEntity({
    required this.ptSessionId,
    this.branchId,
    required this.userId,
    this.memberName,
    this.trainerId,
    this.trainerName,
    this.serviceId,
    this.serviceName,
    this.memberPtPackageId,
    this.sessionIndex,
    this.totalPackageSessions,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.paymentStatus,
    this.notes,
    this.createdAt,
  });

  // ── Computed helpers ────────────────────────────────────────────────────────

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  bool get isScheduled => status == 'SCHEDULED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isNoShow => status == 'NO_SHOW';

  bool get isPaid => paymentStatus == 'PAID';

  /// Display name with userId fallback.
  String get displayName => memberName ?? 'Member #$userId';

  /// Initials for the avatar badge (max 2 chars).
  String get initials {
    final name = memberName ?? '';
    if (name.isEmpty) return userId.toString().substring(0, 1);
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  PtSessionEntity copyWith({
    String? status,
    String? paymentStatus,
    String? memberName,
    String? serviceName,
    int? trainerId,
    String? trainerName,
  }) {
    return PtSessionEntity(
      ptSessionId: ptSessionId,
      branchId: branchId,
      userId: userId,
      memberName: memberName ?? this.memberName,
      trainerId: trainerId ?? this.trainerId,
      trainerName: trainerName ?? this.trainerName,
      serviceId: serviceId,
      serviceName: serviceName ?? this.serviceName,
      memberPtPackageId: memberPtPackageId,
      sessionIndex: sessionIndex,
      totalPackageSessions: totalPackageSessions,
      startTime: startTime,
      endTime: endTime,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
