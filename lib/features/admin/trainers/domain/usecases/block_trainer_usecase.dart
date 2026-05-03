// block_trainer_usecase.dart
import '../repositories/admin_trainers_repository.dart';

class BlockTrainerUseCase {
  final AdminTrainersRepository repository;
  BlockTrainerUseCase(this.repository);

  Future<String> call(int trainerId) => repository.blockTrainer(trainerId);
}