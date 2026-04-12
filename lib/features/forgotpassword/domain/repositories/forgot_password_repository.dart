import '../entities/forgot_password_entity.dart';

//abstract class, it lists what's available (3 methods) but doesn't tell how the implementation, (repository_impl.dart) tells how.
// it matters for testing

abstract class ForgotPasswordRepository {
  // Step 1: send OTP to email/phone
  Future<InitiateResult> initiateForgotPassword(String identifier);

  // Step 2: verify OTP, get UUID back
  Future<VerifyOtpResult> verifyOtp(String identifier, String otpCode);

  // Step 3: send UUID + new password, update password in DB
  Future<ForgotPasswordResult> resetPassword(
      String resetToken, String newPassword);
}