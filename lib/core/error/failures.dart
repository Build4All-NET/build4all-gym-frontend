// Base class — every failure in the app extends this
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Server returned an error response
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// No internet / request timed out
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

// Token expired or invalid credentials
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

// User doesn't have permission
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(String message) : super(message);
}

// Local storage error
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}