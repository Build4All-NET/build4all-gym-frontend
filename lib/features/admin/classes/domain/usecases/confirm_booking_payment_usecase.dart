import '../repositories/admin_classes_repository.dart';

class ConfirmBookingPaymentUseCase {
  final AdminClassesRepository _repository;

  ConfirmBookingPaymentUseCase(this._repository);

  Future<void> call(int bookingId) => _repository.confirmBookingPayment(bookingId);
}
