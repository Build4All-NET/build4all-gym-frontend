import '../../domain/entities/training_video_entity.dart';
import '../../domain/entities/video_stats_entity.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/repositories/training_video_repository.dart';
import '../models/create_training_video_request.dart';
import '../../domain/entities/trainer_option.dart';
import '../services/training_video_remote_datasource.dart';

class TrainingVideoRepositoryImpl implements TrainingVideoRepository {
  final TrainingVideoRemoteDataSource remoteDataSource;
  TrainingVideoRepositoryImpl(this.remoteDataSource);

  @override
  Future<(VideoStatsEntity, List<TrainingVideoEntity>)> getVideos({int? categoryId}) async {
    final result = await remoteDataSource.getVideos(categoryId: categoryId);
    return (result.stats, result.videos);
  }

  @override
  Future<List<VideoCategoryEntity>> getCategories() =>
      remoteDataSource.getCategories();

  @override
  Future<void> createVideo(CreateTrainingVideoRequest request) =>
      remoteDataSource.createVideo(request);
  @override
  Future<List<TrainerOption>> getTrainers() =>
      remoteDataSource.getTrainers();
}