
// =============================================================================
// FILE (inline): block_member_use_case.dart
// LAYER: Domain Layer → Use Cases
// PURPOSE: Encapsulates the "block a member" operation.
//          BLoC calls this when it handles MemberBlockRequested event.
//
// POSITION IN FLOW:
//   AdminMembersBloc (on MemberBlockRequested)
//     → [this] BlockMemberUseCase.call(userId, reason)
//     → AdminMembersRepository.blockMember(userId, reason)
//     ← Updated MemberCardEntity returned
//     ← BLoC emits MemberActionSuccess
// =============================================================================

import '../entities/member_card_entity.dart';
import '../repositories/admin_members_repository.dart';

class BlockMemberUseCase {
  final AdminMembersRepository repository;

  BlockMemberUseCase(this.repository);

  Future<MemberCardEntity> call(int userId, String reason) {
    return repository.blockMember(userId, reason);
  }
}

