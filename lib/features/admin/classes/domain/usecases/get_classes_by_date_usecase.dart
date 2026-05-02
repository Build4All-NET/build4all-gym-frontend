
// ── 1. GetClassesByDateUseCase ────────────────────────────────────────────────
// Called when: ClassesStarted or ClassesDateChanged is dispatched in the BLoC.
// Returns the list of class cards for a specific day.
import '../entities/admin_class_card_entity.dart';
import '../repositories/admin_classes_repository.dart';

class GetClassesByDateUseCase {
  final AdminClassesRepository _repository;
  GetClassesByDateUseCase(this._repository);

  Future<List<AdminClassCardEntity>> call(String? date, int? branchId) {
    return _repository.getClassesByDate(date, branchId);
  }
}
