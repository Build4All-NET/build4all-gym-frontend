// Thrown when the server returns a 4xx or 5xx response
class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server error occurred'});
}

// Thrown when the JWT token is expired or invalid → 401
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

// Thrown when the user doesn't have permission → 403
class ForbiddenException implements Exception {
  const ForbiddenException();
}

// Thrown when there is no internet connection or request times out
class NetworkException implements Exception {
  const NetworkException();
}

// Thrown when local cache/storage fails
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error occurred'});
}