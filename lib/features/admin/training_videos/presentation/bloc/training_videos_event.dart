import '../../data/models/create_training_video_request.dart';
import '../../data/models/update_training_video_request.dart';

abstract class TrainingVideosEvent {}

class LoadTrainingVideos extends TrainingVideosEvent {
  final int? categoryId;
  LoadTrainingVideos({this.categoryId});
}

class FilterByCategory extends TrainingVideosEvent {
  final int? categoryId;
  FilterByCategory(this.categoryId);
}

class LoadVideoFormOptions extends TrainingVideosEvent {}

class SubmitCreateVideo extends TrainingVideosEvent {
  final CreateTrainingVideoRequest request;
  SubmitCreateVideo(this.request);
}

class SubmitUpdateVideo extends TrainingVideosEvent {
  final UpdateTrainingVideoRequest request;
  SubmitUpdateVideo(this.request);
}

class DeleteVideo extends TrainingVideosEvent {
  final int videoId;
  DeleteVideo(this.videoId);
}

class AddNewCategory extends TrainingVideosEvent {
  final String name;
  AddNewCategory(this.name);
}