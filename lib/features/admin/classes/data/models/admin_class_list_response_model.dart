// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/models/admin_class_list_response_model.dart
//
// PURPOSE:
//   Maps the full response of GET /api/admin/classes.
//   The API returns { "date": "2026-03-16", "classes": [...] }
//   This model parses that top-level wrapper and the nested list of cards.
// ─────────────────────────────────────────────────────────────────────────────

import 'admin_class_card_model.dart';

class AdminClassListResponseModel {
  final String date;                      // e.g. "2026-03-16"
  final List<AdminClassCardModel> classes; // the class cards for that day

  const AdminClassListResponseModel({
    required this.date,
    required this.classes,
  });

  factory AdminClassListResponseModel.fromJson(Map<String, dynamic> json) {
    // The "classes" key holds a JSON array — map each item to AdminClassCardModel
    final rawList = json['classes'] as List<dynamic>? ?? [];
    return AdminClassListResponseModel(
      date:    json['date'] as String,
      classes: rawList
          .map((e) => AdminClassCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}