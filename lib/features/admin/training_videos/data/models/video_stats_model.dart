import '../../domain/entities/video_stats_entity.dart';

class VideoStatsModel extends VideoStatsEntity {
  const VideoStatsModel({required super.totalVideos, required super.totalViews});

  factory VideoStatsModel.fromJson(Map<String, dynamic> json) =>
      VideoStatsModel(
        totalVideos: json['totalVideos'] as int,
        totalViews: json['totalViews'] as int,
      );
}