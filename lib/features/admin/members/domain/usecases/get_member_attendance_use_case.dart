import '../entities/member_attendance_item_entity.dart';
import '../repositories/admin_members_repository.dart';

class GetMemberAttendanceUseCase {
  final AdminMembersRepository repository;

  GetMemberAttendanceUseCase(this.repository);

  Future<List<MemberAttendanceItemEntity>> call(int userId) {
    return repository.getMemberAttendance(userId);
  }
}
