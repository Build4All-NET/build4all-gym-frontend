// ─────────────────────────────────────────────────────────────────────────────
// admin_trainer_list_response_model.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'admin_trainer_card_model.dart';
class AdminTrainerListResponseModel {
  final List<AdminTrainerCardModel> trainers;
  final int total;

  const AdminTrainerListResponseModel({
    required this.trainers,
    required this.total,
  });

  factory AdminTrainerListResponseModel.fromJson(dynamic json) {
    // Backend may return a plain list OR { trainers: [], total: N }
    if (json is List) {
      final list = json.map((e) =>
          AdminTrainerCardModel.fromJson(e as Map<String, dynamic>)).toList();
      return AdminTrainerListResponseModel(trainers: list, total: list.length);
    }
    final map = json as Map<String, dynamic>;
    return AdminTrainerListResponseModel(
      trainers: (map['trainers'] as List<dynamic>? ?? [])
          .map((e) => AdminTrainerCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: map['total'] as int? ?? 0,
    );
  }
}
