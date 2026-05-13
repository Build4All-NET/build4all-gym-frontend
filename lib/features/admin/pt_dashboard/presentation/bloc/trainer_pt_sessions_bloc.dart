// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_bloc.dart
//
// FIX SUMMARY:
//   1. _onCreate now uses event.trainerId (supports admin creating for any trainer).
//   2. _loadForDate passes both branchId and trainerId correctly.
//   3. Removed stale currentBranchId getter dependency from UI.
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import 'trainer_pt_sessions_event.dart';
import 'trainer_pt_sessions_state.dart';

class TrainerPtSessionsBloc
    extends Bloc<TrainerPtSessionsEvent, TrainerPtSessionsState> {
  final GetSessionsByDateUseCase _getSessions;
  final GetSessionStatsUseCase   _getStats;
  final CreateSessionUseCase     _createSession;
  final UpdateSessionStatusUseCase _updateStatus;

  DateTime _selectedDate = DateTime.now();
  int      _branchId     = 1;
  int      _trainerId    = 0;

  int get currentBranchId  => _branchId;
  int get currentTrainerId => _trainerId;

  TrainerPtSessionsBloc({
    required GetSessionsByDateUseCase getSessions,
    required GetSessionStatsUseCase   getStats,
    required CreateSessionUseCase     createSession,
    required UpdateSessionStatusUseCase updateStatus,
  })  : _getSessions    = getSessions,
        _getStats       = getStats,
        _createSession  = createSession,
        _updateStatus   = updateStatus,
        super(PtSessionsInitial()) {
    on<PtSessionsStarted>(_onStarted);
    on<PtSessionsDateChanged>(_onDateChanged);
    on<PtSessionsTabChanged>(_onTabChanged);
    on<PtSessionStatusUpdateRequested>(_onStatusUpdate);
    on<PtSessionCreateRequested>(_onCreate);
  }

  // ── Initial load ──────────────────────────────────────────────────────────

  Future<void> _onStarted(
      PtSessionsStarted event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {
    _branchId     = event.branchId;
    _trainerId    = event.trainerId;
    _selectedDate = DateTime.now();
    await _loadForDate(emit, _selectedDate);
  }

  // ── Date navigation ───────────────────────────────────────────────────────

  Future<void> _onDateChanged(
      PtSessionsDateChanged event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {
    _selectedDate = event.date;
    final prevTabIndex =
    state is PtSessionsLoaded
        ? (state as PtSessionsLoaded).selectedTabIndex
        : 0;
    await _loadForDate(emit, _selectedDate, tabIndex: prevTabIndex);
  }

  // ── Tab switch ────────────────────────────────────────────────────────────

  void _onTabChanged(
      PtSessionsTabChanged event,
      Emitter<TrainerPtSessionsState> emit,
      ) {
    if (state is! PtSessionsLoaded) return;
    final current = state as PtSessionsLoaded;
    emit(current.copyWith(selectedTabIndex: event.tabIndex));
  }

  // ── Status update ─────────────────────────────────────────────────────────

  Future<void> _onStatusUpdate(
      PtSessionStatusUpdateRequested event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {
    if (state is! PtSessionsLoaded) return;
    final current = state as PtSessionsLoaded;

    emit(PtSessionActionLoading(
      sessionId:     event.sessionId,
      previousState: current,
    ));

    final result = await _updateStatus(
      sessionId: event.sessionId,
      status:    event.status,
    );

    if (result.failure != null || result.data == null) {
      emit(PtSessionActionError(
        message:       result.failure?.message ?? 'Failed to update session.',
        previousState: current,
      ));
      emit(current);
      return;
    }

    final updatedSessions = current.sessions.map((s) {
      if (s.ptSessionId == event.sessionId) return result.data!;
      return s;
    }).toList();

    final updatedState = current.copyWith(sessions: updatedSessions);

    emit(PtSessionActionSuccess(
      actionType:   event.status.toLowerCase(),
      updatedState: updatedState,
    ));
    emit(updatedState);
  }

  // ── Create session ────────────────────────────────────────────────────────

  Future<void> _onCreate(
      PtSessionCreateRequested event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {
    final current = state is PtSessionsLoaded
        ? state as PtSessionsLoaded
        : PtSessionsLoaded(
      sessions:    const [],
      stats:       PtSessionStatsEntity.empty,
      selectedDate: _selectedDate,
    );

    emit(PtSessionActionLoading(sessionId: -1, previousState: current));

    // FIX: use event.trainerId (may differ from _trainerId when admin creates
    // for a different trainer than currently viewed).
    final result = await _createSession(
      branchId:          event.branchId,
      trainerId:         event.trainerId,  // ← use event, not _trainerId
      userId:            event.userId,
      serviceId:         event.serviceId,
      memberPtPackageId: event.memberPtPackageId,
      startTime:         event.startTime,
      endTime:           event.endTime,
      notes:             event.notes,
    );

    if (result.failure != null || result.data == null) {
      emit(PtSessionActionError(
        message:       result.failure?.message ?? 'Failed to create session.',
        previousState: current,
      ));
      emit(current);
      return;
    }

    // Refresh the current view (same date, same trainer = _trainerId).
    await _loadForDate(
      emit,
      _selectedDate,
      tabIndex:   current.selectedTabIndex,
      actionType: 'created',
    );
  }

  // ── Private: load sessions + stats for a date ─────────────────────────────

  Future<void> _loadForDate(
      Emitter<TrainerPtSessionsState> emit,
      DateTime date, {
        int     tabIndex   = 0,
        String? actionType,
      }) async {
    emit(PtSessionsLoading());

    final results = await Future.wait([
      _getSessions(branchId: _branchId, trainerId: _trainerId, date: date),
      _getStats(branchId: _branchId, trainerId: _trainerId, date: date),
    ]);

    final sessionsResult = results[0] as ({dynamic data, dynamic failure});
    final statsResult    = results[1] as ({dynamic data, dynamic failure});

    if (sessionsResult.failure != null) {
      emit(PtSessionsError(
        sessionsResult.failure!.message ?? 'Failed to load sessions.',
      ));
      return;
    }

    final loadedState = PtSessionsLoaded(
      sessions:         sessionsResult.data ?? [],
      stats:            statsResult.data ?? PtSessionStatsEntity.empty,
      selectedDate:     date,
      selectedTabIndex: tabIndex,
    );

    if (actionType != null) {
      emit(PtSessionActionSuccess(
        actionType:   actionType,
        updatedState: loadedState,
      ));
    }

    emit(loadedState);
  }
}