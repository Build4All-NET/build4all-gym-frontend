// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/domain/repositories/member_settings_repository.dart
//
// PURPOSE:
//   Domain-layer contract for member settings.
//
// WHY INTERFACE:
//   The Cubit and use cases should not know if data comes from:
//     • backend API
//     • local storage
//     • mock data for tests
//
//   They only depend on this contract.
//
// SAME STRUCTURE AS ADMIN:
//   Admin has a domain repository interface.
//   Member gets the same clean architecture layer.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/member_settings_entity.dart';

abstract class MemberSettingsRepository {
  /// Loads the current connected member's language/theme settings.
  ///
  /// The backend identifies the member from the JWT token.
  /// No userId is sent from the frontend.
  Future<MemberSettingsEntity> getSettings();

  /// Saves/replaces the current connected member's language/theme settings.
  ///
  /// Backend PUT is a full replace:
  /// both languageCode and themeMode are sent.
  Future<void> updateSettings(MemberSettingsEntity settings);
}