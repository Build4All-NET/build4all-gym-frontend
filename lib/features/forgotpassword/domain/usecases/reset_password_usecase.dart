import 'package:build4allgym/features/forgotpassword/domain/entities/forgot_password_entity.dart';
import 'package:build4allgym/features/forgotpassword/domain/repositories/forgot_password_repository.dart';

// One job: send resetToken + new password → update the password.
// BLoC calls resetPasswordUseCase(resetToken, newPassword).

class ResetPasswordUseCase {
  final ForgotPasswordRepository repo;
  ResetPasswordUseCase(this.repo);

  Future<ForgotPasswordResult> call(String resetToken, String newPassword) =>
      repo.resetPassword(resetToken, newPassword);
}