class CreateTrainingVideoRequest {
  final String title;
  final String? description;
  final String categoryName;   // ✅ free text instead of categoryId
  final String videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds;
  final int? branchId;
  final bool isPublished;
  final int? trainerId;        // ✅ new

  const CreateTrainingVideoRequest({
    required this.title,
    this.description,
    required this.categoryName,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
    this.branchId,
    required this.isPublished,
    this.trainerId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    if (description != null && description!.isNotEmpty)
      'description': description,
    'categoryName': categoryName,
    'videoUrl': videoUrl,
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
      'thumbnailUrl': thumbnailUrl,
    'durationSeconds': durationSeconds,
    if (branchId != null) 'branchId': branchId,
    'isPublished': isPublished,
    if (trainerId != null) 'trainerId': trainerId,
  };
}