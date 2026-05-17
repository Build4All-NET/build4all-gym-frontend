// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/domain/usecases/get_admin_settings_usecase.dart
// lib/features/admin/settings/domain/usecases/save_admin_settings_usecase.dart
//
// (Both use-cases live in this one file for brevity — they are tiny single-method
//  classes that just delegate to the repository.)
//
// PURPOSE:
//   Use-cases encapsulate a single business operation. The cubit calls the
//   use-case, not the repository directly. This keeps the cubit decoupled
//   from HTTP details and makes each action independently testable.
// ─────────────────────────────────────────────────────────────────────────────

import '../entities/settings_business_rules_entity.dart';
import '../repositories/admin_settings_repository.dart';

/// Fetches the gym's current business-rule settings.
class GetAdminSettingsUseCase {
  final AdminSettingsRepository _repository;
  const GetAdminSettingsUseCase(this._repository);

  /// Delegates to repository.getSettings().
  /// The cubit awaits this and updates its state with the result.
  Future<SettingsBusinessRulesEntity> call() => _repository.getSettings();
}

/// Persists the gym's business-rule settings to the backend.
class SaveAdminSettingsUseCase {
  final AdminSettingsRepository _repository;
  const SaveAdminSettingsUseCase(this._repository);

  /// Delegates to repository.saveSettings([rules]).
  Future<void> call(SettingsBusinessRulesEntity rules) =>
      _repository.saveSettings(rules);
}
