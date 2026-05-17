// =============================================================================
// FILE: admin_members_repository.dart
// PATH: lib/features/admin/members/domain/repositories/admin_members_repository.dart
// LAYER: Domain Layer → Repositories (Abstract Contract)
// TASK: GA-269 — added getMemberDetail()
// =============================================================================

import '../entities/member_attendance_item_entity.dart';
import '../entities/member_card_entity.dart';
import '../entities/member_detail_entity.dart';
import '../entities/member_list_result_entity.dart';

abstract class AdminMembersRepository {

  Future<MemberListResultEntity> getMembers({
    required int branchId,
    String status,
    String gender,
    String search,
    String sort,
    int page,
    int size,
  });

  Future<MemberDetailEntity> getMemberDetail(int userId);

  Future<List<MemberAttendanceItemEntity>> getMemberAttendance(int userId);

  Future<void> blockMember(int userId, String reason);

  Future<void> unblockMember(int userId);

  Future<void> deleteMember(int userId);

  Future<void> bulkDeleteMembers(List<int> userIds);
}