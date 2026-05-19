part of 'admin_membership_requests_bloc.dart';

abstract class AdminMembershipRequestsEvent {}

class LoadMembershipRequestsEvent extends AdminMembershipRequestsEvent {}

class ApproveMembershipRequestEvent extends AdminMembershipRequestsEvent {
  final int requestId;
  final double amountPaid;
  final String? notes;
  ApproveMembershipRequestEvent({
    required this.requestId,
    required this.amountPaid,
    this.notes,
  });
}

class RejectMembershipRequestEvent extends AdminMembershipRequestsEvent {
  final int requestId;
  final String reason;
  RejectMembershipRequestEvent({required this.requestId, required this.reason});
}
