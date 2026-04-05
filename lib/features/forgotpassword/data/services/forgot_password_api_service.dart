import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forgot_password_models.dart';

// It sends HTTP requests to the backend and returns the response.
class ForgotPasswordApiService {


  // If testing on a phone: replace with your PC's WiFi IP
  static const String _base = 'http:// 192.168.1.7:8867';

  // ── STEP 1 ────────────────────────────────────────────────────────────────
  // Flutter calls this when user taps "Send OTP"
  // Sends: POST /auth/forgot-password  { "identifier": "john@gmail.com" }
  Future<ForgotPasswordData> initiateForgotPassword(String identifier) async {
    final res = await http.post(
      Uri.parse('$_base/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier}),
    );

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    // If backend returned 400/500, throw the error message
    // GlobalExceptionHandler format: { "status": 400, "message": "..." }
    if (res.statusCode != 200) {
      throw Exception(json['message'] ?? 'Something went wrong');
    }

    // Success format: { "success": true, "message": "...", "data": {...} }
    final apiResp = ApiResponse.fromJson(json);
    return ForgotPasswordData.fromJson(apiResp.data!);
  }

  // ── STEP 2 ────────────────────────────────────────────────────────────────
  // Flutter calls this when user types their OTP and taps "Verify"
  // Sends: POST /auth/verify-otp  { "identifier": "...", "otpCode": "292738" }
  Future<VerifyOtpData> verifyOtp(String identifier, String otpCode) async {
    final res = await http.post(
      Uri.parse('$_base/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier, 'otpCode': otpCode}),
    );

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode != 200) {
      throw Exception(json['message'] ?? 'Invalid or expired OTP');
    }

    final apiResp = ApiResponse.fromJson(json);
    return VerifyOtpData.fromJson(apiResp.data!);
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────
  // Flutter calls this when user types new password and taps "Save"
  // Sends: POST /auth/reset-password  { "resetToken": "...", "newPassword": "..." }
  Future<String> resetPassword(String resetToken, String newPassword) async {
    final res = await http.post(
      Uri.parse('$_base/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'resetToken': resetToken,
        'newPassword': newPassword,
      }),
    );

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode != 200) {
      throw Exception(json['message'] ?? 'Failed to reset password');
    }

    return json['message'] ?? 'Password reset successfully';
  }
}