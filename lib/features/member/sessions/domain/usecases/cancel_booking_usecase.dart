import '../repositories/sessions_repository.dart';

class CancelBookingUseCase {
  final SessionsRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> call(int bookingId) {
    return repository.cancelBooking(bookingId);
  }
}