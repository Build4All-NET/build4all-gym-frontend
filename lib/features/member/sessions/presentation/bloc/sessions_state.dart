import '../../domain/entities/book_session_result_entity.dart';
import '../../domain/entities/session_card_entity.dart';
import '../../domain/entities/filter_option_item_entity.dart';

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

class SessionBookingSuccess extends SessionsState {
  final BookSessionResultEntity result;

  const SessionBookingSuccess(this.result);
}

class SessionBookingError extends SessionsState {
  final String message;

  const SessionBookingError(this.message);
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