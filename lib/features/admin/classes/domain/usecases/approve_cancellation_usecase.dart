import '../repositories/admin_classes_repository.dart';

class ApproveCancellationUseCase {
  final AdminClassesRepository _repository;

  ApproveCancellationUseCase(this._repository);

  Future<void> call(int bookingId) => _repository.approveCancellation(bookingId);
}