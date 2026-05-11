// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/data/services/admin_settings_remote_service.dart
//
// PURPOSE:
//   Raw HTTP layer. Makes the actual Dio calls to our build4all_gym backend
//   (Env.apiProjectBaseUrl — NOT the build4all platform apiBaseUrl).
//
// ENDPOINTS (from the backend AdminSettingsController):
//   GET  /api/admin/settings  → returns GymSettingsDto JSON
//   PUT  /api/admin/settings  → body: GymSettingsDto JSON, returns { message }
//
// AUTH:
//   The appDio instance (from globals.dart) already has the JWT injected by
//   AuthBodyInjector and RefreshTokenInterceptor — no manual token handling here.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../models/gym_settings_model.dart';

class AdminSettingsRemoteService {
  /// Base URL for our gym backend (build4all_gym spring boot project).
  static const _basePath = '/api/admin/settings';

  /// The Dio instance from globals already has auth headers + interceptors.
  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: Env.apiProjectBaseUrl));

  // ── GET /api/admin/settings ─────────────────────────────────────────────────

  /// Fetches the current gym business-rule settings.
  /// The backend uses an upsert-on-first-GET pattern, so this never returns 404.
  Future<GymSettingsModel> fetchSettings() async {
    final response = await _dio.get(
      '${Env.apiProjectBaseUrl}$_basePath',
    );
    // response.data is already decoded from JSON by Dio
    return GymSettingsModel.fromJson(response.data as Map<String, dynamic>);
  }

  // ── PUT /api/admin/settings ─────────────────────────────────────────────────

  /// Sends the updated settings to the backend.
  /// The backend requires ALL 4 fields (no partial patch) — enforced by @NotNull.
  Future<void> updateSettings(GymSettingsModel model) async {
    await _dio.put(
      '${Env.apiProjectBaseUrl}$_basePath',
      data: model.toJson(),
    );
    // On success the backend returns { "message": "Settings updated successfully" }
    // We don't need to parse it — void return is sufficient.
  }
}
