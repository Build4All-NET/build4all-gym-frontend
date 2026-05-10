// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/bloc/trainer_pt_sessions_state.dart
// =============================================================================

import 'package:equatable/equatable.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';

abstract class TrainerPtSessionsState extends Equatable {
  const TrainerPtSessionsState();

  @override
  List<Object?> get props => [];
}

// ── Initial ───────────────────────────────────────────────────────────────────

class PtSessionsInitial extends TrainerPtSessionsState {}

// ── Loading (full-screen) ─────────────────────────────────────────────────────

class PtSessionsLoading extends TrainerPtSessionsState {}

// ── Loaded ────────────────────────────────────────────────────────────────────

class PtSessionsLoaded extends TrainerPtSessionsState {
  final List<PtSessionEntity> sessions;
  final PtSessionStatsEntity stats;
  final DateTime selectedDate;

  /// 0 = Today, 1 = Upcoming, 2 = Completed
  final int selectedTabIndex;

  const PtSessionsLoaded({
    required this.sessions,
    required this.stats,
    required this.selectedDate,
    this.selectedTabIndex = 0,
  });

  /// Sessions filtered by the active tab.
  List<PtSessionEntity> get filteredSessions {
    switch (selectedTabIndex) {
      case 0: // Today — show all sessions for the date (no status filter)
        return sessions;
      case 1: // Upcoming — SCHEDULED only
        return sessions.where((s) => s.isScheduled).toList();
      case 2: // Completed — COMPLETED only
        return sessions.where((s) => s.isCompleted).toList();
      default:
        return sessions;
    }
  }

  PtSessionsLoaded copyWith({
    List<PtSessionEntity>? sessions,
    PtSessionStatsEntity? stats,
    DateTime? selectedDate,
    int? selectedTabIndex,
  }) {
    return PtSessionsLoaded(
      sessions:          sessions          ?? this.sessions,
      stats:             stats             ?? this.stats,
      selectedDate:      selectedDate      ?? this.selectedDate,
      selectedTabIndex:  selectedTabIndex  ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [sessions, stats, selectedDate, selectedTabIndex];
}

// ── Error ─────────────────────────────────────────────────────────────────────

class PtSessionsError extends TrainerPtSessionsState {
  final String message;
  const PtSessionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Action states (per-card spinner + snackbar feedback) ─────────────────────

/// One session card is in-flight (spinning).
class PtSessionActionLoading extends TrainerPtSessionsState {
  /// The session currently being updated.
  final int sessionId;

  /// The full loaded state — needed to keep the rest of the screen rendered.
  final PtSessionsLoaded previousState;

  const PtSessionActionLoading({
    required this.sessionId,
    required this.previousState,
  });

  @override
  List<Object?> get props => [sessionId, previousState];
}

/// Action succeeded — triggers snackbar + list update.
class PtSessionActionSuccess extends TrainerPtSessionsState {
  final String actionType; // 'completed' | 'cancelled' | 'no_show' | 'created'
  final PtSessionsLoaded updatedState;

  const PtSessionActionSuccess({
    required this.actionType,
    required this.updatedState,
  });

  @override
  List<Object?> get props => [actionType, updatedState];
}

/// Action failed — triggers error snackbar; previous state is restored.
class PtSessionActionError extends TrainerPtSessionsState {
  final String message;
  final PtSessionsLoaded previousState;

  const PtSessionActionError({
    required this.message,
    required this.previousState,
  });

  @override
  List<Object?> get props => [message, previousState];
}
