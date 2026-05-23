import '../../domain/entities/book_session_result_entity.dart';
import '../../domain/entities/filter_option_item_entity.dart';
import '../../domain/entities/session_card_entity.dart';
import '../../domain/entities/session_detail_entity.dart';

abstract class SessionsState {
  const SessionsState();
}

class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

class SessionsLoading extends SessionsState {
  final DateTime selectedDate;

  const SessionsLoading({
    required this.selectedDate,
  });
}

class SessionsLoaded extends SessionsState {
  final List<SessionCardEntity> sessions;
  final DateTime selectedDate;
  final int? classTypeId;
  final int? trainerId;
  final String? branchId;

  const SessionsLoaded({
    required this.sessions,
    required this.selectedDate,
    this.classTypeId,
    this.trainerId,
    this.branchId,
  });
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);
}

class SessionBookingLoading extends SessionsState {
  const SessionBookingLoading();
}

class SessionBookingError extends SessionsState {
  final String message;

  const SessionBookingError(this.message);
}

class SessionBookingPaymentReady extends SessionsState {
  final BookSessionResultEntity result;
  final DateTime selectedDate;

  const SessionBookingPaymentReady({
    required this.result,
    required this.selectedDate,
  });
}

class SessionBookingDone extends SessionsState {
  final BookSessionResultEntity result;

  const SessionBookingDone(this.result);
}

class SessionsFilterOptionsLoaded extends SessionsState {
  final List<FilterOptionItemEntity> classTypes;
  final List<FilterOptionItemEntity> trainers;
  final List<FilterOptionItemEntity> branches;

  const SessionsFilterOptionsLoaded({
    required this.classTypes,
    required this.trainers,
    required this.branches,
  });
}

class SessionDetailLoading extends SessionsState {
  const SessionDetailLoading();
}

class SessionDetailLoaded extends SessionsState {
  final SessionDetailEntity session;

  const SessionDetailLoaded(this.session);
}

class SessionDetailError extends SessionsState {
  final String message;

  const SessionDetailError(this.message);
}