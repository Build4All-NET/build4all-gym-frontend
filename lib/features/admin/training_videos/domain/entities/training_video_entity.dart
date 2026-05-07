import 'dart:io';

class TrainingVideoEntity {
  final int videoId;
  final String title;
  final int categoryId;
  final String? thumbnailUrl;
  final int durationSeconds;
  final int viewCount;
  final String trainerName;
  final bool isPublished;
  final DateTime createdAt;
  final File? videoFile;
  final String? videoUrl;

  const TrainingVideoEntity({
    required this.videoId,
    required this.title,
    required this.categoryId,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.viewCount,
    required this.trainerName,
    required this.isPublished,
    required this.createdAt,
     this.videoFile,
     this.videoUrl
  });
}