// ── After Step 1 ──────────────────────────────────────────────────────────────
// Contains what Screen 2 needs to show the user
class InitiateResult {
  final String maskedContact;  // "jo***@gmail.com" shown on Screen 2
  final String deliveryMethod; // "EMAIL" → show "check your email"

  const InitiateResult({
    required this.maskedContact,
    required this.deliveryMethod,
  });
}

// ── After Step 2 ──────────────────────────────────────────────────────────────
// The UUID that Screen 3 must send to the backend
class VerifyOtpResult {
  final String resetToken;

  const VerifyOtpResult({required this.resetToken});
}

// ── After Step 3 ──────────────────────────────────────────────────────────────
// Just a success message — "Password reset successfully"
class ForgotPasswordResult {
  final String message;
  const ForgotPasswordResult({required this.message});
}