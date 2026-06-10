import '../repositories/training_video_repository.dart';

class DeleteVideoUseCase {
  final TrainingVideoRepository repository;
  DeleteVideoUseCase(this.repository);

  Future<void> call(int videoId) => repository.deleteVideo(videoId);
}
