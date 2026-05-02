// =============================================================================
// FILE: unblock_member_use_case.dart
// CHANGE: return type changed to Future<void> — status patched in BLoC.
// =============================================================================

import '../repositories/admin_members_repository.dart';

class UnblockMemberUseCase {
  final AdminMembersRepository repository;

  UnblockMemberUseCase(this.repository);

  Future<void> call(int userId) {
    return repository.unblockMember(userId);
  }
}