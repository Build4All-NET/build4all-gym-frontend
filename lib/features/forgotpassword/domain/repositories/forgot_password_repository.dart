import '../entities/forgot_password_entity.dart';


abstract class ForgotPasswordRepository {
  Future<InitiateResult> initiateForgotPassword(String identifier);
  Future<VerifyOtpResult> verifyOtp(String identifier, String otpCode);
  Future<ForgotPasswordResult> resetPassword(String resetToken, String newPassword);
}