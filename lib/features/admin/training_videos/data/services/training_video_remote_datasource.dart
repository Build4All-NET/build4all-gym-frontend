
import 'package:dio/dio.dart';

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
  Future<List<TrainerOption>> getTrainers();
  Future<VideoCategoryModel> createCategory(String name); // ✅ new
}

class TrainingVideoRemoteDataSourceImpl implements TrainingVideoRemoteDataSource {
  Dio get _dio => dio();

  @override
  Future<VideoCategoryModel> createCategory(String name) async {
    final response = await _dio.post(
      '/api/admin/training-videos/categories',
      data: {'name': name},
    );
    return VideoCategoryModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<TrainerOption>> getTrainers() async {
    final response = await _dio.get('/api/admin/trainers');
    final data = response.data as Map<String, dynamic>;
    final list = data['trainers'] as List<dynamic>;
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return TrainerOption(
        trainerId: m['trainerId'] as int,
        name: m['fullName'] as String? ?? 'Trainer ${m['trainerId']}',
      );
    }).toList();
  }

  @override
  Future<({VideoStatsModel stats, List<TrainingVideoModel> videos})> getVideos({int? categoryId}) async {
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
    final formData = FormData.fromMap({
      ...request.toMultipart(),

      if (request.videoFile != null)
        'video': await MultipartFile.fromFile(
          request.videoFile!.path,
          filename: request.videoFile!.path.split('/').last,
        ),
    });

    await _dio.post(
      '/api/admin/training-videos',
      data: formData,
    );
  }
}