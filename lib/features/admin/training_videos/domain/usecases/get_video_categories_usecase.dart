import '../entities/video_category_entity.dart';
import '../repositories/training_video_repository.dart';

class GetVideoCategoriesUseCase {
  final TrainingVideoRepository repository;
  GetVideoCategoriesUseCase(this.repository);

  Future<List<VideoCategoryEntity>> call() => repository.getCategories();
}