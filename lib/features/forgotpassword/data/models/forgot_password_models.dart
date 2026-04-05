// These classes describe the SHAPE of what the backend sends back.
// Backend always replies: { "success": true, "message": "...", "data": {...} }

// ── Wraps every backend response ─────────────────────────────────────────────
class ApiResponse {
  final bool success;
  final String message;
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

// ── Step 1 response data ──────────────────────────────────────────────────────
// Backend sends: { "maskedContact": "jo***@gmail.com", "deliveryMethod": "EMAIL" }
class ForgotPasswordData {
  final String maskedContact;  // "jo***@gmail.com" — shown on Screen 2
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

// ── Step 2 response data ──────────────────────────────────────────────────────
// Backend sends: { "resetToken": "69fe576e-0b23-4e7e-8421-b0baf01439a" }
class VerifyOtpData {
  final String resetToken; // UUID — Flutter stores this and sends it in step 3

  VerifyOtpData({required this.resetToken});

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(resetToken: json['resetToken'] ?? '');
  }
}