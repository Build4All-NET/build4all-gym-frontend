// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/data/models/forgot_password_models.dart
//
// PURPOSE:
//   Data Transfer Object (DTO) that mirrors the raw JSON shape the backend
//   returns for ALL three forgot-password endpoints:
//     POST /api/users/reset-password
//     POST /api/users/verify-reset-code
//     POST /api/users/update-password
//
//   The backend ALWAYS returns: { "success": true, "message": "...", "data": {...} }
//   We only care about "message" here — the rest is ignored at this layer.
//
// SCOPE:
//   Used ONLY inside ForgotPasswordApiService. The repository converts this
//   model into domain entities (ForgotPasswordResult) so nothing above the
//   data layer ever imports this file.
//
// RELATIONSHIPS:
//   ▶ Parsed by:   ForgotPasswordApiService (all 3 methods)
//   ▶ Converted to: ForgotPasswordResult in ForgotPasswordRepositoryImpl
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps the backend's standard response envelope.
/// Only the `message` field is extracted — `success` and `data` are ignored
/// because the repository uses HTTP status codes for success/failure logic.
class ForgotMessageResponse {
  /// The human-readable message from the backend (e.g. "OTP sent successfully").
  final String message;

  ForgotMessageResponse({required this.message});

  /// Parses a raw JSON map from the backend.
  /// Falls back gracefully if both `message` and `error` are absent.
  factory ForgotMessageResponse.fromJson(Map<String, dynamic> json) {
    // Try 'message' first; fall back to 'error' field; default to 'OK'
    final msg = (json['message'] ?? json['error'] ?? '').toString();
    return ForgotMessageResponse(message: msg.isEmpty ? 'OK' : msg);
  }
}