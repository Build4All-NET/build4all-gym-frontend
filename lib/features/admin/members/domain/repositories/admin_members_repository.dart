// =============================================================================
// FILE: admin_members_repository.dart
// LAYER: Domain Layer → Repositories (Abstract Contract)
// PURPOSE: Defines WHAT operations are available for members management,
//          WITHOUT knowing HOW they are implemented (HTTP, cache, mock, etc.).
//          This is the "interface" between domain and data layers.
//          Use cases depend on THIS abstract class, not the concrete impl.
//          This enables easy testing by swapping in a fake repository.
//
// POSITION IN FLOW:
//   Use Cases import [this abstract class]
//   AdminMembersRepositoryImpl (data layer) implements [this abstract class]
//   DI system (get_it) binds: AdminMembersRepository → AdminMembersRepositoryImpl
//
// RELATED FILES:
//   ← Implemented by: admin_members_repository_impl.dart (data layer)
//   → Injected into:  get_members_use_case.dart
//                     block_member_use_case.dart
//                     unblock_member_use_case.dart
//                     delete_member_use_case.dart
//                     bulk_delete_members_use_case.dart
// =============================================================================

import '../entities/member_card_entity.dart';
import '../entities/member_list_result_entity.dart';

abstract class AdminMembersRepository {
  // ---------------------------------------------------------------------------
  // Fetches a paginated, filtered list of members.
  // All filter params are optional strings; empty string = "no filter".
  // ---------------------------------------------------------------------------
  Future<MemberListResultEntity> getMembers({
    required int branchId,
    String status,
    String gender,
    String search,
    String sort,
    int page,
    int size,
  });

  // ---------------------------------------------------------------------------
  // Blocks a member — sets their status to "blocked".
  // reason is mandatory (stored in audit log).
  // Returns the updated entity so BLoC can update the list in place.
  // ---------------------------------------------------------------------------
  Future<MemberCardEntity> blockMember(int userId, String reason);

  // ---------------------------------------------------------------------------
  // Re-activates a previously blocked member.
  // Returns the updated entity.
  // ---------------------------------------------------------------------------
  Future<MemberCardEntity> unblockMember(int userId);

  // ---------------------------------------------------------------------------
  // Permanently deletes a single member record.
  // ---------------------------------------------------------------------------
  Future<void> deleteMember(int userId);

  // ---------------------------------------------------------------------------
  // Permanently deletes multiple members in one API call.
  // ---------------------------------------------------------------------------
  Future<void> bulkDeleteMembers(List<int> userIds);
}