// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/data/models/member_settings_model.dart
//
// PURPOSE:
//   Data-layer model for member settings.
//   This class is responsible for JSON conversion only.
//
// WHY MODEL:
//   The backend speaks JSON.
//   The domain layer speaks MemberSettingsEntity.
//   This model converts between both sides.
//
// BACKEND JSON SHAPE:
//   {
//     "languageCode": "en",
//     "themeMode": "system"
//   }
//
// SAME STRUCTURE AS ADMIN:
//   Admin has a data model that maps backend JSON to domain entity.
//   Member gets the same pattern here.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/member_settings_entity.dart';

class MemberSettingsModel {
  final String languageCode;
  final String themeMode;

  const MemberSettingsModel({
    required this.languageCode,
    required this.themeMode,
  });

  // ── JSON → Model ───────────────────────────────────────────────────────────

  /// Builds a model from backend JSON.
  factory MemberSettingsModel.fromJson(Map<String, dynamic> json) {
    return MemberSettingsModel(
      languageCode: json['languageCode'] as String? ?? 'en',
      themeMode: json['themeMode'] as String? ?? 'system',
    );
  }

  // ── Model → JSON ───────────────────────────────────────────────────────────

  /// Converts this model to the JSON body expected by PUT /api/member/settings.
  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'themeMode': themeMode,
    };
  }

  // ── Model → Entity ─────────────────────────────────────────────────────────

  /// Converts data model to domain entity.
  MemberSettingsEntity toEntity() {
    return MemberSettingsEntity(
      languageCode: languageCode,
      themeMode: themeMode,
    );
  }

  // ── Entity → Model ─────────────────────────────────────────────────────────

  /// Converts domain entity to data model before sending it to backend.
  factory MemberSettingsModel.fromEntity(MemberSettingsEntity entity) {
    return MemberSettingsModel(
      languageCode: entity.languageCode,
      themeMode: entity.themeMode,
    );
  }
}