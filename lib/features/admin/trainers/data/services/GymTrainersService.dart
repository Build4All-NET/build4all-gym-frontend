// FILE: lib/features/admin/trainers/data/services/gym_trainers_service.dart

import 'dart:convert';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/GymTrainerModel.dart';

class GymTrainersService {
  final AuthedHttpClient _client;

  GymTrainersService({AuthedHttpClient? client})
      : _client = client ?? AuthedHttpClient();

  /// GET /api/admin/gym-trainers
  Future<List<GymTrainerModel>> fetchGymTrainers() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/gym-trainers');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((j) => GymTrainerModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw Exception('GET /api/admin/gym-trainers failed: ${response.statusCode}');
  }

  /// POST /api/admin/members/{userId}/gym-role  with role=MEMBER → revokes trainer role
  Future<void> removeGymTrainer(int userId) async {
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/members/$userId/gym-role',
    );
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},  // ← add this
      body: jsonEncode({'role': 'MEMBER'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove trainer role: ${response.statusCode}');
    }
  }
}