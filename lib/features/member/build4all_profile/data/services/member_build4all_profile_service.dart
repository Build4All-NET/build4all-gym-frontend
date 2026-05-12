import 'package:dio/dio.dart';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

import '../models/member_build4all_profile_model.dart';

class MemberBuild4AllProfileService {
  final Dio _dio;
  final AuthTokenStore _tokenStore;

  MemberBuild4AllProfileService({
    Dio? dio,
    AuthTokenStore tokenStore = const AuthTokenStore(),
  })  : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: Env.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ),
        _tokenStore = tokenStore;

  Future<MemberBuild4AllProfileModel> getMyProfile() async {
    final token = (await _tokenStore.getToken())?.trim() ?? '';
    final userId = await _tokenStore.getUserId();

    if (token.isEmpty) {
      throw Exception('Missing authentication token');
    }

    if (userId <= 0) {
      throw Exception('Missing user id');
    }

    final authHeader = token.toLowerCase().startsWith('bearer ')
        ? token
        : 'Bearer $token';

    final response = await _dio.get(
      '/api/users/$userId',
      options: Options(
        headers: {
          'Authorization': authHeader,
        },
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return MemberBuild4AllProfileModel.fromJson(data);
    }

    if (data is Map) {
      return MemberBuild4AllProfileModel.fromJson(
        data.cast<String, dynamic>(),
      );
    }

    throw Exception('Invalid Build4All profile response');
  }
}