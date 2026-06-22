// Thrown when the server returns a 4xx or 5xx response
class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server error occurred'});

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
  const ForbiddenException({this.message = ''});

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
