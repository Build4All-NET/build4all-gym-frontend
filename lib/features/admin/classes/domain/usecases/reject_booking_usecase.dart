import '../repositories/admin_classes_repository.dart';

class RejectBookingUseCase {
  final AdminClassesRepository _repository;

  RejectBookingUseCase(this._repository);

  Future<void> call(int bookingId) => _repository.rejectBooking(bookingId);
}
