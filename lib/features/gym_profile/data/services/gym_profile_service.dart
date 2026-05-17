// FILE: lib/features/gym_profile/data/services/gym_profile_service.dart
//
// LAYER: Data — Remote Datasource (Service)
//
// PURPOSE:
//   Makes the HTTP call to GET /api/gym/me on the build4allgym backend.
//   Returns a raw GymProfileModel.
//   AuthedHttpClient auto-injects the JWT — no manual header needed.
//
// CALLED BY:
//   GymProfileRepositoryImpl

import 'dart:convert';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/gym_profile_model.dart';

class GymProfileService {
  final AuthedHttpClient _client;

  GymProfileService({AuthedHttpClient? client})
      : _client = client ?? AuthedHttpClient();

  /// Calls GET /api/gym/me.
  ///
  /// Returns [GymProfileModel] on success.
  /// Throws [Exception] on non-200 or network failure — the repository
  /// catches this and either re-throws or returns the empty entity.
  Future<GymProfileModel> fetchGymProfile() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/gym/me');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GymProfileModel.fromJson(json);
    }

    throw Exception(
      'GET /api/gym/me failed with status ${response.statusCode}',
    );
  }
}