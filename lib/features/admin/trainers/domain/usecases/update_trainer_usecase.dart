// update_trainer_usecase.dart
import '../../data/models/update_trainer_request_model.dart';
import '../repositories/admin_trainers_repository.dart';

class UpdateTrainerUseCase {
  final AdminTrainersRepository repository;
  UpdateTrainerUseCase(this.repository);

  Future<void> call(int trainerId, UpdateTrainerRequestModel request) =>
      repository.updateTrainer(trainerId, request);
}