import 'app_exception.dart';

// Why this file exists:
// The backend can return HTTP 4xx or 5xx errors.
// These are server/API errors, so we wrap them in ServerException.
//
// Example:
// Backend returns:
// {
//   "message": "Failed to load member home"
// }
//
// The datasource extracts that message and throws:
// ServerException("Failed to load member home")
//
// This keeps backend errors typed and consistent across the app.

class ServerException extends AppException {
  ServerException(String message, {Object? original})
      : super(
    message,
    code: 'SERVER_ERROR',
    original: original,
  );
}