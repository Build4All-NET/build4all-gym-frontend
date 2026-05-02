import 'trainer_card_entity.dart';

class TrainerListResponseEntity {
  final List<TrainerCardEntity> trainers;
  final int favoriteCount;

  const TrainerListResponseEntity({
    required this.trainers,
    required this.favoriteCount,
  });
}