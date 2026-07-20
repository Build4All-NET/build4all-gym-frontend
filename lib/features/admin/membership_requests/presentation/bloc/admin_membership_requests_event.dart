part of 'admin_membership_requests_bloc.dart';

abstract class AdminMembershipRequestsEvent {}

class LoadMembershipRequestsEvent extends AdminMembershipRequestsEvent {}

class ApproveMembershipRequestEvent extends AdminMembershipRequestsEvent {
  final int requestId;
  final double amountPaid;
  final String? notes;
  final String successMessage;
  final String errorMessage;
  ApproveMembershipRequestEvent({
    required this.requestId,
    required this.amountPaid,
    this.notes,
    required this.successMessage,
    required this.errorMessage,
  });
}

class RejectMembershipRequestEvent extends AdminMembershipRequestsEvent {
  final int requestId;
  final String reason;
  final String successMessage;
  final String errorMessage;
  RejectMembershipRequestEvent({
    required this.requestId,
    required this.reason,
    required this.successMessage,
    required this.errorMessage,
  });
}

class ApproveRefundRequestEvent extends AdminMembershipRequestsEvent {
  final int refundId;
  final double refundAmount;
  final double? deductionAmount;
  final String? adminNote;
  final String successMessage;

  // Translates a stable backend errorCode (e.g. REFUND_PROVIDER_NOT_SUPPORTED)
  // into a localized message, used when the approve call succeeds at the
  // HTTP level but the refund itself could not be completed (no refund API
  // available yet for that payment provider).
  final String Function(String? errorCode) translateErrorCode;

  ApproveRefundRequestEvent({
    required this.refundId,
    required this.refundAmount,
    this.deductionAmount,
    this.adminNote,
    required this.successMessage,
    required this.translateErrorCode,
  });
}

class RejectRefundRequestEvent extends AdminMembershipRequestsEvent {
  final int refundId;
  final String reason;
  final String successMessage;
  final String errorMessage;
  RejectRefundRequestEvent({
    required this.refundId,
    required this.reason,
    required this.successMessage,
    required this.errorMessage,
  });
}
