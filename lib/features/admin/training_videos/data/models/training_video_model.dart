// features/admin/training_videos/data/models/training_video_model.dart

import '../../domain/entities/training_video_entity.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/entities/video_stats_entity.dart';

// ── What are Models? ──────────────────────────────────────────────────────────
// Models are the DATA LAYER version of entities.
// They extend the domain entity and ADD fromJson() — the only place in the
// app that knows about JSON keys from the backend API.
//
// Why keep them separate from entities?
//   → Entities are pure Dart. Models know about JSON.
//   → If the backend renames a field, you only change the model, not the entity.
// ─────────────────────────────────────────────────────────────────────────────


// ── TrainingVideoModel ────────────────────────────────────────────────────────
// Parses one item from the "videos" array in the backend response.
//
// Backend JSON shape (one video):
// {
//   "videoId": 5,
//   "title": "Full Body Burn",
//   "categoryName": "Cardio",
//   "thumbnailUrl": "https://...",   ← can be null
//   "durationSeconds": 305,
//   "viewCount": 120,
//   "trainerName": "lara",
//   "isPublished": true,
//   "createdAt": "2026-06-05T00:50:00"
// }
// ─────────────────────────────────────────────────────────────────────────────
class TrainingVideoModel extends TrainingVideoEntity {
  const TrainingVideoModel({
    required super.videoId,
    required super.title,
    required super.categoryName,
    super.thumbnailUrl,
    required super.durationSeconds,
    required super.viewCount,
    required super.trainerName,
    required super.isPublished,
    required super.createdAt,
  });

  /// Builds a TrainingVideoModel from a single JSON map.
  ///
  /// Called inside TrainingVideoRemoteDataSource when parsing the "videos" list.
  factory TrainingVideoModel.fromJson(Map<String, dynamic> json) {
    return TrainingVideoModel(
      // Backend sends camelCase keys matching the Java DTO field names
      videoId:         json['videoId'] as int,
      title:           json['title'] as String,
      categoryName:    json['categoryName'] as String,
      thumbnailUrl:    json['thumbnailUrl'] as String?,  // nullable — can be null
      durationSeconds: json['durationSeconds'] as int,
      viewCount:       (json['viewCount'] as num).toInt(), // backend sends Long → num in Dart
      trainerName:     json['trainerName'] as String,
      isPublished:     json['isPublished'] as bool,
      // Backend sends ISO-8601 string: "2024-05-01T10:30:00"
      // DateTime.parse handles this format directly
      createdAt:       DateTime.parse(json['createdAt'] as String),
    );
  }
}


// ── VideoStatsModel ───────────────────────────────────────────────────────────
// Parses the "stats" field of the backend response.
//
// Backend JSON shape:
// { "totalVideos": 24, "totalViews": 1830 }
// ─────────────────────────────────────────────────────────────────────────────
class VideoStatsModel extends VideoStatsEntity {
  const VideoStatsModel({
    required super.totalVideos,
    required super.totalViews,
  });

  factory VideoStatsModel.fromJson(Map<String, dynamic> json) {
    return VideoStatsModel(
      totalVideos: (json['totalVideos'] as num).toInt(),
      totalViews:  (json['totalViews'] as num).toInt(),
    );
  }
}


// ── VideoCategoryModel ────────────────────────────────────────────────────────
// Parses one item from the "categories" array in the backend response.
//
// Backend JSON shape (one category):
// { "categoryId": 2, "name": "Cardio" }
// ─────────────────────────────────────────────────────────────────────────────
class VideoCategoryModel extends VideoCategoryEntity {
  const VideoCategoryModel({
    required super.categoryId,
    required super.name,
  });

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) {
    return VideoCategoryModel(
      categoryId: json['categoryId'] as int,
      name:       json['name'] as String,
    );
  }
}