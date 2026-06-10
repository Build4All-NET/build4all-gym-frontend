// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_state.dart
//
// UPDATED:
//   1. Fixed session filtering logic
//   2. Removed dangerous DateTime.now() fallback
//   3. Added helper methods
//   4. Added stable action states
//   5. Fixed today/upcoming/completed filters
// =============================================================================

part of 'trainer_pt_sessions_bloc.dart';

abstract class TrainerPtSessionsState extends Equatable {
  const TrainerPtSessionsState();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────────────────────────────────────
// Initial
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsInitial extends TrainerPtSessionsState {
  const PtSessionsInitial();
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsLoading extends TrainerPtSessionsState {
  const PtSessionsLoading();
}

// ─────────────────────────────────────────────────────────────────────────────
// Error
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsError extends TrainerPtSessionsState {

  final String message;

  const PtSessionsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

// ─────────────────────────────────────────────────────────────────────────────
// Loaded
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionsLoaded extends TrainerPtSessionsState {

  final List<PtSessionEntity> sessions;

  /// All future active sessions loaded independently of date — shown in tab 1.
  final List<PtSessionEntity> upcomingSessions;

  /// All REQUESTED sessions loaded independently of date — shown in tab 3.
  final List<PtSessionEntity> requestedSessions;

  final DateTime selectedDate;

  /// 0 = Today
  /// 1 = Upcoming
  /// 2 = Completed
  /// 3 = Requests (REQUESTED status, date-independent)
  final int selectedTabIndex;

  final PtSessionStatsEntity stats;

  const PtSessionsLoaded({
    required this.sessions,
    required this.selectedDate,
    required this.selectedTabIndex,
    required this.stats,
    this.upcomingSessions  = const [],
    this.requestedSessions = const [],
  });

  // ==========================================================================
  // Helpers
  // ==========================================================================

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _isCompleted(String? status) {

    final normalized = status?.toLowerCase();

    return normalized == 'completed' ||
        normalized == 'no_show';
  }

  bool _isCancelled(String? status) {
    return status?.toLowerCase() == 'cancelled';
  }

  bool _isActive(String? status) {
    return !_isCompleted(status) &&
        !_isCancelled(status);
  }

  // ==========================================================================
  // Filtered sessions
  // ==========================================================================

  List<PtSessionEntity> get filteredSessions {

    final today = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    switch (selectedTabIndex) {

    // ======================================================================
    // TODAY
    // ======================================================================

      case 0:

        return sessions.where((session) {

          final start = session.startTime;

          if (start == null) return false;

          return _isSameDay(start, today) &&
              _isActive(session.status);

        }).toList();

    // ======================================================================
    // UPCOMING
    // ======================================================================

      case 1:
        // Also include today's future SCHEDULED sessions so that accepting
        // a same-day request immediately shows up here even if the backend
        // /upcoming endpoint only returns sessions after today.
        final now = DateTime.now();
        final todayFuture = sessions.where((s) {
          final start = s.startTime;
          return s.isScheduled && start != null && start.isAfter(now);
        }).toList();
        final upcomingIds = {for (final s in upcomingSessions) s.ptSessionId};
        final extra = todayFuture.where((s) => !upcomingIds.contains(s.ptSessionId)).toList();
        final merged = [...upcomingSessions, ...extra]
          ..sort((a, b) => (a.startTime ?? DateTime(9999))
              .compareTo(b.startTime ?? DateTime(9999)));
        return merged;

    // ======================================================================
    // COMPLETED
    // ======================================================================

      case 2:

        return sessions.where((session) {

          return _isCompleted(session.status);

        }).toList();

    // ======================================================================
    // REQUESTS
    // ======================================================================

      case 3:
        return List.of(requestedSessions);

      default:
        return [];
    }
  }

  // ==========================================================================
  // CopyWith
  // ==========================================================================

  PtSessionsLoaded copyWith({
    List<PtSessionEntity>? sessions,
    List<PtSessionEntity>? upcomingSessions,
    List<PtSessionEntity>? requestedSessions,
    DateTime? selectedDate,
    int? selectedTabIndex,
    PtSessionStatsEntity? stats,
  }) {
    return PtSessionsLoaded(
      sessions:          sessions          ?? this.sessions,
      upcomingSessions:  upcomingSessions  ?? this.upcomingSessions,
      requestedSessions: requestedSessions ?? this.requestedSessions,
      selectedDate:      selectedDate      ?? this.selectedDate,
      selectedTabIndex:  selectedTabIndex  ?? this.selectedTabIndex,
      stats:             stats             ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    sessions,
    upcomingSessions,
    requestedSessions,
    selectedDate,
    selectedTabIndex,
    stats,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Loading
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionActionLoading
    extends TrainerPtSessionsState {

  final int sessionId;

  final PtSessionsLoaded previousState;

  const PtSessionActionLoading({
    required this.sessionId,
    required this.previousState,
  });

  @override
  List<Object?> get props => [
    sessionId,
    previousState,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Success
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionActionSuccess
    extends TrainerPtSessionsState {

  /// created / completed / cancelled / etc
  final String actionType;

  final PtSessionsLoaded updatedState;

  const PtSessionActionSuccess({
    required this.actionType,
    required this.updatedState,
  });

  @override
  List<Object?> get props => [
    actionType,
    updatedState,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Error
// ─────────────────────────────────────────────────────────────────────────────

class PtSessionActionError
    extends TrainerPtSessionsState {

  final String message;

  final PtSessionsLoaded previousState;

  const PtSessionActionError({
    required this.message,
    required this.previousState,
  });

  @override
  List<Object?> get props => [
    message,
    previousState,
  ];
}