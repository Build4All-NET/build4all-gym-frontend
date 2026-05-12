import 'package:dio/dio.dart';
import 'globals.dart' as g;

class ApiClient {
  ApiClient._internal()
      : dio =
      g.appDio ??
          (throw Exception('appDio is null — call makeDefaultDio() first!'));

  /// Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  /// Shared Dio
  final Dio dio;

  /// Optional helper: also keep globals in sync
  void setToken(String token) {
    final normalized = token.startsWith('Bearer ') ? token : 'Bearer $token';

    dio.options.headers['Authorization'] = normalized;
    g.setAuthToken(normalized);
  }
}
