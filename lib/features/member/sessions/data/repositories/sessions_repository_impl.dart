import '../../domain/entities/book_session_result_entity.dart';
import '../../domain/entities/filter_option_item_entity.dart';
import '../../domain/entities/session_card_entity.dart';
import '../../domain/repositories/sessions_repository.dart';
import '../services/sessions_service.dart';
import '../../domain/entities/session_detail_entity.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsService _service;

  SessionsRepositoryImpl(this._service);

  @override
  Future<List<SessionCardEntity>> getSessions({
    required DateTime date,
    int? classTypeId,
    int? trainerId,
    String? branchId,
  }) async {
    final models = await _service.getSessions(
      date: date,
      classTypeId: classTypeId,
      trainerId: trainerId,
      branchId: branchId,
    );

    return models.map((m) => SessionCardEntity(
      sessionId: m.sessionId,
      className: m.className,
      trainerName: m.trainerName,
      roomName: m.roomName,
      startTime: m.startTime,
      durationMinutes: m.durationMinutes,
      price: m.price,
      difficultyLevel: m.difficultyLevel,
      availableSeats: m.availableSeats,
      totalCapacity: m.totalCapacity,
      memberBookingStatus: m.memberBookingStatus,
      imageFileId: m.imageFileId,
    )).toList();
  }

  @override
  Future<({
  List<FilterOptionItemEntity> classTypes,
  List<FilterOptionItemEntity> trainers,
  List<FilterOptionItemEntity> branches,
  })> getFilterOptions() async {
    final model = await _service.getFilterOptions();

    return (
    classTypes: model.classTypes.map((e) => FilterOptionItemEntity(id: e.id, name: e.name)).toList(),
    trainers: model.trainers.map((e) => FilterOptionItemEntity(id: e.id, name: e.name)).toList(),
    branches: model.branches.map((e) => FilterOptionItemEntity(id: e.id, name: e.name)).toList(),
    );
  }

  @override
  Future<BookSessionResultEntity> bookSession(int sessionId) async {
    final model = await _service.bookSession(sessionId);

    return BookSessionResultEntity(
      bookingId: model.bookingId,
      status: model.status,
      waitlistPosition: model.waitlistPosition,
    );
  }

  @override
  Future<void> cancelBooking(int bookingId) {
    return _service.cancelBooking(bookingId);
  }
  @override
  Future<SessionDetailEntity> getSessionDetail(int sessionId) async {
    try {
      final model = await _service.getSessionDetail(sessionId);

      return SessionDetailEntity(
        sessionId: model.sessionId,
        classTypeId: model.classTypeId,
        trainerId: model.trainerId,
        className: model.className,
        trainerName: model.trainerName,
        trainerProfileFileId: model.trainerProfileFileId,
        trainerRating: model.trainerRating,
        difficultyLevel: model.difficultyLevel,
        price: model.price,
        startTime: model.startTime,
        endTime: model.endTime,
        roomName: model.roomName,
        availableSeats: model.availableSeats,
        memberBookingStatus: model.memberBookingStatus,
        description: model.description,
        benefits: model.benefits,
        equipment: model.equipment,
      );
    } catch (e) {
      throw Exception('Failed to load session detail');
    }
  }
}