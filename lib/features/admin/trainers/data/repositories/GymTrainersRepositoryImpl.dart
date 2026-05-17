// FILE: lib/features/admin/trainers/data/repositories/gym_trainers_repository_impl.dart

import '../../domain/entities/GymTrainerEntity.dart';
import '../../domain/repositories/GymTrainersRepository.dart';
import '../services/GymTrainersService.dart';

class GymTrainersRepositoryImpl implements GymTrainersRepository {
  final GymTrainersService _service;
  const GymTrainersRepositoryImpl(this._service);

  @override
  Future<List<GymTrainerEntity>> getGymTrainers() async {
    final models = await _service.fetchGymTrainers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> removeGymTrainer(int userId) =>
      _service.removeGymTrainer(userId);
}