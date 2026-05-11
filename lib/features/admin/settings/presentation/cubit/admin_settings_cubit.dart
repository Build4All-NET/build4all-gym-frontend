// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/cubit/admin_settings_cubit.dart
//
// PURPOSE:
//   State management hub for AdminSettingsScreen.
//   Orchestrates:
//     • Loading business rules from backend (GET /api/admin/settings)
//     • Loading biometric preference from FlutterSecureStorage
//     • Tracking which fields changed (isDirty)
//     • Saving ALL dirty settings atomically when user taps "Save Changes"
//
// PATTERN:
//   Same pattern as AdminDashboardBloc / other admin cubits in this project:
//   constructor-injected dependencies, no service locator, testable.
//
// DIRTY STATE:
//   Any setter that changes a field calls _markDirty() which flips isDirty=true.
//   Saving resets isDirty=false.
//   This drives: "Unsaved" AppBar badge + Save button enabled state.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/settings_business_rules_entity.dart';
import '../../domain/usecases/get_admin_settings_usecase.dart';
import 'admin_settings_state.dart';

class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  // ── Dependencies ────────────────────────────────────────────────────────────
  final GetAdminSettingsUseCase _getSettings;
  final SaveAdminSettingsUseCase _saveSettings;
  final FlutterSecureStorage _secureStorage;

  /// Key used to persist the biometric preference in FlutterSecureStorage.
  static const _biometricKey = 'biometric_enabled';

  AdminSettingsCubit({
    required GetAdminSettingsUseCase getSettings,
    required SaveAdminSettingsUseCase saveSettings,
    FlutterSecureStorage? secureStorage,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        super(AdminSettingsState.initial()) {
    // Load everything on construction so the screen shows data immediately.
    _loadInitialData();
  }

  // ── Initialization ──────────────────────────────────────────────────────────

  /// Loads business rules from backend AND biometric flag from secure storage in parallel.
  Future<void> _loadInitialData() async {
    emit(state.copyWith(status: AdminSettingsStatus.loading));
    try {
      // Run both I/O operations concurrently for faster screen load.
      final results = await Future.wait([
        _getSettings(),                          // GET /api/admin/settings
        _secureStorage.read(key: _biometricKey), // local secure storage
      ]);

      final rules = results[0] as SettingsBusinessRulesEntity;
      final biometricRaw = results[1] as String?;
      final isBiometric = biometricRaw == 'true';

      emit(state.copyWith(
        status: AdminSettingsStatus.loaded,
        businessRules: rules,
        isBiometricEnabled: isBiometric,
        // isDirty stays false — we just loaded, nothing changed yet
        isDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdminSettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Appearance setter ───────────────────────────────────────────────────────

  /// Called by AppearanceSectionWidget when the user taps a theme option.
  /// Does NOT apply to ThemeCubit yet — only stored as pending until Save.
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(selectedThemeMode: mode));
    _markDirty();
  }

  // ── Language setter ─────────────────────────────────────────────────────────

  /// Called by LanguageSectionWidget when the user picks a language.
  /// null = "System Default" (same as LocaleCubit convention).
  /// Does NOT call LocaleCubit yet — stored as pending until Save.
  void setPendingLocale(Locale? locale) {
    emit(state.copyWith(pendingLocale: locale));
    _markDirty();
  }

  // ── Account & Security setters ──────────────────────────────────────────────

  /// Called by AccountSecuritySectionWidget biometric toggle.
  void setBiometricEnabled(bool value) {
    emit(state.copyWith(isBiometricEnabled: value));
    _markDirty();
  }

  /// Called by AccountSecuritySectionWidget 2FA toggle.
  void setTwoFactorEnabled(bool value) {
    emit(state.copyWith(isTwoFactorEnabled: value));
    _markDirty();
  }

  // ── Business Rules setters ──────────────────────────────────────────────────

  /// Updates a single business rule toggle without touching the others.
  /// Uses SettingsBusinessRulesEntity.copyWith() for immutable update.
  void updateBusinessRule({
    bool? allowClassWithoutMembership,
    bool? requireMembershipForClass,
    bool? allowMembershipWithoutClass,
    bool? allowBothIndependently,
  }) {
    final current = state.businessRules ?? SettingsBusinessRulesEntity.defaults();
    emit(state.copyWith(
      businessRules: current.copyWith(
        allowClassWithoutMembership: allowClassWithoutMembership,
        requireMembershipForClass: requireMembershipForClass,
        allowMembershipWithoutClass: allowMembershipWithoutClass,
        allowBothIndependently: allowBothIndependently,
      ),
    ));
    _markDirty();
  }

  // ── Save all settings ───────────────────────────────────────────────────────

  /// Persists ALL dirty settings.
  /// Called when the user taps the sticky "Save Changes" button.
  ///
  /// Operations:
  ///   1. PUT /api/admin/settings  (business rules)
  ///   2. Write biometric flag to FlutterSecureStorage
  ///   3. ThemeCubit.setThemeMode() and LocaleCubit.setLocale() are called
  ///      by the SCREEN (not here) after this future resolves, because
  ///      ThemeCubit and LocaleCubit live at the app root and the cubit
  ///      should not depend on them directly.
  ///
  /// Returns true on success, false on failure (screen shows snackbar).
  Future<bool> saveSettings() async {
    if (!state.isDirty) return true; // Nothing to save

    emit(state.copyWith(status: AdminSettingsStatus.saving));
    try {
      // 1. Persist business rules to backend
      if (state.businessRules != null) {
        await _saveSettings(state.businessRules!);
      }

      // 2. Persist biometric flag to secure storage
      await _secureStorage.write(
        key: _biometricKey,
        value: state.isBiometricEnabled.toString(),
      );

      // 3. Mark as clean — theme/locale are applied by the screen
      emit(state.copyWith(
        status: AdminSettingsStatus.saved,
        isDirty: false,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: AdminSettingsStatus.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  /// Sets isDirty = true. Shows the "Unsaved" badge and enables the Save button.
  void _markDirty() {
    if (!state.isDirty) {
      emit(state.copyWith(isDirty: true));
    }
  }
}
