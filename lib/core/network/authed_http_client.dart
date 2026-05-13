import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/core/network/auth_refresh_coordinator.dart';

/// A drop-in http.Client replacement that:
///   1. Injects the current access token on every request.
///   2. On 401, silently refreshes the token and retries once.
///
/// Usage — create one instance per service (or share a singleton):
///
///   final _client = AuthedHttpClient();
///   final response = await _client.get(uri, headers: _baseHeaders());
class AuthedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final AdminTokenStore _adminStore;
  final AuthTokenStore _userStore;
  final AuthRefreshCoordinator _coordinator;

  AuthedHttpClient({
    http.Client? inner,
    AdminTokenStore? adminStore,
    AuthTokenStore? userStore,
  })  : _inner = inner ?? http.Client(),
        _adminStore = adminStore ?? const AdminTokenStore(),
        _userStore = userStore ?? const AuthTokenStore(),
        _coordinator = AuthRefreshCoordinator.instance;

  // ── Skip refresh on auth-flow endpoints (avoids infinite loop) ─────────────
  static bool _isAuthPath(Uri uri) {
    final p = uri.path;
    return p.contains('/api/auth/refresh') ||
        p.contains('/api/auth/logout') ||
        p.contains('/api/auth/user/login') ||
        p.contains('/api/auth/user/login-phone') ||
        p.contains('/api/auth/admin/login') ||
        p.contains('/api/auth/manager/login') ||
        p.contains('/api/auth/superadmin/login');
  }

  // ── Detect admin vs member from the JWT role claim ─────────────────────────
  static bool _isAdminToken(String rawJwt) {
    try {
      final parts = rawJwt.split('.');
      if (parts.length < 2) return false;
      final payload = base64Url.normalize(parts[1]);
      final map = jsonDecode(utf8.decode(base64Url.decode(payload)));
      if (map is! Map) return false;

      // Backend JWT stores roles as a List: ["ROLE_ADMIN"], ["ROLE_TRAINER"], etc.
      String roleStr = '';
      final roles = map['roles'];
      if (roles is List && roles.isNotEmpty) {
        roleStr = roles.first.toString().toUpperCase().trim();
      } else {
        // Fallback: singular 'role' field
        roleStr = (map['role'] ?? '').toString().toUpperCase().trim();
      }
      if (roleStr.startsWith('ROLE_')) roleStr = roleStr.substring(5);

      return roleStr == 'OWNER' ||
          roleStr == 'SUPER_ADMIN' ||
          roleStr == 'MANAGER' ||
          roleStr == 'ADMIN';
    } catch (_) {
      return false;
    }
  }

  // ── Get the best available stored token (admin first, then user) ───────────
  Future<String> _storedToken() async {
    final admin = (await _adminStore.getToken())?.trim() ?? '';
    if (admin.isNotEmpty) return admin;
    return (await _userStore.getToken())?.trim() ?? '';
  }

  // ── Refresh based on role; returns new token or null ──────────────────────
  Future<String?> _tryRefresh(String currentRaw) async {
    try {
      if (_isAdminToken(currentRaw)) {
        return await _coordinator.refreshAdmin();
      } else {
        return await _coordinator.refreshUser();
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Buffer body bytes BEFORE first send so we can replay on retry.
    final Uint8List bodySnapshot =
        request is http.Request ? request.bodyBytes : Uint8List(0);

    // Inject current stored token.
    final raw = await _storedToken();
    if (raw.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $raw';
    }

    final response = await _inner.send(request);

    // Not a 401, or it's an auth-flow endpoint — pass through unchanged.
    if (response.statusCode != 401 || _isAuthPath(request.url)) {
      return response;
    }

    // Drain original response to free the connection before retrying.
    await response.stream.drain<void>().catchError((_) {});

    // Try to refresh.
    final newToken = await _tryRefresh(raw);
    if (newToken == null || newToken.isEmpty) {
      // Refresh failed — return synthetic 401 so the service can throw.
      return http.StreamedResponse(
        const Stream.empty(),
        401,
        headers: response.headers,
      );
    }

    // Rebuild the request (can't reuse — it was already finalized/sent).
    final retry = http.Request(request.method, request.url)
      ..headers.addAll(request.headers)
      ..headers['Authorization'] = 'Bearer $newToken';
    if (bodySnapshot.isNotEmpty) retry.bodyBytes = bodySnapshot;

    return _inner.send(retry);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
