// features/admin/training_videos/domain/usecases/get_training_videos_usecase.dart

import 'package:dartz/dartz.dart';

import '../../../../../core/exceptions/app_exception.dart'; // AppException
import '../repositories/training_video_repository.dart';

// ── What is a Use Case? ───────────────────────────────────────────────────────
// A Use Case is a single "action" the app can perform.
// It wraps exactly ONE repository call with a clean, named class.
//
// The BLoC calls use cases — it does NOT call the repository directly.
// This keeps the BLoC focused on state management and the use case
// focused on "what data do I need for this screen action".
// ─────────────────────────────────────────────────────────────────────────────

class GetTrainingVideosUseCase {
  // The repository injected here is the abstract type, not the real implementation.
  // At runtime, GetIt provides the real TrainingVideoRepositoryImpl.
  final TrainingVideoRepository repository;

  GetTrainingVideosUseCase(this.repository);

  /// Calls the repository's getVideos method.
  ///
  /// [categoryId] — pass null to get all videos, or a specific id to filter.
  Future<Either<AppException, TrainingVideoListResult>> call({int? categoryId}) {
    return repository.getVideos(categoryId: categoryId);
  }
}