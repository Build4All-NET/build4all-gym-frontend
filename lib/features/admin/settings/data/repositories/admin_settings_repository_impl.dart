// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/data/repositories/admin_settings_repository_impl.dart
//
// PURPOSE:
//   Concrete implementation of the domain's AdminSettingsRepository interface.
//   It sits between the use-cases (domain) and the Dio service (data).
//
// RESPONSIBILITY:
//   1. Call the remote service (Dio).
//   2. Convert the data-layer model ↔ domain entity.
//   3. Catch Dio exceptions and rethrow as meaningful domain exceptions
//      so the cubit never sees raw HTTP errors.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import '../../domain/entities/settings_business_rules_entity.dart';
import '../../domain/repositories/admin_settings_repository.dart';
import '../models/gym_settings_model.dart';
import '../services/admin_settings_remote_service.dart';

class AdminSettingsRepositoryImpl implements AdminSettingsRepository {
  final AdminSettingsRemoteService _service;

  const AdminSettingsRepositoryImpl(this._service);

  // ── getSettings ─────────────────────────────────────────────────────────────

  @override
  Future<SettingsBusinessRulesEntity> getSettings() async {
    try {
      final model = await _service.fetchSettings();
      // Convert data model → domain entity before returning to the use-case
      return model.toEntity();
    } on DioException catch (e) {
      // Wrap DioException so the cubit sees a plain Exception,
      // not a Dio-specific type (keeps domain layer Dio-free).
      throw Exception('Failed to load settings: ${e.message}');
    }
  }

  // ── saveSettings ────────────────────────────────────────────────────────────

  @override
  Future<void> saveSettings(SettingsBusinessRulesEntity rules) async {
    try {
      // Convert domain entity → data model before serializing to JSON
      final model = GymSettingsModel.fromEntity(rules);
      await _service.updateSettings(model);
    } on DioException catch (e) {
      throw Exception('Failed to save settings: ${e.message}');
    }
  }
}
