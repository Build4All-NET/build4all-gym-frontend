
// ── 4. UpdateClassUseCase ─────────────────────────────────────────────────────
// Called when: ClassUpdateRequested is dispatched (Save Class tapped in Edit sheet).
import '../../data/models/update_class_request_model.dart';
import '../repositories/admin_classes_repository.dart';

class UpdateClassUseCase {
  final AdminClassesRepository _repository;
  UpdateClassUseCase(this._repository);

  Future<void> call(int sessionId, UpdateClassRequestModel request) {
    return _repository.updateClass(sessionId, request);
  }
}
