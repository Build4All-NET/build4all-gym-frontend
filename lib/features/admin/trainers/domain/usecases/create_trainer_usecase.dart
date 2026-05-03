// create_trainer_usecase.dart
import '../../data/models/create_trainer_request_model.dart';
import '../repositories/admin_trainers_repository.dart';
class CreateTrainerUseCase {
  final AdminTrainersRepository repository;
  CreateTrainerUseCase(this.repository);

  Future<int> call(CreateTrainerRequestModel request) =>
      repository.createTrainer(request);
}