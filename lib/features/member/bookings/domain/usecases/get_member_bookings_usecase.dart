import '../entities/member_booking_entity.dart';
import '../repositories/member_bookings_repository.dart';

/*
 * Use case for loading member bookings.
 *
 * tab:
 * - UPCOMING
 * - PREVIOUS
 */
class GetMemberBookingsUseCase {
  final MemberBookingsRepository repository;

  GetMemberBookingsUseCase(this.repository);

  Future<List<MemberBookingEntity>> call({
    required String tab,
  }) {
    return repository.getBookings(tab: tab);
  }
}