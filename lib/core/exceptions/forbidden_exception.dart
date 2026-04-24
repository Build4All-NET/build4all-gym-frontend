import 'app_exception.dart';

// Why this file exists:
// The backend can return HTTP 403 when the user is authenticated
// but does not have permission to access a resource.
//
// Example:
// A normal USER tries to access an ADMIN-only endpoint.
// The backend returns 403, so the app throws ForbiddenException.
//
// This keeps permission errors typed and easy to handle in BLoC/UI.

class ForbiddenException extends AppException {
  ForbiddenException(String message, {Object? original})
      : super(
    message,
    code: 'FORBIDDEN',
    original: original,
  );
}