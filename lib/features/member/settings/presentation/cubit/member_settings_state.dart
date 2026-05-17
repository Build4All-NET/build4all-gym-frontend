// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/cubit/member_settings_state.dart
//
// PURPOSE:
//   Immutable state object for MemberSettingsCubit.
//   Every field that can change on the Member Settings screen lives here.
//
// FIELDS:
//   • isDirty            — true when any setting changed since last save.
//   • status             — loading/loaded/saving/saved/error lifecycle.
//   • selectedThemeMode  — pending theme mode.
//   • pendingLocale      — pending language. null = system/default.
//   • isBiometricEnabled — local biometric preference.
//   • errorMessage       — set when status == error.
//
// SAME STRUCTURE AS ADMIN:
//   AdminSettingsState has the same lifecycle/dirty-state pattern.
//   MemberSettingsState keeps only member-specific fields.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Lifecycle status for the member settings screen.
enum MemberSettingsStatus { loading, loaded, saving, saved, error }

class MemberSettingsState {
  // ── Dirty tracking ──────────────────────────────────────────────────────────

  /// true = at least one field changed since the last successful save.
  final bool isDirty;

  // ── Screen lifecycle ────────────────────────────────────────────────────────

  final MemberSettingsStatus status;
  final String? errorMessage;

  // ── Appearance ──────────────────────────────────────────────────────────────

  /// The theme mode the member selected but has not necessarily saved yet.
  final ThemeMode selectedThemeMode;

  // ── Language ────────────────────────────────────────────────────────────────

  /// null = system/default language.
  final Locale? pendingLocale;

  // ── Account & Security ──────────────────────────────────────────────────────

  /// Biometric preference stored locally.
  final bool isBiometricEnabled;

  const MemberSettingsState({
    required this.isDirty,
    required this.status,
    this.errorMessage,
    required this.selectedThemeMode,
    this.pendingLocale,
    required this.isBiometricEnabled,
  });

  /// Initial state before backend/local settings are loaded.
  factory MemberSettingsState.initial() => const MemberSettingsState(
    isDirty: false,
    status: MemberSettingsStatus.loading,
    selectedThemeMode: ThemeMode.system,
    pendingLocale: null,
    isBiometricEnabled: false,
  );

  /// Returns a copy of this state with only the specified fields replaced.
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

/// Internal sentinel so copyWith can distinguish:
///   • caller did not pass pendingLocale
///   • caller passed null to reset locale to system/default
const _sentinel = Object();