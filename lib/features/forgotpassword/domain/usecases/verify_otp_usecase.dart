import 'package:build4allgym/features/forgotpassword/domain/entities/forgot_password_entity.dart';
import 'package:build4allgym/features/forgotpassword/domain/repositories/forgot_password_repository.dart';

// One job: verify OTP and get the resetToken back.BLoC calls verifyOtpUseCase(identifier, otpCode).
class VerifyOtpUseCase {
  final ForgotPasswordRepository repo;
  VerifyOtpUseCase(this.repo);

  Future<VerifyOtpResult> call(String identifier, String otpCode) =>
      repo.verifyOtp(identifier, otpCode);
}