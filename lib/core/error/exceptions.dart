// Thrown when the server returns a 4xx or 5xx response
class ServerException implements Exception {
  final String message;
  // Stable backend error code (e.g. "CHECKIN_NOT_FOUND"), when the backend
  // response included one. Null for legacy/unclassified responses — callers
  // must fall back to a generic localized message rather than [message],
  // which may contain raw backend text and must never be shown to users.
  final String? errorCode;
  const ServerException({this.message = 'Server error occurred', this.errorCode});

  @override
  String toString() => message;
}

// Thrown when the JWT token is expired or invalid → 401
class UnauthorizedException implements Exception {
  const UnauthorizedException();

  @override
  String toString() => 'Your session has expired. Please log in again.';
}

// Thrown when the user doesn't have permission → 403
class ForbiddenException implements Exception {
  final String message;
  // Stable backend error code, when the 403 response included one (e.g. a
  // business-rule 403 like "MEMBER_BLOCKED" rather than a bare access-control
  // rejection). Null when the backend didn't classify the rejection.
  final String? errorCode;
  const ForbiddenException({this.message = '', this.errorCode});

  @override
  String toString() =>
      message.isNotEmpty ? message : 'You do not have permission to perform this action.';
}

// Thrown when there is no internet connection or request times out
class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'No internet connection. Please check your network and try again.';
}

// Thrown when local cache/storage fails
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => message;
}

// Thrown by repository layers to carry a failure up to the presentation
// layer without losing the backend's stable `errorCode` the way wrapping in
// a plain `Exception(message)` does. `message` is raw/dev-facing (logging
// only) — presentation code must translate [errorCode] via
// translateBackendErrorCode() rather than display [message] or [toString()].
class AppFailureException implements Exception {
  final String message;
  final String? errorCode;
  const AppFailureException({required this.message, this.errorCode});

  @override
  String toString() => message;
}
