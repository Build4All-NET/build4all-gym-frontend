part of 'admin_membership_requests_bloc.dart';

abstract class AdminMembershipRequestsState {}

class AdminMembershipRequestsInitial extends AdminMembershipRequestsState {}

class AdminMembershipRequestsLoading extends AdminMembershipRequestsState {}

class AdminMembershipRequestsLoaded extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final List<AdminRefundRequestEntity> refundRequests;
  final int? actingOnId;
  final int? actingOnRefundId;
  AdminMembershipRequestsLoaded({
    required this.requests,
    required this.refundRequests,
    this.actingOnId,
    this.actingOnRefundId,
  });
}

class AdminMembershipRequestsError extends AdminMembershipRequestsState {
  final String message;
  AdminMembershipRequestsError(this.message);
}

class AdminMembershipRequestsActionSuccess extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final List<AdminRefundRequestEntity> refundRequests;
  final String message;
  final int? invoiceId;
  AdminMembershipRequestsActionSuccess({
    required this.requests,
    required this.refundRequests,
    required this.message,
    this.invoiceId,
  });
}

class AdminMembershipRequestsActionFailure extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final List<AdminRefundRequestEntity> refundRequests;
  final String message;
  AdminMembershipRequestsActionFailure({
    required this.requests,
    required this.refundRequests,
    required this.message,
  });
}
