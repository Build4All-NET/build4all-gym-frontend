// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_bloc.dart
//
// FIXES APPLIED:
//   1. Fixed incompatible action states
//   2. Fixed selectedTabIndex null issue
//   3. Fixed dangerous tuple casts
//   4. Fixed nullable DateTime sorting
//   5. Fixed error state emission
//   6. Improved session update merge logic
//   7. Added stable sorting for null start times
//   8. Fixed all-trainers mode to properly merge sessions and stats
// =============================================================================

import 'package:build4allgym/features/admin/pt_dashboard/presentation/bloc/trainer_pt_sessions_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pt_session_entity.dart';
import '../../domain/entities/pt_session_stats_entity.dart';
import '../../domain/usecases/trainer_pt_sessions_usecases.dart';

part 'trainer_pt_sessions_state.dart';

class TrainerPtSessionsBloc
    extends Bloc<TrainerPtSessionsEvent, TrainerPtSessionsState> {

  final GetSessionsByDateUseCase _getSessions;
  final GetSessionStatsUseCase _getStats;
  final CreateSessionUseCase _createSession;
  final UpdateSessionStatusUseCase _updateStatus;

  DateTime _selectedDate = DateTime.now();

  int _branchId = 1;

  /// 0 = admin all-trainers mode
  int _trainerId = 0;

  /// trainerId -> trainerName
  Map<int, String> _trainerNames = {};

  bool get _isAllTrainersMode =>
      _trainerId == 0 && _trainerNames.isNotEmpty;

  int get currentBranchId => _branchId;

  int get currentTrainerId => _trainerId;

  TrainerPtSessionsBloc({
    required GetSessionsByDateUseCase getSessions,
    required GetSessionStatsUseCase getStats,
    required CreateSessionUseCase createSession,
    required UpdateSessionStatusUseCase updateStatus,
  })  : _getSessions = getSessions,
        _getStats = getStats,
        _createSession = createSession,
        _updateStatus = updateStatus,
        super(const PtSessionsInitial()) {

    on<PtSessionsStarted>(_onStarted);
    on<PtSessionsDateChanged>(_onDateChanged);
    on<PtSessionsTabChanged>(_onTabChanged);
    on<PtSessionStatusUpdateRequested>(_onStatusUpdate);
    on<PtSessionCreateRequested>(_onCreate);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Initial load
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onStarted(
      PtSessionsStarted event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {

    _branchId = event.branchId;
    _trainerId = event.trainerId;
    _trainerNames = event.trainerNames;
    _selectedDate = DateTime.now();

    await _loadForDate(emit, _selectedDate);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Date changed
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onDateChanged(
      PtSessionsDateChanged event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {

    _selectedDate = event.date;

    final prevTab = state is PtSessionsLoaded
        ? (state as PtSessionsLoaded).selectedTabIndex
        : 0;

    await _loadForDate(
      emit,
      _selectedDate,
      tabIndex: prevTab,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Tab changed
  // ───────────────────────────────────────────────────────────────────────────

  void _onTabChanged(
      PtSessionsTabChanged event,
      Emitter<TrainerPtSessionsState> emit,
      ) {

    if (state is! PtSessionsLoaded) return;

    final current = state as PtSessionsLoaded;

    emit(
      current.copyWith(
        selectedTabIndex: event.tabIndex,
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Status update
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onStatusUpdate(
      PtSessionStatusUpdateRequested event,
      Emitter<TrainerPtSessionsState> emit,
      ) async {

    if (state is! PtSessionsLoaded) return;

    final current = state as PtSessionsLoaded;

    emit(
      PtSessionActionLoading(
        sessionId: event.sessionId,
        previousState: current,
      ),
    );

    final result = await _updateStatus(
      sessionId: event.sessionId,
      status: event.status,
    );

    if (result.failure != null || result.data == null) {

      emit(
        PtSessionActionError(
          message:
          result.failure?.message ??
              'Failed to update session.',
          previousState: current,
        ),
      );

      emit(current);
      return;
    }

    final updatedSessions = current.sessions.map((session) {

      if (session.ptSessionId == event.sessionId) {
        return result.data!;
      }

      return session;

    }).toList();

    final updatedState = current.copyWith(
      sessions: updatedSessions,
    );

    emit(
      PtSessionActionSuccess(
        actionType: event.status.toLowerCase(),
        updatedState: updatedState,
      ),
    );

    emit(updatedState);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Create session
  // ───────────────────────────────────────────────────────────────────────────

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
      selectedTabIndex: 0,
    );

    emit(
      PtSessionActionLoading(
        sessionId: -1,
        previousState: current,
      ),
    );

    final result = await _createSession(
      branchId: event.branchId,
      trainerId: event.trainerId,
      userId: event.userId,
      serviceId: event.serviceId,
      memberPtPackageId: event.memberPtPackageId,
      startTime: event.startTime,
      endTime: event.endTime,
      notes: event.notes,
    );

    if (result.failure != null || result.data == null) {

      emit(
        PtSessionActionError(
          message:
          result.failure?.message ??
              'Failed to create session.',
          previousState: current,
        ),
      );

      emit(current);
      return;
    }

    await _loadForDate(
      emit,
      _selectedDate,
      tabIndex: current.selectedTabIndex,
      actionType: 'created',
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Core fetch
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _loadForDate(
      Emitter<TrainerPtSessionsState> emit,
      DateTime date, {
        int tabIndex = 0,
        String? actionType,
      }) async {

    emit(const PtSessionsLoading());

    try {

      List<PtSessionEntity> sessions;
      PtSessionStatsEntity stats;

      // =========================================================================
      // ALL TRAINERS MODE
      // =========================================================================

      if (_isAllTrainersMode) {

        final trainerIds = _trainerNames.keys.toList();

        final sessionResults = await Future.wait(
          trainerIds.map(
                (trainerId) => _getSessions(
              branchId: _branchId,
              trainerId: trainerId,
              date: date,
            ),
          ),
        );

        final statsResults = await Future.wait(
          trainerIds.map(
                (trainerId) => _getStats(
              branchId: _branchId,
              trainerId: trainerId,
              date: date,
            ),
          ),
        );

        sessions = [];

        for (int i = 0; i < trainerIds.length; i++) {

          final result = sessionResults[i];

          if (result.failure != null) {
            continue;
          }

          final trainerId = trainerIds[i];

          final trainerName =
              _trainerNames[trainerId] ?? '';

          final fetchedSessions =
              result.data ?? <PtSessionEntity>[];

          for (final session in fetchedSessions) {

            sessions.add(

              session.trainerName != null &&
                  session.trainerName!.isNotEmpty

                  ? session

                  : session.copyWith(
                trainerId: trainerId,
                trainerName: trainerName,
              ),
            );
          }
        }

        // Stable sorting
        sessions.sort((a, b) {

          final aTime = a.startTime;
          final bTime = b.startTime;

          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;

          return aTime.compareTo(bTime);
        });

        int total = 0;
        int completed = 0;
        int scheduled = 0;

        for (final result in statsResults) {

          final data = result.data;

          if (data == null) continue;

          total += data.total;
          completed += data.completed;
          scheduled += data.scheduled;
        }

        stats = PtSessionStatsEntity(
          total: total,
          completed: completed,
          scheduled: scheduled,
        );
      }

      // =========================================================================
      // SINGLE TRAINER MODE
      // =========================================================================

      else {

        final results = await Future.wait<dynamic>([

          _getSessions(
            branchId: _branchId,
            trainerId: _trainerId,
            date: date,
          ),

          _getStats(
            branchId: _branchId,
            trainerId: _trainerId,
            date: date,
          ),
        ]);

        final sessionsResult = results[0];
        final statsResult = results[1];

        if (sessionsResult.failure != null) {

          emit(
            PtSessionsError(
              message:
              sessionsResult.failure!.message ??
                  'Failed to load sessions.',
            ),
          );

          return;
        }

        sessions = List<PtSessionEntity>.from(
          sessionsResult.data ?? [],
        );

        stats =
            statsResult.data ??
                PtSessionStatsEntity.empty;
      }

      final loadedState = PtSessionsLoaded(
        sessions: sessions,
        stats: stats,
        selectedDate: date,
        selectedTabIndex: tabIndex,
      );

      if (actionType != null) {

        emit(
          PtSessionActionSuccess(
            actionType: actionType,
            updatedState: loadedState,
          ),
        );
      }

      emit(loadedState);

    } catch (e) {

      emit(
        PtSessionsError(
          message: e.toString(),
        ),
      );
    }
  }
}