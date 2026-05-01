// =============================================================================
// FILE: block_member_use_case.dart
// CHANGE: return type changed to Future<void> — status patched in BLoC.
// =============================================================================

import '../repositories/admin_members_repository.dart';

class BlockMemberUseCase {
  final AdminMembersRepository repository;

  BlockMemberUseCase(this.repository);

  Future<void> call(int userId, String reason) {
    return repository.blockMember(userId, reason);
  }
}
