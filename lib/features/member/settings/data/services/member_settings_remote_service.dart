// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/data/services/member_settings_remote_service.dart
//
// PURPOSE:
//   Remote service for member settings.
//   This is the only class in the feature that talks directly to the backend.
//
// ENDPOINTS:
//   GET  /api/member/settings
//   PUT  /api/member/settings
//
// AUTH:
//   appDio already handles authentication headers and interceptors.
//   We do not manually pass the JWT here.
//
// SAME STRUCTURE AS ADMIN:
//   AdminSettingsRemoteService talks to /api/admin/settings.
//   MemberSettingsRemoteService talks to /api/member/settings.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../models/member_settings_model.dart';

class MemberSettingsRemoteService {
  static const String _path = '/api/member/settings';

  /// Uses the global authenticated Dio instance when available.
  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: Env.apiProjectBaseUrl));

  // ── GET /api/member/settings ───────────────────────────────────────────────

  /// Fetches the connected member's language/theme settings.
  Future<MemberSettingsModel> fetchSettings() async {
    final response = await _dio.get(
      '${Env.apiProjectBaseUrl}$_path',
    );

    return MemberSettingsModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // ── PUT /api/member/settings ───────────────────────────────────────────────

  /// Updates the connected member's language/theme settings.
  Future<void> updateSettings(MemberSettingsModel model) async {
    await _dio.put(
      '${Env.apiProjectBaseUrl}$_path',
      data: model.toJson(),
    );
  }
}