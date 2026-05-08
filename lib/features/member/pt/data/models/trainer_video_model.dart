import '../../domain/entities/trainer_video_entity.dart';

class TrainerVideoModel {
  final int id;
  final String title;
  final String? thumbnailUrl;
  final String? duration;
  final String videoUrl;

  const TrainerVideoModel({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    this.duration,
    required this.videoUrl,
  });

  factory TrainerVideoModel.fromJson(Map<String, dynamic> json) {
    return TrainerVideoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: json['duration'] as String?,
      videoUrl: json['videoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'videoUrl': videoUrl,
    };
  }

  TrainerVideoEntity toEntity() {
    return TrainerVideoEntity(
      id: id,
      title: title,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      videoUrl: videoUrl,
    );
  }
}