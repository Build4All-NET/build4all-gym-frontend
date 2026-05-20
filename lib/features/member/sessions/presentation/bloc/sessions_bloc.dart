import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/book_session_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../domain/usecases/get_session_detail_use_case.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import 'sessions_event.dart';
import 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final GetSessionsUseCase? getSessionsUseCase;
  final GetFilterOptionsUseCase? getFilterOptionsUseCase;
  final BookSessionUseCase? bookSessionUseCase;
  final CancelBookingUseCase? cancelBookingUseCase;
  final GetSessionDetailUseCase? getSessionDetailUseCase;

  DateTime _selectedDate = DateTime.now();
  int? _classTypeId;
  int? _trainerId;
  String? _branchId;

  SessionsBloc({
    this.getSessionsUseCase,
    this.bookSessionUseCase,
    this.cancelBookingUseCase,
    this.getFilterOptionsUseCase,
    this.getSessionDetailUseCase,
  }) : super(const SessionsInitial()) {
    on<SessionsStarted>(_onStarted);
    on<SessionsDateChanged>(_onDateChanged);
    on<SessionsFilterApplied>(_onFilterApplied);
    on<SessionsFilterReset>(_onFilterReset);
    on<SessionBookRequested>(_onBookRequested);
    on<SessionBookingCancelRequested>(_onCancelRequested);
    on<SessionsFilterOptionsRequested>(_onFilterOptionsRequested);
    on<SessionDetailRequested>(_onSessionDetailRequested);
  }

  Future<void> _onStarted(
      SessionsStarted event,
      Emitter<SessionsState> emit,
      ) async {
    await _loadSessions(emit);
  }

  Future<void> _onDateChanged(
      SessionsDateChanged event,
      Emitter<SessionsState> emit,
      ) async {
    _selectedDate = event.date;
    await _loadSessions(emit);
  }

  Future<void> _onFilterApplied(
      SessionsFilterApplied event,
      Emitter<SessionsState> emit,
      ) async {
    _classTypeId = event.classTypeId;
    _trainerId = event.trainerId;
    _branchId = event.branchId;

    await _loadSessions(emit);
  }

  Future<void> _onFilterReset(
      SessionsFilterReset event,
      Emitter<SessionsState> emit,
      ) async {
    _classTypeId = null;
    _trainerId = null;
    _branchId = null;

    await _loadSessions(emit);
  }

  Future<void> _onBookRequested(
      SessionBookRequested event,
      Emitter<SessionsState> emit,
      ) async {
    emit(const SessionBookingLoading());

    try {
      if (bookSessionUseCase != null) {
        final result = await bookSessionUseCase!(
          event.sessionId,
          paymentMethod: event.paymentMethod,
        );

        if ((result.isStripe || result.isRedirect) && result.transactionId != null) {
          emit(SessionBookingPaymentReady(
            result: result,
            selectedDate: _selectedDate,
          ));
          return;
        }

        emit(SessionBookingDone(result));
      }

      await _loadSessions(emit);
    } catch (e) {
      emit(SessionBookingError(e.toString()));
    }
  }

  Future<void> _onCancelRequested(
      SessionBookingCancelRequested event,
      Emitter<SessionsState> emit,
      ) async {
    emit(const SessionBookingLoading());

    try {
      if (cancelBookingUseCase != null) {
        await cancelBookingUseCase!(event.bookingId);
      }

      await _loadSessions(emit);
    } catch (_) {
      emit(const SessionBookingError('Failed to cancel booking'));
    }
  }

  Future<void> _onFilterOptionsRequested(
      SessionsFilterOptionsRequested event,
      Emitter<SessionsState> emit,
      ) async {
    if (getFilterOptionsUseCase == null) {
      emit(
        const SessionsFilterOptionsLoaded(
          classTypes: [],
          trainers: [],
          branches: [],
        ),
      );
      return;
    }

    final options = await getFilterOptionsUseCase!();

    emit(
      SessionsFilterOptionsLoaded(
        classTypes: options.classTypes,
        trainers: options.trainers,
        branches: options.branches,
      ),
    );
  }

  Future<void> _onSessionDetailRequested(
      SessionDetailRequested event,
      Emitter<SessionsState> emit,
      ) async {
    emit(const SessionDetailLoading());

    try {
      if (getSessionDetailUseCase == null) {
        emit(const SessionDetailError('Service unavailable'));
        return;
      }

      final session = await getSessionDetailUseCase!(event.sessionId);

      print('BLOC SESSION DETAIL LOADED: ${session.className}');

      emit(SessionDetailLoaded(session));
    } catch (e, s) {
      print('BLOC SESSION DETAIL ERROR: $e');
      print('STACKTRACE: $s');

      emit(SessionDetailError(e.toString()));
    }
  }

  Future<void> _loadSessions(Emitter<SessionsState> emit) async {
    emit(SessionsLoading(selectedDate: _selectedDate));

    try {
      if (getSessionsUseCase == null) {
        emit(
          SessionsLoaded(
            sessions: const [],
            selectedDate: _selectedDate,
            classTypeId: _classTypeId,
            trainerId: _trainerId,
            branchId: _branchId,
          ),
        );
        return;
      }

      final sessions = await getSessionsUseCase!(
        date: _selectedDate,
        classTypeId: _classTypeId,
        trainerId: _trainerId,
        branchId: _branchId,
      );

      emit(
        SessionsLoaded(
          sessions: sessions,
          selectedDate: _selectedDate,
          classTypeId: _classTypeId,
          trainerId: _trainerId,
          branchId: _branchId,
        ),
      );
    } catch (_) {
      emit(const SessionsError('Failed to load services'));
    }
  }
}