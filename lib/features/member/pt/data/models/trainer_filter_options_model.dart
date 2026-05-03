import 'package:build4allgym/features/member/pt/domain/entities/trainer_filter_options_entity.dart';

class TrainerFilterOptionsModel {
  // Specialties from backend — excludes الكل and المفضلة (hardcoded client-side)
  final List<String> specialties;

  const TrainerFilterOptionsModel({
    required this.specialties,
  });

  factory TrainerFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return TrainerFilterOptionsModel(
      specialties: List<String>.from(json['specialties'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialties': specialties,
    };
  }

  TrainerFilterOptionsEntity toEntity() {
    return TrainerFilterOptionsEntity(
      specialties: specialties,
    );
  }
}