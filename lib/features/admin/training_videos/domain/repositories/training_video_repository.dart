import '../../../../member/pt/domain/entities/trainer_list_response_entity.dart';
import '../entities/trainer_option.dart';
import '../entities/training_video_entity.dart';
import '../entities/video_stats_entity.dart';
import '../entities/video_category_entity.dart';
import '../../data/models/create_training_video_request.dart';
import '../../../../../core/error/failures.dart';

abstract class TrainingVideoRepository {
  Future<(VideoStatsEntity, List<TrainingVideoEntity>)> getVideos({int? categoryId});
  Future<List<VideoCategoryEntity>> getCategories();
  Future<void> createVideo(CreateTrainingVideoRequest request);
  Future<List<TrainerOption>> getTrainers(); }

