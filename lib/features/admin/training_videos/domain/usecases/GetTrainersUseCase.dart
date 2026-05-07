import '../entities/trainer_option.dart';
import '../repositories/training_video_repository.dart';

class GetTrainersUseCase {
  final TrainingVideoRepository repository;
  GetTrainersUseCase(this.repository);

  Future<List<TrainerOption>> call() => repository.getTrainers(); // ✅ already clean
}