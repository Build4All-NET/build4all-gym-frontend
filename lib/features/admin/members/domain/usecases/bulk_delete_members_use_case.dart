

// =============================================================================
// FILE (inline): bulk_delete_members_use_case.dart
// LAYER: Domain Layer → Use Cases
// PURPOSE: Encapsulates the "bulk delete members" operation.
//          BLoC calls this when it handles MembersBulkDeleteRequested event.
// =============================================================================

import '../repositories/admin_members_repository.dart';

class BulkDeleteMembersUseCase {
  final AdminMembersRepository repository;

  BulkDeleteMembersUseCase(this.repository);

  Future<void> call(List<int> userIds) {
    return repository.bulkDeleteMembers(userIds);
  }
}

