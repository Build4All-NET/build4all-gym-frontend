// FILE: lib/features/admin/trainers/domain/repositories/gym_trainers_repository.dart

import '../entities/GymTrainerEntity.dart';

abstract class GymTrainersRepository {
  Future<List<GymTrainerEntity>> getGymTrainers();
  Future<void> removeGymTrainer(int userId);   // sets role back to MEMBER
}