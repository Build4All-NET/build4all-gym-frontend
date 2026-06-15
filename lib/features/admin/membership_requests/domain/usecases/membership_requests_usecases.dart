import '../entities/admin_refund_request_entity.dart';
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

  Future<int> call(int requestId, double amountPaid, {String? notes}) =>
      _repo.approveRequest(requestId, amountPaid, notes: notes);
}

class RejectMembershipRequestUseCase {
  final AdminMembershipRequestsRepository _repo;
  RejectMembershipRequestUseCase(this._repo);

  Future<void> call(int requestId, String reason) =>
      _repo.rejectRequest(requestId, reason);
}

class GetRefundRequestsUseCase {
  final AdminMembershipRequestsRepository _repo;
  GetRefundRequestsUseCase(this._repo);

  Future<List<AdminRefundRequestEntity>> call() => _repo.getRefundRequests();
}

class ApproveRefundRequestUseCase {
  final AdminMembershipRequestsRepository _repo;
  ApproveRefundRequestUseCase(this._repo);

  Future<void> call(int refundId, double refundAmount,
          {double? deductionAmount, String? adminNote}) =>
      _repo.approveRefundRequest(refundId, refundAmount,
          deductionAmount: deductionAmount, adminNote: adminNote);
}

class RejectRefundRequestUseCase {
  final AdminMembershipRequestsRepository _repo;
  RejectRefundRequestUseCase(this._repo);

  Future<void> call(int refundId, String reason) =>
      _repo.rejectRefundRequest(refundId, reason);
}
