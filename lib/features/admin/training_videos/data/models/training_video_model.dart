import '../../domain/entities/training_video_entity.dart';

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

  factory TrainingVideoModel.fromJson(Map<String, dynamic> json) {
    return TrainingVideoModel(
      videoId: json['videoId'] as int,
      title: json['title'] as String,
      categoryName: json['categoryName'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      durationSeconds: json['durationSeconds'] as int,
      viewCount: json['viewCount'] as int,
      trainerName: json['trainerName'] as String,
      isPublished: json['isPublished'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}