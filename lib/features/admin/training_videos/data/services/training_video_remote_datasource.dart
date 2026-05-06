
import '../../domain/entities/trainer_option.dart';
import '../models/training_video_model.dart';
import '../models/video_stats_model.dart';
import '../models/video_category_model.dart';
import '../models/create_training_video_request.dart';
import '../../../../../../core/network/globals.dart';

abstract class TrainingVideoRemoteDataSource {
  Future<({VideoStatsModel stats, List<TrainingVideoModel> videos})> getVideos({int? categoryId});
  Future<List<VideoCategoryModel>> getCategories();
  Future<void> createVideo(CreateTrainingVideoRequest request);
  Future<List<TrainerOption>> getTrainers(); // ✅ new
}

class TrainingVideoRemoteDataSourceImpl implements TrainingVideoRemoteDataSource {
  final _dio = dio();



  @override
  Future<List<TrainerOption>> getTrainers() async {
    final response = await _dio.get('/api/admin/trainers');
    final list = response.data as List<dynamic>;
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      // adjust field names to match your actual trainer API response
      final firstName = m['firstName'] as String? ?? '';
      final lastName  = m['lastName']  as String? ?? '';
      return TrainerOption(
        trainerId: m['trainerId'] as int,
        name: '$firstName $lastName'.trim(),
      );
    }).toList();
  }

  @override
  Future<({VideoStatsModel stats, List<TrainingVideoModel> videos})> getVideos({
    int? categoryId,
  }) async {
    final response = await _dio.get(
      '/api/admin/training-videos',
      queryParameters: categoryId != null ? {'categoryId': categoryId} : null,
    );
    final data = response.data as Map<String, dynamic>;
    return (
    stats: VideoStatsModel.fromJson(data['stats'] as Map<String, dynamic>),
    videos: (data['videos'] as List<dynamic>)
        .map((e) => TrainingVideoModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }

  @override
  Future<List<VideoCategoryModel>> getCategories() async {
    final response = await _dio.get('/api/admin/training-videos/categories');
    return (response.data as List<dynamic>)
        .map((e) => VideoCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createVideo(CreateTrainingVideoRequest request) async {
    await _dio.post('/api/admin/training-videos', data: request.toJson());
  }
}