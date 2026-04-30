

// =============================================================================
// FILE (inline): delete_member_use_case.dart
// LAYER: Domain Layer → Use Cases
// PURPOSE: Encapsulates the "delete a member" operation.
//          BLoC calls this when it handles MemberDeleteRequested event.
// =============================================================================

import '../repositories/admin_members_repository.dart';

class DeleteMemberUseCase {
  final AdminMembersRepository repository;

  DeleteMemberUseCase(this.repository);

  Future<void> call(int userId) {
    return repository.deleteMember(userId);
  }
}
