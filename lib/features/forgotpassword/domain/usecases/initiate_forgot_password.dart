import '../entities/forgot_password_entity.dart';
import '../repositories/forgot_password_repository.dart';

// One job: trigger step 1
// BLoC calls this → this calls the repo → repo calls the API
class InitiateForgotPassword {
  final ForgotPasswordRepository repo;
  InitiateForgotPassword(this.repo);

  Future<InitiateResult> call(String identifier) {
    return repo.initiateForgotPassword(identifier);
  }
}