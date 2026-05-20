import '../../data/models/update_training_video_request.dart';
import '../entities/training_video_entity.dart';
import '../repositories/training_video_repository.dart';

class UpdateTrainingVideoUseCase {
  final TrainingVideoRepository repository;
  UpdateTrainingVideoUseCase(this.repository);

  Future<TrainingVideoEntity> call(UpdateTrainingVideoRequest request) =>
      repository.updateVideo(request);
}
