import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/signup_request.dart';
import '../models/signup_response.dart';
import '../models/verify_signup_request.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8966/api/v1/signup';

  Future<SignupResponse> signup(SignupRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignupResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }

  Future<SignupResponse> verifySignup(VerifySignupRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignupResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Verification failed');
    }
  }
}