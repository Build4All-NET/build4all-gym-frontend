import '../entities/my_membership_entity.dart';
import '../repositories/member_plans_repository.dart';

class GetMyMembershipUseCase {
  final MemberPlansRepository repository;

  GetMyMembershipUseCase({required this.repository});

  Future<MyMembershipEntity?> call() {
    return repository.getMyMembership();
  }
}