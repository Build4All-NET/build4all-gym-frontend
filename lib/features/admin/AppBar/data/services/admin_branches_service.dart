// FILE: lib/features/admin/shared/data/services/admin_branches_service.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../models/branch_option_model.dart';

class AdminBranchesService {
  final AdminTokenStore _tokenStore;

  AdminBranchesService() : _tokenStore = const AdminTokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.getToken();
    if (token == null || token.trim().isEmpty) throw UnauthorizedException();
    return {
      'Authorization':           'Bearer $token',
      'Content-Type':            'application/json',
      'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
    };
  }

  // GET /api/admin/branches
  Future<List<BranchOptionModel>> getBranches() async {
    final headers = await _headers();
    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/admin/branches');
    print('📡 GET $uri'); // ← ADD THIS
    try {
      final r = await http.get(uri, headers: headers);
      print('📥 Status: ${r.statusCode} Body: ${r.body}');
      if (r.statusCode == 401) throw UnauthorizedException();
      if (r.statusCode != 200) {
        throw ServerException(message: 'HTTP ${r.statusCode}');
      }
      final list = jsonDecode(r.body) as List<dynamic>;
      return list
          .map((e) => BranchOptionModel.fromJson(
          e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is UnauthorizedException || e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}
