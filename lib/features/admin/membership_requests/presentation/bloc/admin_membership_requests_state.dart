part of 'admin_membership_requests_bloc.dart';

abstract class AdminMembershipRequestsState {}

class AdminMembershipRequestsInitial extends AdminMembershipRequestsState {}

class AdminMembershipRequestsLoading extends AdminMembershipRequestsState {}

class AdminMembershipRequestsLoaded extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final int? actingOnId;
  AdminMembershipRequestsLoaded({required this.requests, this.actingOnId});
}

class AdminMembershipRequestsError extends AdminMembershipRequestsState {
  final String message;
  AdminMembershipRequestsError(this.message);
}

class AdminMembershipRequestsActionSuccess extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final String message;
  AdminMembershipRequestsActionSuccess({required this.requests, required this.message});
}

class AdminMembershipRequestsActionFailure extends AdminMembershipRequestsState {
  final List<MembershipRequestEntity> requests;
  final String message;
  AdminMembershipRequestsActionFailure({required this.requests, required this.message});
}
