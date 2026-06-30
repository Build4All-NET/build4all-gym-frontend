import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

class MemberProfileEditService {
  final Dio _dio;
  final AuthTokenStore _tokenStore;

  // Same storage used by MemberHomeScreen to read:
  // user_first_name
  // user_last_name
  // auth_user_json
  final FlutterSecureStorage _storage;

  MemberProfileEditService({
    Dio? dio,
    AuthTokenStore tokenStore = const AuthTokenStore(),
    FlutterSecureStorage storage = const FlutterSecureStorage(),
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
        _tokenStore = tokenStore,
        _storage = storage;

  // ---------------------------------------------------------------------------
  // AUTH HELPERS
  // ---------------------------------------------------------------------------

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
  // UPDATE BUILD4ALL PROFILE
  // ---------------------------------------------------------------------------

  Future<void> updateBuild4AllProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();
    final cleanPhoneNumber = phoneNumber.trim();

    final formData = FormData.fromMap({
      'firstName': cleanFirstName,
      'lastName': cleanLastName,
      'username': cleanUsername,
      'email': cleanEmail,
      'phoneNumber': cleanPhoneNumber,
      'isPublicProfile': true,
      'imageRemoved': false,
    });

    try {
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

      // MemberHomeScreen reads the displayed user information
      // from secure storage. Update the locally cached information
      // after the backend update succeeds.
      await _saveUpdatedUserToStorage(
        firstName: cleanFirstName,
        lastName: cleanLastName,
        username: cleanUsername,
        email: cleanEmail,
        phoneNumber: cleanPhoneNumber,
      );
    } catch (e) {
      throw Exception(
        readError(
          e,
          'Failed to update profile.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE CACHED USER DATA
  // ---------------------------------------------------------------------------

  Future<void> _saveUpdatedUserToStorage({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    await _storage.write(
      key: 'user_first_name',
      value: firstName,
    );

    await _storage.write(
      key: 'user_last_name',
      value: lastName,
    );

    final rawUserJson = await _storage.read(
      key: 'auth_user_json',
    );

    final Map<String, dynamic> userJson = {};

    if (rawUserJson != null && rawUserJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUserJson);

        if (decoded is Map<String, dynamic>) {
          userJson.addAll(decoded);
        } else if (decoded is Map) {
          userJson.addAll(
            decoded.map(
                  (key, value) => MapEntry(
                key.toString(),
                value,
              ),
            ),
          );
        }
      } catch (_) {
        // If the old cached JSON is invalid,
        // recreate a clean object below.
      }
    }

    userJson['firstName'] = firstName;
    userJson['lastName'] = lastName;
    userJson['username'] = username;
    userJson['email'] = email;
    userJson['phoneNumber'] = phoneNumber;

    await _storage.write(
      key: 'auth_user_json',
      value: jsonEncode(userJson),
    );
  }

  // ---------------------------------------------------------------------------
  // EMAIL CHANGE FLOW
  // ---------------------------------------------------------------------------

  Future<void> verifyEmailChange({
    required String code,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    try {
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
        readError(
          e,
          'Invalid or expired email verification code.',
        ),
      );
    }
  }

  Future<void> resendEmailChangeCode() async {
    final userId = await _userId();
    final auth = await _authHeader();

    try {
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
        readError(
          e,
          'Failed to resend email verification code.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PASSWORD CHANGE FLOW
  // ---------------------------------------------------------------------------

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
        readError(
          e,
          'Failed to send password verification code.',
        ),
      );
    }
  }

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
        readError(
          e,
          'Failed to update password.',
        ),
      );
    }
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

  // ---------------------------------------------------------------------------
  // PHONE CHANGE OTP FLOW
  //
  // Correct backend endpoints:
  //
  // POST /api/users/{id}/phone-change/request
  // POST /api/users/{id}/phone-change/verify
  // POST /api/users/{id}/phone-change/resend
  //
  // The old /api/auth/send-verification and
  // /api/auth/user/verify-phone-code endpoints were registration endpoints.
  // They verified a number but did not update the logged-in user's phone.
  // ---------------------------------------------------------------------------

  Future<void> sendPhoneChangeVerificationCode({
    required String phoneNumber,
    required String password,
    required int ownerProjectLinkId,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    try {
      await _dio.post(
        '/api/users/$userId/phone-change/request',
        data: {
          'newPhone': phoneNumber.trim(),
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
        readError(
          e,
          'Failed to send phone verification code.',
        ),
      );
    }
  }

  Future<void> verifyPhoneChangeCode({
    required String phoneNumber,
    required String code,
  }) async {
    final userId = await _userId();
    final auth = await _authHeader();

    try {
      await _dio.post(
        '/api/users/$userId/phone-change/verify',
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

      // The backend updates the real phone number after successful OTP
      // verification. Update the cached phone number as well.
      await _updateCachedPhoneNumber(
        phoneNumber.trim(),
      );
    } catch (e) {
      throw Exception(
        readError(
          e,
          'Invalid or expired phone verification code.',
        ),
      );
    }
  }

  Future<void> resendPhoneChangeCode() async {
    final userId = await _userId();
    final auth = await _authHeader();

    try {
      await _dio.post(
        '/api/users/$userId/phone-change/resend',
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
        readError(
          e,
          'Failed to resend phone verification code.',
        ),
      );
    }
  }

  Future<void> _updateCachedPhoneNumber(
      String phoneNumber,
      ) async {
    final rawUserJson = await _storage.read(
      key: 'auth_user_json',
    );

    final Map<String, dynamic> userJson = {};

    if (rawUserJson != null && rawUserJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUserJson);

        if (decoded is Map<String, dynamic>) {
          userJson.addAll(decoded);
        } else if (decoded is Map) {
          userJson.addAll(
            decoded.map(
                  (key, value) => MapEntry(
                key.toString(),
                value,
              ),
            ),
          );
        }
      } catch (_) {
        // Recreate the cached JSON if the existing value is invalid.
      }
    }

    userJson['phoneNumber'] = phoneNumber;

    await _storage.write(
      key: 'auth_user_json',
      value: jsonEncode(userJson),
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR READER
  // ---------------------------------------------------------------------------

  String readError(
      Object error,
      String fallback,
      ) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = (
            data['message'] ??
                data['error'] ??
                data['details'] ??
                data['detail']
        )
            ?.toString()
            .trim();

        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      final message = error.message?.trim();

      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    final raw = error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();

    return raw.isEmpty ? fallback : raw;
  }
}