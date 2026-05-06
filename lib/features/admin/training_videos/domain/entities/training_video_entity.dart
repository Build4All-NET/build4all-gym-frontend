// features/admin/training_videos/domain/entities/training_video_entity.dart

// ── What is a Domain Entity? ──────────────────────────────────────────────────
// A plain Dart class. No JSON parsing, no Flutter widgets, no Dio.
// It represents the "pure business object" — what a TrainingVideo IS,
// independent of how we fetch it or display it.
// The rest of the app (BLoC, UI) works with these objects only.
// ─────────────────────────────────────────────────────────────────────────────

class TrainingVideoEntity {
  final int videoId;
  final String title;

  /// Category label, e.g. "Cardio" — already resolved on the backend.
  final String categoryName;

  /// URL for the cover image. Can be null → UI shows a placeholder.
  final String? thumbnailUrl;

  /// Raw length in seconds (e.g. 305). Formatted as "MM:SS" by DurationFormatter.
  final int durationSeconds;

  /// Total number of times this video has been viewed.
  final int viewCount;

  /// Full name of the trainer who uploaded this video.
  final String trainerName;

  /// False = draft/hidden from members.
  final bool isPublished;

  /// When the video was created — used for ordering.
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