import '../../domain/entities/admin_refund_request_entity.dart';
import '../../domain/entities/membership_request_entity.dart';
import '../../domain/repositories/admin_membership_requests_repository.dart';
import '../models/membership_request_card_model.dart';
import '../services/admin_membership_requests_service.dart';

class AdminMembershipRequestsRepositoryImpl
    implements AdminMembershipRequestsRepository {
  final AdminMembershipRequestsService _service;

  AdminMembershipRequestsRepositoryImpl(this._service);

  @override
  Future<List<MembershipRequestEntity>> getRequests(
      {String status = 'PENDING'}) async {
    final models = await _service.getRequests(status: status);
    return models.map<MembershipRequestEntity>((MembershipRequestCardModel m) => m.toEntity()).toList();
  }

  @override
  Future<int> approveRequest(int requestId, double amountPaid,
      {String? notes}) async {
    return _service.approveRequest(requestId, amountPaid, notes: notes);
  }

  @override
  Future<void> rejectRequest(int requestId, String reason) async {
    await _service.rejectRequest(requestId, reason);
  }

  @override
  Future<List<AdminRefundRequestEntity>> getRefundRequests(
      {String status = 'pending'}) async {
    return _service.getRefundRequests(status: status);
  }

  @override
  Future<void> approveRefundRequest(int refundId, double refundAmount,
      {double? deductionAmount, String? adminNote}) async {
    await _service.approveRefundRequest(refundId, refundAmount,
        deductionAmount: deductionAmount, adminNote: adminNote);
  }

  @override
  Future<void> rejectRefundRequest(int refundId, String reason) async {
    await _service.rejectRefundRequest(refundId, reason);
  }
}
