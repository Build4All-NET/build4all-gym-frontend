// features/admin/training_videos/domain/entities/video_stats_entity.dart

// Represents the aggregate counts shown as stat cards at the top of the screen.
// Comes from the "stats" field of the backend list response.

class VideoStatsEntity {
  /// Total number of non-deleted videos for this tenant.
  final int totalVideos;

  /// Sum of all view_count values across this tenant's videos.
  final int totalViews;

  const VideoStatsEntity({
    required this.totalVideos,
    required this.totalViews,
  });
}