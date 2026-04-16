// ─────────────────────────────────────────────────────────────────────────────
// lib/core/exceptions/network_exception.dart
//
// PURPOSE:
//   Specialised AppException for transport-layer failures:
//   no internet, timeout, DNS failure, etc.
//   Does NOT represent HTTP 4xx/5xx errors — those are AuthException or the
//   generic AppException with a status-based message.
//
// RELATIONSHIPS:
//   ▶ Extends:      AppException
//   ◀ Thrown by:    ForgotPasswordApiService._safePost() catch blocks
//   ◀ Caught by:    ForgotPasswordBloc handlers → stored in state.error
//   ◀ Mapped by:    ExceptionMapper.toMessage() via AppException path
// ─────────────────────────────────────────────────────────────────────────────

import 'app_exception.dart';

/// Thrown when a network call fails before receiving an HTTP response.
class NetworkException extends AppException {
  NetworkException(super.message, {super.original})
      : super(code: 'NETWORK_ERROR');
}