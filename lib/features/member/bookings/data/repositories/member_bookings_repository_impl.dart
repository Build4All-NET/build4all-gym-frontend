import '../../domain/entities/member_booking_entity.dart';
import '../../domain/repositories/member_bookings_repository.dart';
import '../models/member_booking_model.dart';
import '../services/member_bookings_service.dart';

/*
 * Repository implementation.
 *
 * Same style as SessionsRepositoryImpl:
 * - service returns models
 * - repository maps models to domain entities
 */
class MemberBookingsRepositoryImpl implements MemberBookingsRepository {
  final MemberBookingsService _service;

  MemberBookingsRepositoryImpl(this._service);

  @override
  Future<List<MemberBookingEntity>> getBookings({
    required String tab,
  }) async {
    final models = await _service.getBookings(tab: tab);

    return models.map(_toEntity).toList();
  }

  @override
  Future<void> requestClassCancel(int bookingId) {
    return _service.requestClassCancel(bookingId);
  }

  @override
  Future<void> requestPtCancel(int ptSessionId, {DateTime? requestedNewDate}) {
    return _service.requestPtCancel(ptSessionId, requestedNewDate: requestedNewDate);
  }

  MemberBookingEntity _toEntity(MemberBookingModel model) {
    return MemberBookingEntity(
      bookingType: model.bookingType,
      bookingId: model.bookingId,
      sessionId: model.sessionId,
      ptSessionId: model.ptSessionId,
      title: model.title,
      trainerName: model.trainerName,
      branchId: model.branchId,
      branchName: model.branchName,
      roomName: model.roomName,
      startTime: model.startTime,
      endTime: model.endTime,
      durationMinutes: model.durationMinutes,
      status: model.status,
      displayStatusKey: model.displayStatusKey,
      canRequestCancel: model.canRequestCancel,
      cancelRequestPending: model.cancelRequestPending,
      canReview: model.canReview,
      packageName: model.packageName,
      sessionIndex: model.sessionIndex,
      totalSessions: model.totalSessions,
    );
  }
  @override
  Future<void> submitClassReview({
    required int bookingId,
    required int rating,
    String? comment,
  }) {
    return _service.submitClassReview(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<void> submitPtReview({
    required int ptSessionId,
    required int rating,
    String? comment,
  }) {
    return _service.submitPtReview(
      ptSessionId: ptSessionId,
      rating: rating,
      comment: comment,
    );
  }
}