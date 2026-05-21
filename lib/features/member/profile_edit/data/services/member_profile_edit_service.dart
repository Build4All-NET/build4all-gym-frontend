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

  // ---------------------------------------------------------------------------
  // BUILD4ALL PROFILE UPDATE
  // ---------------------------------------------------------------------------

  Future<void> updateBuild4AllProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final userId = await _userId();
      final auth = await _authHeader();

      final cleanPhone = phoneNumber.trim();

      final formData = FormData.fromMap({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'username': username.trim(),
        'email': email.trim(),

        // Phone is optional in Edit Profile.
        // If empty, do not send it to Build4All.
        if (cleanPhone.isNotEmpty) 'phoneNumber': cleanPhone,

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
    } catch (e) {
      throw Exception(
        readError(e, 'Failed to update profile.'),
      );
    }
  }
  // ---------------------------------------------------------------------------
  // EMAIL CHANGE OTP
  // ---------------------------------------------------------------------------

  Future<void> verifyEmailChange({
    required String code,
  }) async {
    try {
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
    } catch (e) {
      throw Exception(
        readError(e, 'Invalid or expired email verification code.'),
      );
    }
  }

  Future<void> resendEmailChangeCode() async {
    try {
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
    } catch (e) {
      throw Exception(
        readError(e, 'Failed to resend email verification code.'),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PASSWORD OTP FLOW — SAME BUILD4ALL API
  // ---------------------------------------------------------------------------

  // STEP 1:
  // Verify that the user knows the current password.
  //
  // Build4All API:
  // POST /api/auth/user/login
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
    } catch (e) {
      throw Exception(
        readError(e, 'Current password is incorrect.'),
      );
    }
  }

  // STEP 2:
  // Send password reset OTP to the current email.
  //
  // Build4All API:
  // POST /api/users/reset-password?ownerProjectLinkId=...
  Future<void> sendPasswordResetCode({
    required String email,
    required int ownerProjectLinkId,
  }) async {
    try {
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
    } catch (e) {
      throw Exception(
        readError(e, 'Failed to send password verification code.'),
      );
    }
  }

  // STEP 3:
  // Update password after the user enters the OTP.
  //
  // Build4All API:
  // POST /api/users/update-password?ownerProjectLinkId=...
  Future<void> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) async {
    try {
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
    } catch (e) {
      throw Exception(
        readError(e, 'Failed to update password.'),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PHONE CHANGE OTP FLOW — SAME BUILD4ALL API AS ECOMMERCE
  // ---------------------------------------------------------------------------

  // STEP 1:
  // Send OTP to the new phone number.
  //
  // Build4All API:
  // POST /api/auth/send-verification
  Future<void> sendPhoneChangeVerificationCode({
    required String phoneNumber,
    required int ownerProjectLinkId,
  }) async {
    try {
      await _dio.post(
        '/api/auth/send-verification',
        data: {
          'phoneNumber': phoneNumber.trim(),
          'ownerProjectLinkId': ownerProjectLinkId,
        },
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
          },
          receiveDataWhenStatusError: true,
        ),
      );
    } catch (e) {
      throw Exception(
        readError(e, 'Failed to send phone verification code.'),
      );
    }
  }

  // STEP 2:
  // Verify OTP sent to the new phone number.
  //
  // Build4All API:
  // POST /api/auth/user/verify-phone-code
  Future<void> verifyPhoneChangeCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      await _dio.post(
        '/api/auth/user/verify-phone-code',
        data: {
          'phoneNumber': phoneNumber.trim(),
          'code': code.trim(),
        },
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
          },
          receiveDataWhenStatusError: true,
        ),
      );
    } catch (e) {
      throw Exception(
        readError(e, 'Invalid or expired phone verification code.'),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // ERROR READER
  // ---------------------------------------------------------------------------

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