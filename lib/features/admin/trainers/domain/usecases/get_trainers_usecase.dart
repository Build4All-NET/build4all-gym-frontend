// get_trainers_usecase.dart
import '../entities/admin_trainer_card_entity.dart';
import '../repositories/admin_trainers_repository.dart';
class GetTrainersUseCase {
  final AdminTrainersRepository repository;
  GetTrainersUseCase(this.repository);

  Future<List<AdminTrainerCardEntity>> call({
    int? branchId, String? search, String? specialtyFilter}) =>
      repository.getTrainers(
          branchId: branchId,
          search: search,
          specialtyFilter: specialtyFilter);
}
