//Classes inside:
// InitiateResult: What Step 1 gives the app after OTP is sent. Has maskedContact (shown on Screen 2) and deliveryMethod ("EMAIL" or "PHONE").
// VerifyOtpResult: What Step 2 gives the app after OTP is verified. Has resetToken (UUID that Screen 3 must send to backend).
// ForgotPasswordResult: What Step 3 gives the app after password is reset. Has message ("Password reset successfully") shown as success toast.

// ── After Step 1: what Screen 2 needs ────────────────────────────────────────
class InitiateResult {
  final String maskedContact;  // "jo***@gmail.com" shown on Screen 2
  final String deliveryMethod; // "EMAIL" → "check your email"

  const InitiateResult({
    required this.maskedContact,
    required this.deliveryMethod,
  });
}

// ── After Step 2: what Screen 3 needs ────────────────────────────────────────
class VerifyOtpResult {
  final String resetToken; // UUID that must be sent in step 3

  const VerifyOtpResult({required this.resetToken});
}

// ── After Step 3: just a success message ─────────────────────────────────────
class ForgotPasswordResult {
  final String message;
  const ForgotPasswordResult({required this.message});
}