import 'dart:convert';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/authed_http_client.dart';
import '../models/gym_reception_model.dart';

class GymReceptionService {
  final AuthedHttpClient _client;

  GymReceptionService({AuthedHttpClient? client})
      : _client = client ?? AuthedHttpClient();

  Future<List<GymReceptionModel>> fetchGymReception() async {
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/gym-reception');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((j) => GymReceptionModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw Exception('GET /api/admin/gym-reception failed: ${response.statusCode}');
  }

  Future<void> removeGymReception(int userId) async {
    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/admin/members/$userId/gym-role/remove',
    );
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': 'RECEPTION'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove reception role: ${response.statusCode}');
    }
  }
}
