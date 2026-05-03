import '../entities/AdminTrainerDetailEntity.dart';
import '../repositories/admin_trainers_repository.dart';

class GetTrainerDetailUseCase {
  final AdminTrainersRepository repository;
  GetTrainerDetailUseCase(this.repository);

  Future<AdminTrainerDetailEntity> call(int trainerId) =>
      repository.getTrainerDetail(trainerId);
}
