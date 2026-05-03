// ─────────────────────────────────────────────────────────────────────────────
// trainer_form_options_model.dart
// ─────────────────────────────────────────────────────────────────────────────
class TrainerFormOptionItemModel {
  final int    id;
  final String name;
  const TrainerFormOptionItemModel({required this.id, required this.name});

  factory TrainerFormOptionItemModel.fromJson(Map<String, dynamic> json) =>
      TrainerFormOptionItemModel(
        id:   json['id']   as int,
        name: json['name'] as String,
      );
}

class TrainerFormOptionsModel {
  final List<String>                    specialties;
  final List<TrainerFormOptionItemModel> branches;

  const TrainerFormOptionsModel({
    required this.specialties,
    required this.branches,
  });

  factory TrainerFormOptionsModel.fromJson(Map<String, dynamic> json) =>
      TrainerFormOptionsModel(
        specialties: List<String>.from(json['specialties'] ?? []),
        branches: (json['branches'] as List<dynamic>? ?? [])
            .map((e) => TrainerFormOptionItemModel.fromJson(
            e as Map<String, dynamic>))
            .toList(),
      );
}
