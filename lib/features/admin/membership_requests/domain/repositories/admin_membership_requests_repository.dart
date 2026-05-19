import '../entities/membership_request_entity.dart';

abstract class AdminMembershipRequestsRepository {
  Future<List<MembershipRequestEntity>> getRequests({String status = 'PENDING'});
  Future<void> approveRequest(int requestId, double amountPaid, {String? notes});
  Future<void> rejectRequest(int requestId, String reason);
}
