
// ── 5. CancelClassUseCase ─────────────────────────────────────────────────────
// Called when: ClassCancelRequested is dispatched (Cancel confirmed in dialog).
import '../../data/models/cancel_class_request_model.dart';
import '../repositories/admin_classes_repository.dart';

class CancelClassUseCase {
  final AdminClassesRepository _repository;
  CancelClassUseCase(this._repository);

  Future<void> call(int sessionId, CancelClassRequestModel request) {
    return _repository.cancelClass(sessionId, request);
  }
}