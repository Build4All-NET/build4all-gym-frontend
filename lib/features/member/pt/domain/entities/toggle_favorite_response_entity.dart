class ToggleFavoriteResponseEntity {
  final int trainerId;
  final bool isFavorited;

  const ToggleFavoriteResponseEntity({
    required this.trainerId,
    required this.isFavorited,
  });
}