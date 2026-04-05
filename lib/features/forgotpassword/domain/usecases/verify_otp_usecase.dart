import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

// One job: verify the OTP and get the resetToken back
class VerifyOtpUseCase {
  final ForgotPasswordRepository repo;
  VerifyOtpUseCase(this.repo);

  Future<VerifyOtpResult> call(String identifier, String otpCode) {
    return repo.verifyOtp(identifier, otpCode);
  }
}