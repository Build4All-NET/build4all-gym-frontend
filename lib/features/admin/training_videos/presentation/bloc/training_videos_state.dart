import '../../domain/entities/trainer_option.dart';
import '../../domain/entities/training_video_entity.dart';
import '../../domain/entities/video_stats_entity.dart';
import '../../domain/entities/video_category_entity.dart';

abstract class TrainingVideosState {}

class TrainingVideosInitial extends TrainingVideosState {}
class TrainingVideosLoading extends TrainingVideosState {}

class TrainingVideosLoaded extends TrainingVideosState {
  final VideoStatsEntity stats;
  final List<VideoCategoryEntity> categories;
  final List<TrainingVideoEntity> videos;
  final int? selectedCategoryId;

  TrainingVideosLoaded({
    required this.stats,
    required this.categories,
    required this.videos,
    this.selectedCategoryId,
  });
}

class TrainingVideosError extends TrainingVideosState {
  final String message;
  TrainingVideosError(this.message);
}

// Form-specific states
// Updated — now carries categories too
class VideoFormOptionsLoaded extends TrainingVideosState {
  final List<TrainerOption> trainers;
  final List<VideoCategoryEntity> categories;
  VideoFormOptionsLoaded({required this.trainers, required this.categories});
}

// New states for inline category creation
class CategoryCreating extends TrainingVideosState {}

class CategoryCreated extends TrainingVideosState {
  final VideoCategoryEntity category; // the newly created one
  CategoryCreated(this.category);
}

class CategoryCreateError extends TrainingVideosState {
  final String message;
  CategoryCreateError(this.message);
}

class CreateVideoLoading extends TrainingVideosState {}

class CreateVideoSuccess extends TrainingVideosState {}

class CreateVideoError extends TrainingVideosState {
  final String message;
  CreateVideoError(this.message);
}


// rest of states unchanged