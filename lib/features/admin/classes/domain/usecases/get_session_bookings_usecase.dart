
// ── 6. GetSessionBookingsUseCase ──────────────────────────────────────────────
// Called when: SessionBookingsRequested is dispatched (Bookings button tapped).
// Returns all BOOKED + WAITLISTED members for that session.
import '../entities/session_booking_item_entity.dart';
import '../repositories/admin_classes_repository.dart';

class GetSessionBookingsUseCase {
  final AdminClassesRepository _repository;
  GetSessionBookingsUseCase(this._repository);

  Future<List<SessionBookingItemEntity>> call(int sessionId) {
    return _repository.getSessionBookings(sessionId);
  }
}
