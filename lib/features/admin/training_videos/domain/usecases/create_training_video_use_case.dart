import '../../data/models/create_training_video_request.dart';
import '../repositories/training_video_repository.dart';

class CreateTrainingVideoUseCase {
  final TrainingVideoRepository repository;
  CreateTrainingVideoUseCase(this.repository);

  Future<void> call(CreateTrainingVideoRequest request) =>
      repository.createVideo(request);
}