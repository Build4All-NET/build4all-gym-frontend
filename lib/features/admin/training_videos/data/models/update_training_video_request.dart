import 'dart:io';

class UpdateTrainingVideoRequest {
  final int videoId;
  final String title;
  final String? description;
  final int categoryId;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds;
  final bool isPublished;
  final int? trainerId;
  final File? videoFile;

  const UpdateTrainingVideoRequest({
    required this.videoId,
    required this.title,
    this.description,
    required this.categoryId,
    this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.isPublished,
    this.trainerId,
    this.videoFile,
  });

  Map<String, dynamic> toMultipart() => {
    'title': title,
    if (description != null && description!.isNotEmpty) 'description': description,
    'categoryId': categoryId,
    if (videoUrl != null && videoUrl!.isNotEmpty) 'videoUrl': videoUrl,
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) 'thumbnailUrl': thumbnailUrl,
    'durationSeconds': durationSeconds,
    'isPublished': isPublished,
    if (trainerId != null) 'assignedTrainerId': trainerId,
  };
}
