import '../entities/membership_request_entity.dart';
import '../repositories/admin_membership_requests_repository.dart';

class GetMembershipRequestsUseCase {
  final AdminMembershipRequestsRepository _repo;
  GetMembershipRequestsUseCase(this._repo);

  Future<List<MembershipRequestEntity>> call({String status = 'PENDING'}) =>
      _repo.getRequests(status: status);
}

class ApproveMembershipRequestUseCase {
  final AdminMembershipRequestsRepository _repo;
  ApproveMembershipRequestUseCase(this._repo);

  Future<void> call(int requestId, double amountPaid, {String? notes}) =>
      _repo.approveRequest(requestId, amountPaid, notes: notes);
}

class RejectMembershipRequestUseCase {
  final AdminMembershipRequestsRepository _repo;
  RejectMembershipRequestUseCase(this._repo);

  Future<void> call(int requestId, String reason) =>
      _repo.rejectRequest(requestId, reason);
}
