import 'dart:io';

class TrainingVideoEntity {
  final int videoId;
  final String title;
  final String? description;
  final int categoryId;
  final String? categoryName;
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
    this.description,
    required this.categoryId,
    this.categoryName,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.viewCount,
    required this.trainerName,
    required this.isPublished,
    required this.createdAt,
    this.videoFile,
    this.videoUrl,
  });
}