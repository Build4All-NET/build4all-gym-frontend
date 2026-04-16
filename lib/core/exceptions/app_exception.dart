// ─────────────────────────────────────────────────────────────────────────────
// lib/core/exceptions/app_exception.dart
//
// PURPOSE:
//   Base exception class for ALL app-level errors.
//   Any feature-specific exception (AuthException, NetworkException, etc.)
//   extends this so the rest of the app can catch a single type.
//
// RELATIONSHIPS:
//   ◀ Extended by:  NetworkException, AuthException (and any future exceptions)
//   ◀ Consumed by:  ExceptionMapper.toMessage() — reads `code` and `message`
//                   BLoC handlers — caught in try/catch, stored in state.error
// ─────────────────────────────────────────────────────────────────────────────

class AppException implements Exception {
  /// Human-readable message shown to the user (after mapping).
  final String message;

  /// Machine-readable code used for switch-case mapping in ExceptionMapper.
  /// Examples: 'INVALID_CREDENTIALS', 'NETWORK_ERROR', 'SERVER_ERROR'
  final String? code;

  /// The original low-level exception that caused this (DioException,
  /// SocketException, http.Response, etc.). Kept for debugging; never shown
  /// directly to the user.
  final Object? original;

  AppException(this.message, {this.code, this.original});

  @override
  String toString() => 'AppException($code): $message';
}