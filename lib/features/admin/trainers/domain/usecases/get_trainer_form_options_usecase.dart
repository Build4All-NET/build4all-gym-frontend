// get_trainer_form_options_usecase.dart
import '../entities/trainer_form_options_entity.dart';
import '../repositories/admin_trainers_repository.dart';
class GetTrainerFormOptionsUseCase {
  final AdminTrainersRepository repository;
  GetTrainerFormOptionsUseCase(this.repository);

  Future<TrainerFormOptionsEntity> call() => repository.getFormOptions();
}