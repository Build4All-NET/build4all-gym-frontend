// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/cubit/admin_settings_state.dart
//
// PURPOSE:
//   Immutable state object for AdminSettingsCubit.
//   Every field that can be changed in the Settings screen lives here.
//   The cubit emits a NEW state object (via copyWith) whenever something changes
//   — Flutter/BlocBuilder then rebuilds only the affected widgets.
//
// FIELDS:
//   • isDirty           — true when any setting changed since last save.
//                         Controls the "Unsaved" badge and Save button enabled state.
//   • status            — loading/loaded/saving/saved/error lifecycle.
//   • selectedThemeMode — pending theme mode (applied only on Save).
//   • pendingLocale     — pending locale (applied only on Save; null = system).
//   • businessRules     — the 4 backend toggles (null while loading).
//   • isBiometricEnabled— biometric toggle state.
//   • isTwoFactorEnabled— 2FA toggle state.
//   • errorMessage      — set when status == error.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../domain/entities/settings_business_rules_entity.dart';

/// Lifecycle status for the settings screen.
enum AdminSettingsStatus { loading, loaded, saving, saved, error }

class AdminSettingsState {
  // ── Dirty tracking ──────────────────────────────────────────────────────────
  /// true = at least one field changed since the last successful save.
  /// Drives the "Unsaved" AppBar badge and Save button enabled/disabled state.
  final bool isDirty;

  // ── Screen lifecycle ────────────────────────────────────────────────────────
  final AdminSettingsStatus status;
  final String? errorMessage;

  // ── Appearance ──────────────────────────────────────────────────────────────
  /// The theme mode the user has selected but NOT yet saved.
  /// ThemeCubit is only updated when "Save Changes" is pressed.
  final ThemeMode selectedThemeMode;

  // ── Language & Region ───────────────────────────────────────────────────────
  /// null = "System Default" — matches LocaleCubit's null convention.
  final Locale? pendingLocale;

  // ── Business Rules (admin/owner only) ───────────────────────────────────────
  /// null while the initial GET /api/admin/settings is in flight.
  final SettingsBusinessRulesEntity? businessRules;

  // ── Account & Security ──────────────────────────────────────────────────────
  final bool isBiometricEnabled;
  final bool isTwoFactorEnabled;

  const AdminSettingsState({
    required this.isDirty,
    required this.status,
    this.errorMessage,
    required this.selectedThemeMode,
    this.pendingLocale,
    this.businessRules,
    required this.isBiometricEnabled,
    required this.isTwoFactorEnabled,
  });

  /// Initial state before any user interaction or API call completes.
  factory AdminSettingsState.initial() => const AdminSettingsState(
    isDirty: false,
    status: AdminSettingsStatus.loading,
    selectedThemeMode: ThemeMode.system,
    pendingLocale: null,
    businessRules: null,
    isBiometricEnabled: false,
    isTwoFactorEnabled: false,
  );

  /// Returns a copy of this state with only the specified fields replaced.
  /// Identical pattern to ThemeState.copyWith() and the rest of the project.
  AdminSettingsState copyWith({
    bool? isDirty,
    AdminSettingsStatus? status,
    String? errorMessage,
    ThemeMode? selectedThemeMode,
    // Use a sentinel to allow setting pendingLocale back to null (system default)
    Object? pendingLocale = _sentinel,
    SettingsBusinessRulesEntity? businessRules,
    bool? isBiometricEnabled,
    bool? isTwoFactorEnabled,
  }) {
    return AdminSettingsState(
      isDirty: isDirty ?? this.isDirty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
      // If the sentinel was passed, keep the current value; otherwise use the new value.
      pendingLocale: identical(pendingLocale, _sentinel)
          ? this.pendingLocale
          : pendingLocale as Locale?,
      businessRules: businessRules ?? this.businessRules,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
    );
  }
}

/// Internal sentinel so copyWith can distinguish "caller passed null" from
/// "caller didn't pass anything" for nullable fields.
const _sentinel = Object();
