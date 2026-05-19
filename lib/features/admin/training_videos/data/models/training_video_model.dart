import '../../domain/entities/training_video_entity.dart';

class TrainingVideoModel extends TrainingVideoEntity {
  const TrainingVideoModel({
    required super.videoId,
    required super.title,
    super.description,
    required super.categoryId,
    super.categoryName,
    super.thumbnailUrl,
    required super.durationSeconds,
    required super.viewCount,
    required super.trainerName,
    required super.isPublished,
    required super.createdAt,
    super.videoUrl,
  });

  factory TrainingVideoModel.fromJson(Map<String, dynamic> json) {
    return TrainingVideoModel(
      videoId: (json['videoId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      viewCount: (json['viewCount'] as num).toInt(),
      trainerName: json['trainerName'] as String? ?? '',
      isPublished: json['isPublished'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      videoUrl: json['videoUrl'] as String?,
    );
  }
}