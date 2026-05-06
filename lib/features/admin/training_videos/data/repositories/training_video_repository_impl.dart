// features/admin/training_videos/data/repositories/training_video_repository_impl.dart

import 'package:dartz/dartz.dart';

import '../../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/repositories/training_video_repository.dart';
import '../services/training_video_remote_datasource.dart';

// ── What is the Repository Implementation? ────────────────────────────────────
// This class is the BRIDGE between the data layer and the domain layer.
//
// It:
//   1. Calls the remote datasource (which returns Models / throws exceptions)
//   2. Catches any exceptions
//   3. Returns Either<AppException, DomainType>
//
// The domain layer (use cases, BLoC) never sees raw exceptions — only Either.
// ─────────────────────────────────────────────────────────────────────────────

class TrainingVideoRepositoryImpl implements TrainingVideoRepository {
  final TrainingVideoRemoteDataSource remoteDataSource;

  TrainingVideoRepositoryImpl(this.remoteDataSource);

  // ── getVideos ──────────────────────────────────────────────────────────────
  @override
  Future<Either<AppException, TrainingVideoListResult>> getVideos({
    int? categoryId,
  }) async {
    try {
      // Call the datasource — may throw AppException / NetworkException
      final data = await remoteDataSource.getVideos(categoryId: categoryId);

      // Models ARE entities (they extend them) so we can pass them directly.
      // The repository wraps them in Right() to signal success.
      return Right(
        TrainingVideoListResult(
          stats:      data.stats,
          categories: data.categories,
          videos:     data.videos,
        ),
      );
    } on AppException catch (e) {
      // Datasource threw a known AppException / NetworkException — wrap in Left
      return Left(e);
    } catch (e) {
      // Unknown error — wrap in a generic AppException
      return Left(AppException(message: 'Unexpected error: $e'));
    }
  }

  // ── getCategories ──────────────────────────────────────────────────────────
  @override
  Future<Either<AppException, List<VideoCategoryEntity>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      // Models extend entities — safe to return as List<VideoCategoryEntity>
      return Right(models);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: 'Unexpected error: $e'));
    }
  }
}