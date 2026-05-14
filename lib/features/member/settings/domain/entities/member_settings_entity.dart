// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/domain/entities/member_settings_entity.dart
//
// PURPOSE:
//   Pure domain object for member settings.
//   It represents the settings used by the app, independent from JSON,
//   Dio, HTTP, Flutter widgets, or backend implementation details.
//
// FIELDS:
//   • languageCode — selected language code.
//                    Example: "en", "fr", "ar", "system"
//   • themeMode    — selected theme mode.
//                    Example: "light", "dark", "system"
//
// SAME STRUCTURE AS ADMIN:
//   Admin has a domain entity for settings/business rules.
//   Member gets a domain entity for language/theme settings.
// ─────────────────────────────────────────────────────────────────────────────

class MemberSettingsEntity {
  /// Selected language code.
  ///
  /// Examples:
  ///   "en"
  ///   "fr"
  ///   "ar"
  ///   "system"
  final String languageCode;

  /// Selected theme mode.
  ///
  /// Examples:
  ///   "light"
  ///   "dark"
  ///   "system"
  final String themeMode;

  const MemberSettingsEntity({
    required this.languageCode,
    required this.themeMode,
  });

  /// Default values used when the frontend needs a safe fallback.
  factory MemberSettingsEntity.defaults() => const MemberSettingsEntity(
    languageCode: 'en',
    themeMode: 'system',
  );

  /// Immutable update helper.
  MemberSettingsEntity copyWith({
    String? languageCode,
    String? themeMode,
  }) {
    return MemberSettingsEntity(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}