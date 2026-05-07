import '../entities/training_video_entity.dart';
import '../entities/video_stats_entity.dart';
import '../repositories/training_video_repository.dart';

class GetTrainingVideosUseCase {
  final TrainingVideoRepository repository;
  GetTrainingVideosUseCase(this.repository);

  Future<(VideoStatsEntity, List<TrainingVideoEntity>)> call({int? categoryId}) =>
      repository.getVideos(categoryId: categoryId);
}