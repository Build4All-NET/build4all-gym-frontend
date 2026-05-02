import 'trainer_card_model.dart';
import 'package:build4allgym/features/member/pt/domain/entities/trainer_list_response_entity.dart';

class TrainerListResponseModel {
  final List<TrainerCardModel> trainers;
  final int favoriteCount;

  const TrainerListResponseModel({
    required this.trainers,
    required this.favoriteCount,
  });

  factory TrainerListResponseModel.fromJson(Map<String, dynamic> json) {
    return TrainerListResponseModel(
      trainers: (json['trainers'] as List<dynamic>)
          .map((e) => TrainerCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      favoriteCount: (json['favoriteCount'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainers': trainers.map((e) => e.toJson()).toList(),
      'favoriteCount': favoriteCount,
    };
  }

  TrainerListResponseEntity toEntity() {
    return TrainerListResponseEntity(
      trainers: trainers.map((e) => e.toEntity()).toList(),
      favoriteCount: favoriteCount,
    );
  }
}