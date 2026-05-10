import 'package:dio/dio.dart';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

class MemberProfileEditService {
  final Dio _dio;
  final AuthTokenStore _tokenStore;

  MemberProfileEditService({
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
          },
        ),
      ),
        _tokenStore = tokenStore;

  Future<int> _userId() async {
    final userId = await _tokenStore.getUserId();

    if (userId <= 0) {
      throw Exception('Missing user id');
    }

    return userId;
  }

  Future<String> _authHeader() async {
    final token = (await _tokenStore.getToken())?.trim() ?? '';

    if (token.isEmpty) {
      throw Exception('Missing authentication token');
    }

    return token.toLowerCase().startsWith('bearer ')
        ? token
        : 'Bearer $token';
  }

  Future<void> updateBuild4AllProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    final formData = FormData.fromMap({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'username': username.trim(),
      'email': email.trim(),
      'phoneNumber': phoneNumber.trim(),
      'isPublicProfile': true,
      'imageRemoved': false,
    });

    await _dio.put(
      '/api/users/$userId/profile',
      data: formData,
      options: Options(
        headers: {
          'Authorization': auth,
        },
        contentType: Headers.multipartFormDataContentType,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> verifyEmailChange({
    required String code,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    await _dio.post(
      '/api/users/$userId/email-change/verify',
      data: {
        'code': code.trim(),
      },
      options: Options(
        headers: {
          'Authorization': auth,
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> resendEmailChangeCode() async {
    final userId = await _userId();
    final auth = await _authHeader();

    await _dio.post(
      '/api/users/$userId/email-change/resend',
      options: Options(
        headers: {
          'Authorization': auth,
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> sendPasswordResetCode({
    required String email,
    required int ownerProjectLinkId,
  }) async {
    await _dio.post(
      '/api/users/reset-password',
      queryParameters: {
        'ownerProjectLinkId': ownerProjectLinkId.toString(),
      },
      data: {
        'email': email.trim(),
      },
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) async {
    await _dio.post(
      '/api/users/update-password',
      queryParameters: {
        'ownerProjectLinkId': ownerProjectLinkId.toString(),
      },
      data: {
        'email': email.trim(),
        'code': code.trim(),
        'newPassword': newPassword,
      },
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> verifyCurrentPassword({
    required String email,
    required String currentPassword,
    required int ownerProjectLinkId,
  }) async {
    try {
      await _dio.post(
        '/api/auth/user/login',
        data: {
          'email': email.trim(),
          'password': currentPassword,
          'ownerProjectLinkId': ownerProjectLinkId.toString(),
        },
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
          },
          receiveDataWhenStatusError: true,
        ),
      );
    } catch (_) {
      throw Exception('Current password is incorrect.');
    }
  }

  String readError(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = (data['message'] ??
            data['error'] ??
            data['details'] ??
            data['detail'])
            ?.toString()
            .trim();

        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      final msg = error.message?.trim();
      if (msg != null && msg.isNotEmpty) {
        return msg;
      }
    }

    final raw = error.toString().replaceFirst('Exception: ', '').trim();
    return raw.isEmpty ? fallback : raw;
  }
}