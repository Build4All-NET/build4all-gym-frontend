// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/cubit/member_settings_cubit.dart
//
// PURPOSE:
//   State management hub for MemberSettingsScreen.
//
// RESPONSIBILITIES:
//   • Load language/theme settings from backend.
//   • Load biometric preference from FlutterSecureStorage.
//   • Track dirty changes.
//   • Save language/theme to backend.
//   • Save biometric preference locally.
//
// SAME STRUCTURE AS ADMIN:
//   AdminSettingsCubit uses constructor-injected use cases,
//   FlutterSecureStorage, _loadInitialData(), dirty tracking,
//   and saveSettings() returning true/false.
//   MemberSettingsCubit follows the same pattern.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/member_settings_entity.dart';
import '../../domain/usecases/get_member_settings_usecase.dart';
import 'member_settings_state.dart';

class MemberSettingsCubit extends Cubit<MemberSettingsState> {
  // ── Dependencies ────────────────────────────────────────────────────────────

  final GetMemberSettingsUseCase _getSettings;
  final UpdateMemberSettingsUseCase _saveSettings;
  final FlutterSecureStorage _secureStorage;

  /// Key used to persist biometric preference locally.
  static const _biometricKey = 'biometric_enabled';

  MemberSettingsCubit({
    required GetMemberSettingsUseCase getSettings,
    required UpdateMemberSettingsUseCase saveSettings,
    FlutterSecureStorage? secureStorage,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        super(MemberSettingsState.initial()) {
    // Load backend + local settings when the cubit is created.
    _loadInitialData();
  }

  // ── Initialization ──────────────────────────────────────────────────────────

  /// Loads member settings from backend and biometric preference from secure storage.
  Future<void> _loadInitialData() async {
    emit(state.copyWith(status: MemberSettingsStatus.loading));

    try {
      final results = await Future.wait([
        _getSettings(),                          // GET /api/member/settings
        _secureStorage.read(key: _biometricKey), // local secure storage
      ]);

      final settings = results[0] as MemberSettingsEntity;
      final biometricRaw = results[1] as String?;
      final isBiometric = biometricRaw == 'true';

      emit(state.copyWith(
        status: MemberSettingsStatus.loaded,
        selectedThemeMode: _themeModeFromBackend(settings.themeMode),
        pendingLocale: _localeFromBackend(settings.languageCode),
        isBiometricEnabled: isBiometric,
        isDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MemberSettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Public retry method for the screen.
  Future<void> reload() async {
    await _loadInitialData();
  }

  // ── Appearance setter ───────────────────────────────────────────────────────

  /// Called when the user changes the theme option.
  /// This only updates pending state and marks the screen dirty.
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(selectedThemeMode: mode));
    _markDirty();
  }

  // ── Language setter ─────────────────────────────────────────────────────────

  /// Called when the user selects a language.
  /// null means system/default language.
  void setPendingLocale(Locale? locale) {
    emit(state.copyWith(pendingLocale: locale));
    _markDirty();
  }

  // ── Account & Security setter ───────────────────────────────────────────────

  /// Called when the user toggles biometric login.
  void setBiometricEnabled(bool value) {
    emit(state.copyWith(isBiometricEnabled: value));
    _markDirty();
  }

  // ── Save all settings ───────────────────────────────────────────────────────

  /// Saves all dirty member settings.
  ///
  /// Operations:
  ///   1. PUT /api/member/settings
  ///   2. Save biometric flag locally
  ///
  /// ThemeCubit and LocaleCubit are updated by the screen after success.
  Future<bool> saveSettings() async {
    if (!state.isDirty) return true;



    try {
      final settings = MemberSettingsEntity(
        languageCode: _languageCodeToBackend(state.pendingLocale),
        themeMode: _themeModeToBackend(state.selectedThemeMode),
      );

      // 1. Persist language/theme to backend.
      await _saveSettings(settings);

      // 2. Persist biometric preference locally.
      await _secureStorage.write(
        key: _biometricKey,
        value: state.isBiometricEnabled.toString(),
      );

      emit(state.copyWith(
        status: MemberSettingsStatus.loaded,
        isDirty: false,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: MemberSettingsStatus.error,
        errorMessage: e.toString(),
      ));

      return false;
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  /// Sets isDirty = true.
  void _markDirty() {
    if (!state.isDirty) {
      emit(state.copyWith(isDirty: true));
    }
  }

  /// Converts backend theme string to Flutter ThemeMode.
  ThemeMode _themeModeFromBackend(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Converts Flutter ThemeMode to backend theme string.
  String _themeModeToBackend(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Converts backend languageCode to Flutter Locale.
  ///
  /// Backend values:
  ///   "en", "fr", "ar", "system"
  ///
  /// null means system/default locale in the Flutter app.
  Locale? _localeFromBackend(String value) {
    if (value.trim().isEmpty || value == 'system') {
      return null;
    }

    return Locale(value);
  }

  /// Converts Flutter Locale to backend languageCode.
  ///
  /// If locale is null, send "system".
  String _languageCodeToBackend(Locale? locale) {
    return locale?.languageCode ?? 'system';
  }
}