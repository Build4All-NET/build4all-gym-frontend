// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_event.dart
//
// UPDATED:
//   1. Stable Equatable props
//   2. Better documentation
//   3. Cleaner formatting
// =============================================================================

import 'package:equatable/equatable.dart';

abstract class TrainerPtSessionsEvent extends Equatable {
  const TrainerPtSessionsEvent();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────────────────────────────────────
// Initial load
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsStarted extends TrainerPtSessionsEvent {

  final int branchId;

  /// Trainer self-view:
  ///   trainerId = trainer's userId
  ///
  /// Admin all-trainers mode:
  ///   trainerId = 0
  final int trainerId;

  /// Used only in admin all-trainers mode
  ///
  /// Key   = trainerId
  /// Value = trainer display name
  final Map<int, String> trainerNames;

  const PtSessionsStarted({
    required this.branchId,
    required this.trainerId,
    this.trainerNames = const {},
  });

  @override
  List<Object?> get props => [
    branchId,
    trainerId,
    trainerNames,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Date changed
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsDateChanged extends TrainerPtSessionsEvent {

  final DateTime date;

  const PtSessionsDateChanged({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab changed
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsTabChanged extends TrainerPtSessionsEvent {

  /// 0 = Today
  /// 1 = Upcoming
  /// 2 = Completed
  final int tabIndex;

  const PtSessionsTabChanged({
    required this.tabIndex,
  });

  @override
  List<Object?> get props => [tabIndex];
}

// ─────────────────────────────────────────────────────────────────────────────
// Session status update
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionStatusUpdateRequested
    extends TrainerPtSessionsEvent {

  final int sessionId;

  /// completed / cancelled / no_show / etc
  final String status;

  const PtSessionStatusUpdateRequested({
    required this.sessionId,
    required this.status,
  });

  @override
  List<Object?> get props => [
    sessionId,
    status,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Mark a standalone session as paid (Admin/Owner/Manager only)
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionMarkPaidRequested extends TrainerPtSessionsEvent {
  final int sessionId;
  const PtSessionMarkPaidRequested({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

// ─────────────────────────────────────────────────────────────────────────────
// Accept REQUESTED session (REQUESTED → SCHEDULED)
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionAcceptRequested extends TrainerPtSessionsEvent {
  final int sessionId;
  const PtSessionAcceptRequested({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

// ─────────────────────────────────────────────────────────────────────────────
// Decline REQUESTED session (REQUESTED → CANCELLED)
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionDeclineRequested extends TrainerPtSessionsEvent {
  final int sessionId;
  const PtSessionDeclineRequested({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

// ─────────────────────────────────────────────────────────────────────────────
// Approve CANCEL_REQUESTED → CANCELLED
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionCancelApproved extends TrainerPtSessionsEvent {
  final int sessionId;
  const PtSessionCancelApproved({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

// ─────────────────────────────────────────────────────────────────────────────
// Decline CANCEL_REQUESTED → back to SCHEDULED
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionCancelDeclined extends TrainerPtSessionsEvent {
  final int sessionId;
  const PtSessionCancelDeclined({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

// ─────────────────────────────────────────────────────────────────────────────
// Create session
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionCreateRequested
    extends TrainerPtSessionsEvent {

  final int branchId;

  /// Trainer owning the session
  final int trainerId;

  /// Member/User ID
  final int userId;

  final int? serviceId;

  final int? memberPtPackageId;

  final DateTime startTime;

  final DateTime endTime;

  final String? notes;

  const PtSessionCreateRequested({
    required this.branchId,
    required this.trainerId,
    required this.userId,
    this.serviceId,
    this.memberPtPackageId,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  @override
  List<Object?> get props => [
    branchId,
    trainerId,
    userId,
    serviceId,
    memberPtPackageId,
    startTime,
    endTime,
    notes,
  ];
}