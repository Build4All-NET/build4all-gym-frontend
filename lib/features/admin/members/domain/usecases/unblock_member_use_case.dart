

// =============================================================================
// FILE (inline): unblock_member_use_case.dart
// LAYER: Domain Layer → Use Cases
// PURPOSE: Encapsulates the "unblock a member" operation.
//          BLoC calls this when it handles MemberUnblockRequested event.
// =============================================================================

import '../entities/member_card_entity.dart';
import '../repositories/admin_members_repository.dart';

class UnblockMemberUseCase {
  final AdminMembersRepository repository;

  UnblockMemberUseCase(this.repository);

  Future<MemberCardEntity> call(int userId) {
    return repository.unblockMember(userId);
  }
}
