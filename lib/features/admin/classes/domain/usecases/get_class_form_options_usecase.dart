
// ── 2. GetClassFormOptionsUseCase ─────────────────────────────────────────────
// Called when: ClassFormOptionsRequested is dispatched (Add/Edit sheet opens).
// Returns all three dropdown lists in one call.
import '../entities/class_form_option_item_entity.dart';
import '../repositories/admin_classes_repository.dart';

class GetClassFormOptionsUseCase {
  final AdminClassesRepository _repository;
  GetClassFormOptionsUseCase(this._repository);

  Future<ClassFormOptionsEntity> call(int? branchId) {
    return _repository.getClassFormOptions(branchId);
  }
}
