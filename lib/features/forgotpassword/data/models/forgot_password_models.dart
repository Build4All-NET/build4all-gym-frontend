
// Backend always replies: { "success": true, "message": "...", "data": {...} }

// ── Wraps EVERY backend response ─────────────────────────────────────────────
// Used for all 3 steps — the outer shell is always the same

//Only used inside forgot_password_api_service.dart.
//The repository converts these models into entities so the rest of the app never touches them.

class ApiResponse {
  final bool success;       // true = OK, false = error
  final String message;     // "OTP sent successfully" etc.
  final Map<String, dynamic>? data; // the actual payload — different each step

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}

// ── Step 1 response: what's inside "data" ────────────────────────────────────
// Backend: { "maskedContact": "jo***@gmail.com", "deliveryMethod": "EMAIL" }
class ForgotPasswordData {
  final String maskedContact;  // shown on Screen 2: "Check jo***@gmail.com"
  final String deliveryMethod; // "EMAIL" or "PHONE"

  ForgotPasswordData({
    required this.maskedContact,
    required this.deliveryMethod,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      maskedContact: json['maskedContact'] ?? '',
      deliveryMethod: json['deliveryMethod'] ?? 'EMAIL',
    );
  }
}

// ── Step 2 response: what's inside "data" ────────────────────────────────────
// Backend: { "resetToken": "69fe576e-0b23-4e7e-8421-b0baf01439a" }
class VerifyOtpData {
  final String resetToken; // UUID — Flutter MUST store this and send in step 3

  VerifyOtpData({required this.resetToken});

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(resetToken: json['resetToken'] ?? '');
  }
}