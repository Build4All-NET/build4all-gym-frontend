import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

// One job: send resetToken + new password to the backend
class ResetPasswordUseCase {
  final ForgotPasswordRepository repo;
  ResetPasswordUseCase(this.repo);

  Future<ForgotPasswordResult> call(String resetToken, String newPassword) {
    return repo.resetPassword(resetToken, newPassword);
  }
}