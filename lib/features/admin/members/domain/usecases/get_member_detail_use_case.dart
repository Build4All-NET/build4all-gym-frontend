// =============================================================================
// FILE: get_member_detail_use_case.dart
// PATH: lib/features/admin/members/domain/usecases/get_member_detail_use_case.dart
// LAYER: Domain Layer → Use Cases
// TASK: GA-269
// =============================================================================

import '../entities/member_detail_entity.dart';
import '../repositories/admin_members_repository.dart';

class GetMemberDetailUseCase {
  final AdminMembersRepository repository;

  GetMemberDetailUseCase(this.repository);

  Future<MemberDetailEntity> call(int userId) {
    return repository.getMemberDetail(userId);
  }
}