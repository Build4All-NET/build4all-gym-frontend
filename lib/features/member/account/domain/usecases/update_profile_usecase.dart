import '../../data/models/update_profile_request_model.dart';
import '../repositories/member_account_repository.dart';

class UpdateProfileUseCase {
  final MemberAccountRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> call(UpdateProfileRequestModel request) {
    return _repository.updateProfile(request);
  }
}