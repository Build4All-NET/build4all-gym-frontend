// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/domain/usecases/get_member_settings_usecase.dart
//
// PURPOSE:
//   Use cases for member settings.
//
// WHY USE CASES:
//   The Cubit should not talk directly to the repository.
//   It calls use cases, and the use cases call the repository.
//
// SAME STRUCTURE AS ADMIN:
//   Admin settings exposes get/save use cases from the domain/usecases layer.
//   Member settings follows the same pattern here.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/member_settings_entity.dart';
import '../repositories/member_settings_repository.dart';

/// Loads the connected member's language/theme settings.
///
/// The backend identifies the member from the JWT.
/// The frontend does not send userId.
class GetMemberSettingsUseCase {
  final MemberSettingsRepository repository;

  const GetMemberSettingsUseCase(this.repository);

  Future<MemberSettingsEntity> call() {
    return repository.getSettings();
  }
}

/// Saves/replaces the connected member's language/theme settings.
///
/// Backend PUT is a full replace:
///   - languageCode
///   - themeMode
///
/// Both values are sent every time.
class UpdateMemberSettingsUseCase {
  final MemberSettingsRepository repository;

  const UpdateMemberSettingsUseCase(this.repository);

  Future<void> call(MemberSettingsEntity settings) {
    return repository.updateSettings(settings);
  }
}