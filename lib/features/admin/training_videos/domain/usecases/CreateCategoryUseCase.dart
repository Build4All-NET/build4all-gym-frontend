// lib/features/admin/training_videos/domain/usecases/create_category_use_case.dart
import '../../data/repositories/training_video_repository_impl.dart';
import '../entities/video_category_entity.dart';
import '../repositories/training_video_repository.dart';

class CreateCategoryUseCase {
  final TrainingVideoRepository repository;
  CreateCategoryUseCase(this.repository);

  Future<VideoCategoryEntity> call(String name) => repository.createCategory(name);
}