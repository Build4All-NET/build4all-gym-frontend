
// ── 3. CreateClassUseCase ─────────────────────────────────────────────────────
// Called when: ClassCreateRequested is dispatched (Save Class tapped in Add sheet).
// Returns the newly created sessionId.
import '../../data/models/create_class_request_model.dart';
import '../repositories/admin_classes_repository.dart';

class CreateClassUseCase {
  final AdminClassesRepository _repository;
  CreateClassUseCase(this._repository);

  Future<int> call(CreateClassRequestModel request) {
    return _repository.createClass(request);
  }
}