import 'dart:io';
class CreateTrainingVideoRequest {
  final String title;
  final String? description;
  final int categoryId;       // ✅ back to int
  final String videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds;
  final int? branchId;
  final bool isPublished;
  final int? trainerId;
  final File? videoFile;


  const CreateTrainingVideoRequest({
    required this.title,
    this.description,
    required this.categoryId,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
    this.branchId,
    required this.isPublished,
    this.trainerId,
    this.videoFile,
  });

  Map<String, dynamic> toMultipart() => {
    'title': title,
    if (description != null && description!.isNotEmpty) 'description': description,
    'categoryId': categoryId,
    'videoUrl': videoUrl,
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) 'thumbnailUrl': thumbnailUrl,
    'durationSeconds': durationSeconds,
    if (branchId != null) 'branchId': branchId,
    'isPublished': isPublished,
    if (trainerId != null) 'trainerId': trainerId,
    if (videoUrl.isNotEmpty) 'videoUrl': videoUrl,
  };
}