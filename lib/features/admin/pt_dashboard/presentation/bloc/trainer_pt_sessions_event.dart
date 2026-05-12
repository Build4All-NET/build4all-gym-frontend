// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/bloc/trainer_pt_sessions_event.dart
// =============================================================================

import 'package:equatable/equatable.dart';

abstract class TrainerPtSessionsEvent extends Equatable {
  const TrainerPtSessionsEvent();

  @override
  List<Object?> get props => [];
}

// ── Initial load ─────────────────────────────────────────────────────────────

/// Fired from initState. Loads sessions + stats for today.
class PtSessionsStarted extends TrainerPtSessionsEvent {
  final int branchId;
  final int trainerId;

  const PtSessionsStarted({required this.branchId, required this.trainerId});

  @override
  List<Object?> get props => [branchId, trainerId];
}

// ── Date navigation ──────────────────────────────────────────────────────────

/// Fired when user taps < or > on the date navigator.
class PtSessionsDateChanged extends TrainerPtSessionsEvent {
  final DateTime date;

  const PtSessionsDateChanged({required this.date});

  @override
  List<Object?> get props => [date];
}

// ── Tab filter ───────────────────────────────────────────────────────────────

/// Fired when user switches between Today / Upcoming / Completed tabs.
class PtSessionsTabChanged extends TrainerPtSessionsEvent {
  /// 0 = Today, 1 = Upcoming, 2 = Completed
  final int tabIndex;

  const PtSessionsTabChanged({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

// ── Status update ─────────────────────────────────────────────────────────────

/// Fired when trainer taps Complete / Cancel on a session card.
/// status: COMPLETED | CANCELLED | NO_SHOW
class PtSessionStatusUpdateRequested extends TrainerPtSessionsEvent {
  final int sessionId;
  final String status;

  const PtSessionStatusUpdateRequested({
    required this.sessionId,
    required this.status,
  });

  @override
  List<Object?> get props => [sessionId, status];
}

// ── Create session ────────────────────────────────────────────────────────────

/// Fired when trainer submits the Book Session form.
class PtSessionCreateRequested extends TrainerPtSessionsEvent {
  final int branchId;
  final int userId;
  final int? serviceId;
  final int? memberPtPackageId;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;

  const PtSessionCreateRequested({
    required this.branchId,
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
        userId,
        serviceId,
        memberPtPackageId,
        startTime,
        endTime,
        notes,
      ];
}
