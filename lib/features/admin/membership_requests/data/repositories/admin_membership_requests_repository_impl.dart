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
  Future<void> approveRequest(int requestId, double amountPaid,
      {String? notes}) async {
    await _service.approveRequest(requestId, amountPaid, notes: notes);
  }

  @override
  Future<void> rejectRequest(int requestId, String reason) async {
    await _service.rejectRequest(requestId, reason);
  }
}
