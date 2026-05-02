import '../entities/member_account_entity.dart';
import '../repositories/member_account_repository.dart';

class GetMemberAccountUseCase {
  final MemberAccountRepository _repository;

  GetMemberAccountUseCase(this._repository);

  Future<MemberAccountEntity> call() {
    return _repository.getMemberAccount();
  }
}