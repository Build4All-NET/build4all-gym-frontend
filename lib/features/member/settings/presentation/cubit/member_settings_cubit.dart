// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/cubit/member_settings_state.dart
// lib/features/member/settings/presentation/cubit/member_settings_cubit.dart
//
// PURPOSE:
//   Member-side settings cubit. Same pattern as AdminSettingsCubit but simpler:
//   NO business rules (those are admin/owner only),
//   NO 2FA toggle (members don't manage 2FA through our app).
//
//   Fields: isDirty, selectedThemeMode, pendingLocale, isBiometricEnabled.
// ─────────────────────────────────────────────────────────────────────────────

// ══════════════════════════════════════════════════════════════════════════════
// PART 1: MemberSettingsState
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum MemberSettingsStatus { loading, loaded, saving, saved, error }

class MemberSettingsState {
  final bool isDirty;
  final MemberSettingsStatus status;
  final String? errorMessage;

  /// Pending theme mode — applied to ThemeCubit only when "Save Changes" is tapped.
  final ThemeMode selectedThemeMode;

  /// Pending locale — null = system default. Applied to LocaleCubit on Save.
  final Locale? pendingLocale;

  /// Biometric toggle — persisted to FlutterSecureStorage on Save.
  final bool isBiometricEnabled;

  const MemberSettingsState({
    required this.isDirty,
    required this.status,
    this.errorMessage,
    required this.selectedThemeMode,
    this.pendingLocale,
    required this.isBiometricEnabled,
  });

  factory MemberSettingsState.initial() => const MemberSettingsState(
    isDirty: false,
    status: MemberSettingsStatus.loading,
    selectedThemeMode: ThemeMode.system,
    pendingLocale: null,
    isBiometricEnabled: false,
  );

  MemberSettingsState copyWith({
    bool? isDirty,
    MemberSettingsStatus? status,
    String? errorMessage,
    ThemeMode? selectedThemeMode,
    Object? pendingLocale = _sentinel,
    bool? isBiometricEnabled,
  }) {
    return MemberSettingsState(
      isDirty: isDirty ?? this.isDirty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
      pendingLocale: identical(pendingLocale, _sentinel)
          ? this.pendingLocale
          : pendingLocale as Locale?,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}

const _sentinel = Object();

// ══════════════════════════════════════════════════════════════════════════════
// PART 2: MemberSettingsCubit
// ══════════════════════════════════════════════════════════════════════════════

class MemberSettingsCubit extends Cubit<MemberSettingsState> {
  static const _biometricKey = 'biometric_enabled';
  final FlutterSecureStorage _secureStorage;

  MemberSettingsCubit({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        super(MemberSettingsState.initial()) {
    _loadInitialData();
  }

  // ── Initialization ──────────────────────────────────────────────────────────

  Future<void> _loadInitialData() async {
    emit(state.copyWith(status: MemberSettingsStatus.loading));
    try {
      // Load biometric flag from secure storage
      final raw = await _secureStorage.read(key: _biometricKey);
      emit(state.copyWith(
        status: MemberSettingsStatus.loaded,
        isBiometricEnabled: raw == 'true',
        isDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MemberSettingsStatus.error, errorMessage: e.toString()));
    }
  }

  // ── Setters (each marks dirty) ──────────────────────────────────────────────

  /// Called by AppearanceSectionWidget — stores pending mode.
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(selectedThemeMode: mode, isDirty: true));
  }

  /// Called by LanguageSectionWidget — stores pending locale.
  void setPendingLocale(Locale? locale) {
    emit(state.copyWith(pendingLocale: locale, isDirty: true));
  }

  /// Called by the biometric toggle row.
  void setBiometricEnabled(bool value) {
    emit(state.copyWith(isBiometricEnabled: value, isDirty: true));
  }

  // ── Save ────────────────────────────────────────────────────────────────────

  /// Persists biometric flag to secure storage.
  /// ThemeCubit and LocaleCubit are updated by the SCREEN after this resolves.
  Future<bool> saveSettings() async {
    if (!state.isDirty) return true;
    emit(state.copyWith(status: MemberSettingsStatus.saving));
    try {
      await _secureStorage.write(
        key: _biometricKey,
        value: state.isBiometricEnabled.toString(),
      );
      emit(state.copyWith(status: MemberSettingsStatus.saved, isDirty: false));
      return true;
    } catch (e) {
      emit(state.copyWith(
          status: MemberSettingsStatus.error, errorMessage: e.toString()));
      return false;
    }
  }
}
