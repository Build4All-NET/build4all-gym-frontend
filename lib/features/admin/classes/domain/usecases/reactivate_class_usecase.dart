import '../repositories/admin_classes_repository.dart';

class ReactivateClassUseCase {
  final AdminClassesRepository _repository;
  ReactivateClassUseCase(this._repository);

  Future<void> call(int sessionId) => _repository.reactivateClass(sessionId);
}
