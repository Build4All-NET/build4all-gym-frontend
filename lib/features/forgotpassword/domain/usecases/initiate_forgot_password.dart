import 'package:build4allgym/features/forgotpassword/domain/entities/forgot_password_entity.dart';
import 'package:build4allgym/features/forgotpassword/domain/repositories/forgot_password_repository.dart';

// One job: trigger Step 1.
// BLoC calls this initiateForgotPassword(identifier)→ this calls repo → repo calls API.

class InitiateForgotPassword {
  final ForgotPasswordRepository repo;
  InitiateForgotPassword(this.repo);

  Future<InitiateResult> call(String identifier) =>
      repo.initiateForgotPassword(identifier);
}