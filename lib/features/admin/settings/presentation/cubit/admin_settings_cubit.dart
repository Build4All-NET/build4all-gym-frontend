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

import '../../../../auth/data/services/biometric_auth_service.dart';
import '../../domain/entities/settings_business_rules_entity.dart';
import '../../domain/usecases/get_admin_settings_usecase.dart';
import 'admin_settings_state.dart';

class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  // ── Dependencies ────────────────────────────────────────────────────────────
  final GetAdminSettingsUseCase _getSettings;
  final SaveAdminSettingsUseCase _saveSettings;
  final BiometricAuthService _biometricService;

  AdminSettingsCubit({
    required GetAdminSettingsUseCase getSettings,
    required SaveAdminSettingsUseCase saveSettings,
    BiometricAuthService? biometricService,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        _biometricService = biometricService ?? BiometricAuthService(),
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
        _getSettings(),               // GET /api/admin/settings
        _biometricService.isEnabled(), // local secure storage
      ]);

      final rules = results[0] as SettingsBusinessRulesEntity;
      final isBiometric = results[1] as bool;

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
  ///
  /// Turning it ON requires a successful device biometric scan first —
  /// otherwise the toggle would claim to be "enabled" without ever having
  /// proven the device can actually authenticate the admin.
  /// Returns false (and leaves the toggle unchanged) if the device has no
  /// usable biometrics or the scan fails/is cancelled.
  Future<bool> setBiometricEnabled(bool value) async {
    if (value) {
      final supported = await _biometricService.isDeviceSupported();
      if (!supported) return false;

      final authenticated = await _biometricService.authenticate(
        'Confirm biometric login for admin access',
      );
      if (!authenticated) return false;
    }

    emit(state.copyWith(isBiometricEnabled: value));
    _markDirty();
    return true;
  }

  // ── Business Rules setters ──────────────────────────────────────────────────

  /// Updates a single business rule toggle without touching the others.
  /// Uses SettingsBusinessRulesEntity.copyWith() for immutable update.
  void updateBusinessRule({
    bool? allowClassWithoutMembership,
    bool? requireMembershipForClass,
    bool? allowMembershipWithoutClass,
    bool? allowBothIndependently,
    bool? allowPtBookingWithoutMembership,
  }) {
    final current = state.businessRules ?? SettingsBusinessRulesEntity.defaults();
    emit(state.copyWith(
      businessRules: current.copyWith(
        allowClassWithoutMembership: allowClassWithoutMembership,
        requireMembershipForClass: requireMembershipForClass,
        allowMembershipWithoutClass: allowMembershipWithoutClass,
        allowBothIndependently: allowBothIndependently,
        allowPtBookingWithoutMembership: allowPtBookingWithoutMembership,
      ),
    ));
    _markDirty();
  }

  void updatePlanRefundWindow(int? hours) {
    final current = state.businessRules ?? SettingsBusinessRulesEntity.defaults();
    emit(state.copyWith(
      businessRules: current.copyWith(planRefundWindowHours: hours),
    ));
    _markDirty();
  }

  void updateClassRefundWindow(int? hours) {
    final current = state.businessRules ?? SettingsBusinessRulesEntity.defaults();
    emit(state.copyWith(
      businessRules: current.copyWith(classRefundWindowHours: hours),
    ));
    _markDirty();
  }

  void updatePtPackageRefundWindow(int? hours) {
    final current = state.businessRules ?? SettingsBusinessRulesEntity.defaults();
    emit(state.copyWith(
      businessRules: current.copyWith(ptPackageRefundWindowHours: hours),
    ));
    _markDirty();
  }

  // ── Save all settings ───────────────────────────────────────────────────────

  /// Persists ALL dirty settings.
  Future<bool> saveSettings() async {
    if (!state.isDirty) return true;

    emit(state.copyWith(status: AdminSettingsStatus.saving));
    try {
      if (state.businessRules != null) {
        await _saveSettings(state.businessRules!);
      }
      await _biometricService.setEnabled(state.isBiometricEnabled);
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

  void _markDirty() {
    if (!state.isDirty) {
      emit(state.copyWith(isDirty: true));
    }
  }
}
