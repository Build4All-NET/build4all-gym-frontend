// FILE: lib/features/admin/trainers/domain/usecases/gym_trainers_usecases.dart

import '../entities/GymTrainerEntity.dart';
import '../repositories/GymTrainersRepository.dart';

class GetGymTrainersUseCase {
  final GymTrainersRepository _repository;
  const GetGymTrainersUseCase(this._repository);
  Future<List<GymTrainerEntity>> call() => _repository.getGymTrainers();
}

class RemoveGymTrainerUseCase {
  final GymTrainersRepository _repository;
  const RemoveGymTrainerUseCase(this._repository);
  Future<void> call(int userId) => _repository.removeGymTrainer(userId);
}