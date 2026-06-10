import '../entities/trainer_option.dart';
import '../entities/training_video_entity.dart';
import '../entities/video_stats_entity.dart';
import '../entities/video_category_entity.dart';
import '../../data/models/create_training_video_request.dart';
import '../../data/models/update_training_video_request.dart';

abstract class TrainingVideoRepository {
  Future<(VideoStatsEntity, List<TrainingVideoEntity>)> getVideos({int? categoryId});
  Future<List<VideoCategoryEntity>> getCategories();
  Future<void> createVideo(CreateTrainingVideoRequest request);
  Future<TrainingVideoEntity> updateVideo(UpdateTrainingVideoRequest request);
  Future<void> deleteVideo(int videoId);
  Future<List<TrainerOption>> getTrainers();
  Future<VideoCategoryEntity> createCategory(String name);
}