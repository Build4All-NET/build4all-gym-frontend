// features/admin/training_videos/domain/usecases/get_video_categories_usecase.dart

import 'package:dartz/dartz.dart';

import '../../../../../core/exceptions/app_exception.dart'; // AppException
import '../entities/video_category_entity.dart';
import '../repositories/training_video_repository.dart';

/// Fetches the list of categories for the create-video form dropdown.
///
/// Separate from GetTrainingVideosUseCase so the Create Video page can
/// load categories independently without triggering the full video list.
class GetVideoCategoriesUseCase {
  final TrainingVideoRepository repository;

  GetVideoCategoriesUseCase(this.repository);

  Future<Either<AppException, List<VideoCategoryEntity>>> call() {
    return repository.getCategories();
  }
}