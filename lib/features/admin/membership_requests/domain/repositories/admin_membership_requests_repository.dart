import '../entities/admin_refund_request_entity.dart';
import '../entities/membership_request_entity.dart';

abstract class AdminMembershipRequestsRepository {
  Future<List<MembershipRequestEntity>> getRequests({String status = 'PENDING'});
  Future<int> approveRequest(int requestId, double amountPaid, {String? notes});
  Future<void> rejectRequest(int requestId, String reason);

  Future<List<AdminRefundRequestEntity>> getRefundRequests({String status = 'pending'});
  Future<void> approveRefundRequest(int refundId, double refundAmount,
      {double? deductionAmount, String? adminNote});
  Future<void> rejectRefundRequest(int refundId, String reason);
}
