import '../repositories/admin_classes_repository.dart';

class DeclineCancellationUseCase {
  final AdminClassesRepository _repository;

  DeclineCancellationUseCase(this._repository);

  Future<void> call(int bookingId) => _repository.declineCancellation(bookingId);
}