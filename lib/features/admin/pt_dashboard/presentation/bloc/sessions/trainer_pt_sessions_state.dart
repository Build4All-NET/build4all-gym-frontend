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

  final DateTime selectedDate;

  /// 0 = Today
  /// 1 = Upcoming
  /// 2 = Completed
  final int selectedTabIndex;

  final PtSessionStatsEntity stats;

  const PtSessionsLoaded({
    required this.sessions,
    required this.selectedDate,
    required this.selectedTabIndex,
    required this.stats,
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

        return sessions.where((session) {

          final start = session.startTime;

          if (start == null) return false;

          return start.isAfter(today) &&
              !_isSameDay(start, today) &&
              _isActive(session.status);

        }).toList();

    // ======================================================================
    // COMPLETED
    // ======================================================================

      case 2:

        return sessions.where((session) {

          return _isCompleted(session.status);

        }).toList();

      default:
        return [];
    }
  }

  // ==========================================================================
  // CopyWith
  // ==========================================================================

  PtSessionsLoaded copyWith({
    List<PtSessionEntity>? sessions,
    DateTime? selectedDate,
    int? selectedTabIndex,
    PtSessionStatsEntity? stats,
  }) {

    return PtSessionsLoaded(
      sessions: sessions ?? this.sessions,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTabIndex:
      selectedTabIndex ?? this.selectedTabIndex,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    sessions,
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