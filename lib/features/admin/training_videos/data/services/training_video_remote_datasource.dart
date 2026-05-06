// features/admin/training_videos/data/datasources/training_video_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/exceptions/network_exception.dart';
import '../models/training_video_model.dart';

// ── What is a Remote DataSource? ─────────────────────────────────────────────
// The only file that makes actual HTTP calls for this feature.
// It takes raw JSON from the API and returns typed Model objects.
// It knows NOTHING about domain entities, use cases, or BLoC.
//
// Error handling:
//   DioException → wrapped in NetworkException (your project's error type)
//   Other errors → wrapped in AppException with a generic message
// ─────────────────────────────────────────────────────────────────────────────

/// Result holder for the list endpoint (stats + categories + videos in one call).
/// Used internally between datasource and repository — not exposed to the BLoC.
class TrainingVideoListData {
  final VideoStatsModel stats;
  final List<VideoCategoryModel> categories;
  final List<TrainingVideoModel> videos;

  const TrainingVideoListData({
    required this.stats,
    required this.categories,
    required this.videos,
  });
}

abstract class TrainingVideoRemoteDataSource {
  /// Calls GET /api/admin/training-videos
  /// Optional [categoryId] maps to ?categoryId= query param.
  Future<TrainingVideoListData> getVideos({int? categoryId});

  /// Calls GET /api/admin/training-videos/categories
  Future<List<VideoCategoryModel>> getCategories();
}

class TrainingVideoRemoteDataSourceImpl implements TrainingVideoRemoteDataSource {
  // Dio client injected by GetIt.
  // It is assumed the Dio instance is already configured with:
  //   - baseUrl = Env.apiBaseUrl
  //   - Authorization: Bearer <token> interceptor (set up by Mounir's shared config)
  final Dio dio;

  TrainingVideoRemoteDataSourceImpl(this.dio);

  // ── GET /api/admin/training-videos ─────────────────────────────────────────
  @override
  Future<TrainingVideoListData> getVideos({int? categoryId}) async {
    try {
      // Build query params — only add categoryId if it was provided
      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await dio.get(
        '/api/admin/training-videos',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      // response.data is the parsed JSON map from Dio
      final data = response.data as Map<String, dynamic>;

      // Parse the "stats" object
      final stats = VideoStatsModel.fromJson(
        data['stats'] as Map<String, dynamic>,
      );

      // Parse the "categories" array: cast each item to Map then run fromJson
      final categories = (data['categories'] as List<dynamic>)
          .map((item) => VideoCategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Parse the "videos" array
      final videos = (data['videos'] as List<dynamic>)
          .map((item) => TrainingVideoModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return TrainingVideoListData(
        stats: stats,
        categories: categories,
        videos: videos,
      );
    } on DioException catch (e) {
      // DioException covers: network down, 4xx, 5xx, timeout
      // NetworkException is your project's wrapper — adjusts the message for the UI
      throw NetworkException.fromDioError(e);
    } catch (e) {
      // Anything else (JSON parse error, cast failure, etc.)
      throw AppException(message: 'Failed to load training videos: $e');
    }
  }

  // ── GET /api/admin/training-videos/categories ──────────────────────────────
  @override
  Future<List<VideoCategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/api/admin/training-videos/categories');

      // Response is a plain JSON array: [ { "categoryId": 1, "name": "Cardio" }, ... ]
      final list = response.data as List<dynamic>;

      return list
          .map((item) => VideoCategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw AppException(message: 'Failed to load categories: $e');
    }
  }
}