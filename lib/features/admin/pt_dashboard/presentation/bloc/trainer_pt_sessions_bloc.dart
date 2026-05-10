// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/bloc/trainer_pt_sessions_bloc.dart
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import 'trainer_pt_sessions_event.dart';
import 'trainer_pt_sessions_state.dart';

class TrainerPtSessionsBloc
    extends Bloc<TrainerPtSessionsEvent, TrainerPtSessionsState> {
  final GetSessionsByDateUseCase _getSessions;
  final GetSessionStatsUseCase _getStats;
  final CreateSessionUseCase _createSession;
  final UpdateSessionStatusUseCase _updateStatus;

  /// Persisted so post-action refreshes hit the correct date + branchId.
  DateTime _selectedDate = DateTime.now();
  late int _branchId;

  TrainerPtSessionsBloc({
    required GetSessionsByDateUseCase getSessions,
    required GetSessionStatsUseCase getStats,
    required CreateSessionUseCase createSession,
    required UpdateSessionStatusUseCase updateStatus,
  })  : _getSessions = getSessions,
        _getStats = getStats,
        _createSession = createSession,
        _updateStatus = updateStatus,
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
    _branchId = event.branchId;
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
        state is PtSessionsLoaded ? (state as PtSessionsLoaded).selectedTabIndex : 0;
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

  // ── Status update (Complete / Cancel / No-Show) ───────────────────────────

  Future<void> _onStatusUpdate(
    PtSessionStatusUpdateRequested event,
    Emitter<TrainerPtSessionsState> emit,
  ) async {
    if (state is! PtSessionsLoaded) return;
    final current = state as PtSessionsLoaded;

    emit(PtSessionActionLoading(
      sessionId: event.sessionId,
      previousState: current,
    ));

    final result = await _updateStatus(
      sessionId: event.sessionId,
      status: event.status,
    );

    if (result.failure != null || result.data == null) {
      emit(PtSessionActionError(
        message: result.failure?.message ?? 'Failed to update session.',
        previousState: current,
      ));
      emit(current);
      return;
    }

    // Replace the updated session in the list in-place.
    final updatedSessions = current.sessions.map((s) {
      if (s.ptSessionId == event.sessionId) return result.data!;
      return s;
    }).toList();

    final updatedState = current.copyWith(sessions: updatedSessions);

    emit(PtSessionActionSuccess(
      actionType: event.status.toLowerCase(),
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
            sessions: const [],
            stats: PtSessionStatsEntity.empty,
            selectedDate: _selectedDate,
          );

    emit(PtSessionActionLoading(sessionId: -1, previousState: current));

    final result = await _createSession(
      branchId:         event.branchId,
      userId:           event.userId,
      serviceId:        event.serviceId,
      memberPtPackageId: event.memberPtPackageId,
      startTime:        event.startTime,
      endTime:          event.endTime,
      notes:            event.notes,
    );

    if (result.failure != null || result.data == null) {
      emit(PtSessionActionError(
        message: result.failure?.message ?? 'Failed to create session.',
        previousState: current,
      ));
      emit(current);
      return;
    }

    // Append the new session and refresh stats.
    await _loadForDate(
      emit,
      _selectedDate,
      tabIndex: current.selectedTabIndex,
      actionType: 'created',
    );
  }

  // ── Private: load sessions + stats for a date ─────────────────────────────

  Future<void> _loadForDate(
    Emitter<TrainerPtSessionsState> emit,
    DateTime date, {
    int tabIndex = 0,
    String? actionType,
  }) async {
    emit(PtSessionsLoading());

    final results = await Future.wait([
      _getSessions(branchId: _branchId, date: date),
      _getStats(branchId: _branchId, date: date),
    ]);

    final sessionsResult = results[0] as ({dynamic data, dynamic failure});
    final statsResult = results[1] as ({dynamic data, dynamic failure});

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
        actionType: actionType,
        updatedState: loadedState,
      ));
    }

    emit(loadedState);
  }
}
