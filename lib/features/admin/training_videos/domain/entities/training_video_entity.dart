class TrainingVideoEntity {
  final int videoId;
  final String title;
  final String categoryName;
  final String? thumbnailUrl;
  final int durationSeconds;
  final int viewCount;
  final String trainerName;
  final bool isPublished;
  final DateTime createdAt;

  const TrainingVideoEntity({
    required this.videoId,
    required this.title,
    required this.categoryName,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.viewCount,
    required this.trainerName,
    required this.isPublished,
    required this.createdAt,
  });
}