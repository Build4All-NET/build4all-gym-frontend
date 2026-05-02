import 'package:build4allgym/features/member/pt/domain/entities/toggle_favorite_response_entity.dart';

class ToggleFavoriteResponseModel {
  final int trainerId;
  final bool isFavorited;

  const ToggleFavoriteResponseModel({
    required this.trainerId,
    required this.isFavorited,
  });

  factory ToggleFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResponseModel(
      trainerId: (json['trainerId'] as num).toInt(),
      // BE uses 'favorited' due to Lombok boolean getter naming
      isFavorited: json['favorited'] as bool? ?? json['isFavorited'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'isFavorited': isFavorited,
    };
  }

  ToggleFavoriteResponseEntity toEntity() {
    return ToggleFavoriteResponseEntity(
      trainerId: trainerId,
      isFavorited: isFavorited,
    );
  }
}