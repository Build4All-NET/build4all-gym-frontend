// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_event.dart
//
// FIX: PtSessionCreateRequested now carries trainerId so admin can create
//      sessions for any trainer (not just the JWT user).
// =============================================================================

import 'package:equatable/equatable.dart';

abstract class TrainerPtSessionsEvent extends Equatable {
  const TrainerPtSessionsEvent();

  @override
  List<Object?> get props => [];
}

// ── Initial load ─────────────────────────────────────────────────────────────

class PtSessionsStarted extends TrainerPtSessionsEvent {
  final int branchId;
  final int trainerId;

  const PtSessionsStarted({required this.branchId, required this.trainerId});

  @override
  List<Object?> get props => [branchId, trainerId];
}

// ── Date navigation ──────────────────────────────────────────────────────────

class PtSessionsDateChanged extends TrainerPtSessionsEvent {
  final DateTime date;

  const PtSessionsDateChanged({required this.date});

  @override
  List<Object?> get props => [date];
}

// ── Tab filter ───────────────────────────────────────────────────────────────

class PtSessionsTabChanged extends TrainerPtSessionsEvent {
  /// 0 = Today, 1 = Upcoming, 2 = Completed
  final int tabIndex;

  const PtSessionsTabChanged({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

// ── Status update ─────────────────────────────────────────────────────────────

class PtSessionStatusUpdateRequested extends TrainerPtSessionsEvent {
  final int    sessionId;
  final String status;

  const PtSessionStatusUpdateRequested({
    required this.sessionId,
    required this.status,
  });

  @override
  List<Object?> get props => [sessionId, status];
}

// ── Create session ────────────────────────────────────────────────────────────

class PtSessionCreateRequested extends TrainerPtSessionsEvent {
  final int      branchId;
  /// The trainer this session belongs to.
  /// Admin passes the selected trainerId; trainer passes their own ID.
  final int      trainerId;
  final int      userId;
  final int?     serviceId;
  final int?     memberPtPackageId;
  final DateTime startTime;
  final DateTime endTime;
  final String?  notes;

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