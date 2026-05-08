class TrainerVideoEntity {
  final int id;
  final String title;
  final String? thumbnailUrl;
  final String? duration;
  final String videoUrl;

  const TrainerVideoEntity({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    this.duration,
    required this.videoUrl,
  });
}