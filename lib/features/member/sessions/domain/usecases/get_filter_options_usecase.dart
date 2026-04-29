import '../entities/filter_option_item_entity.dart';
import '../repositories/sessions_repository.dart';

class GetFilterOptionsUseCase {
  final SessionsRepository repository;

  GetFilterOptionsUseCase(this.repository);

  Future<({
  List<FilterOptionItemEntity> classTypes,
  List<FilterOptionItemEntity> trainers,
  List<FilterOptionItemEntity> branches,
  })> call() {
    return repository.getFilterOptions();
  }
}