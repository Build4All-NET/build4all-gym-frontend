// features/admin/training_videos/domain/repositories/training_video_repository.dart

import 'package:dartz/dartz.dart';

import '../../../../../core/exceptions/app_exception.dart'; // AppException
import '../entities/training_video_entity.dart';
import '../entities/video_category_entity.dart';
import '../entities/video_stats_entity.dart';

// ── What is an Abstract Repository? ──────────────────────────────────────────
// This is just a CONTRACT — an abstract class with no implementation.
// It says: "whoever implements me MUST provide these two methods."
//
// WHY?
// The domain layer (use cases, BLoC) depends on this abstract class, NOT on
// the real implementation. This means we can swap the real HTTP datasource for
// a fake/mock one in tests without changing any business logic.
//
// The real implementation lives in data/repositories/training_video_repository_impl.dart
// ─────────────────────────────────────────────────────────────────────────────

// ── What is Either<L, R>? ────────────────────────────────────────────────────
// Either<AppException, T> is a functional way to return "success OR failure"
// without throwing exceptions. The BLoC checks:
//   Left(error)  → something went wrong → emit TrainingVideosError
//   Right(data)  → success             → emit TrainingVideosLoaded
// ─────────────────────────────────────────────────────────────────────────────

abstract class TrainingVideoRepository {
  /// Fetches stats + categories + videos for the list screen.
  ///
  /// [categoryId] is optional. When null → returns all videos.
  /// When provided → returns only videos in that category.
  ///
  /// Returns a record with all three pieces of data in one call,
  /// matching what the backend sends in a single HTTP response.
  Future<Either<AppException, TrainingVideoListResult>> getVideos({int? categoryId});

  /// Fetches only the category list — used to populate the create-video form dropdown.
  Future<Either<AppException, List<VideoCategoryEntity>>> getCategories();
}

/// ── TrainingVideoListResult ──────────────────────────────────────────────────
/// A simple holder for the three things the list endpoint returns together.
/// Using a dedicated class instead of a Map or tuple makes the types explicit
/// and avoids hard-to-spot index bugs.
class TrainingVideoListResult {
  final VideoStatsEntity stats;
  final List<VideoCategoryEntity> categories;
  final List<TrainingVideoEntity> videos;

  const TrainingVideoListResult({
    required this.stats,
    required this.categories,
    required this.videos,
  });
}