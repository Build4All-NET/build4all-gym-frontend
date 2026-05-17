// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/domain/repositories/admin_settings_repository.dart
//
// PURPOSE:
//   Abstract contract (interface) that the domain layer depends on.
//   The data layer provides a concrete implementation (AdminSettingsRepositoryImpl).
//
// WHY ABSTRACT:
//   Following Dependency Inversion Principle — the use-cases depend on this
//   abstraction, not on Dio or HTTP details. This makes use-cases testable
//   without a real network (mock the interface instead).
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/settings_business_rules_entity.dart';

abstract class AdminSettingsRepository {
  /// Fetches the current gym business-rule settings from the backend.
  /// Returns [SettingsBusinessRulesEntity] on success.
  /// Throws an [Exception] on network or server errors.
  Future<SettingsBusinessRulesEntity> getSettings();

  /// Sends the updated business-rule settings to the backend (HTTP PUT).
  /// Returns void on success; throws on failure.
  Future<void> saveSettings(SettingsBusinessRulesEntity rules);
}
