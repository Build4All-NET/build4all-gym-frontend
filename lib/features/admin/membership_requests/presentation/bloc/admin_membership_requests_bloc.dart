import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_refund_request_entity.dart';
import '../../domain/entities/membership_request_entity.dart';
import '../../domain/usecases/membership_requests_usecases.dart';

part 'admin_membership_requests_event.dart';
part 'admin_membership_requests_state.dart';

class AdminMembershipRequestsBloc
    extends Bloc<AdminMembershipRequestsEvent, AdminMembershipRequestsState> {
  final GetMembershipRequestsUseCase _getRequests;
  final ApproveMembershipRequestUseCase _approve;
  final RejectMembershipRequestUseCase _reject;
  final GetRefundRequestsUseCase _getRefundRequests;
  final ApproveRefundRequestUseCase _approveRefund;
  final RejectRefundRequestUseCase _rejectRefund;

  AdminMembershipRequestsBloc({
    required GetMembershipRequestsUseCase getRequests,
    required ApproveMembershipRequestUseCase approve,
    required RejectMembershipRequestUseCase reject,
    required GetRefundRequestsUseCase getRefundRequests,
    required ApproveRefundRequestUseCase approveRefund,
    required RejectRefundRequestUseCase rejectRefund,
  })  : _getRequests = getRequests,
        _approve = approve,
        _reject = reject,
        _getRefundRequests = getRefundRequests,
        _approveRefund = approveRefund,
        _rejectRefund = rejectRefund,
        super(AdminMembershipRequestsInitial()) {
    on<LoadMembershipRequestsEvent>(_onLoad);
    on<ApproveMembershipRequestEvent>(_onApprove);
    on<RejectMembershipRequestEvent>(_onReject);
    on<ApproveRefundRequestEvent>(_onApproveRefund);
    on<RejectRefundRequestEvent>(_onRejectRefund);
  }

  Future<void> _onLoad(
    LoadMembershipRequestsEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    emit(AdminMembershipRequestsLoading());
    try {
      final results = await Future.wait([
        _getRequests(),
        _getRefundRequests(),
      ]);
      final allRefunds = results[1] as List<AdminRefundRequestEntity>;
      // PT_PACKAGE refunds are handled in the PT Package Payments screen
      final nonPtRefunds = allRefunds
          .where((r) => r.type != 'PT_PACKAGE')
          .toList();
      emit(AdminMembershipRequestsLoaded(
        requests: results[0] as List<MembershipRequestEntity>,
        refundRequests: nonPtRefunds,
      ));
    } catch (e) {
      emit(AdminMembershipRequestsError(_extractMessage(e)));
    }
  }

  Future<void> _onApprove(
    ApproveMembershipRequestEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    final current = state;
    if (current is! AdminMembershipRequestsLoaded) return;
    emit(AdminMembershipRequestsLoaded(
      requests: current.requests,
      refundRequests: current.refundRequests,
      actingOnId: event.requestId,
    ));
    try {
      final invoiceId =
          await _approve(event.requestId, event.amountPaid, notes: event.notes);
      final updated =
          current.requests.where((r) => r.requestId != event.requestId).toList();
      emit(AdminMembershipRequestsActionSuccess(
        requests: updated,
        refundRequests: current.refundRequests,
        message: event.successMessage,
        invoiceId: invoiceId,
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: updated,
        refundRequests: current.refundRequests,
      ));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
        requests: current.requests,
        refundRequests: current.refundRequests,
        message: _extractMessage(e, fallback: event.errorMessage),
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: current.refundRequests,
      ));
    }
  }

  Future<void> _onReject(
    RejectMembershipRequestEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    final current = state;
    if (current is! AdminMembershipRequestsLoaded) return;
    emit(AdminMembershipRequestsLoaded(
      requests: current.requests,
      refundRequests: current.refundRequests,
      actingOnId: event.requestId,
    ));
    try {
      await _reject(event.requestId, event.reason);
      final updated =
          current.requests.where((r) => r.requestId != event.requestId).toList();
      emit(AdminMembershipRequestsActionSuccess(
        requests: updated,
        refundRequests: current.refundRequests,
        message: event.successMessage,
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: updated,
        refundRequests: current.refundRequests,
      ));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
        requests: current.requests,
        refundRequests: current.refundRequests,
        message: _extractMessage(e, fallback: event.errorMessage),
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: current.refundRequests,
      ));
    }
  }

  Future<void> _onApproveRefund(
    ApproveRefundRequestEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    final current = state;
    if (current is! AdminMembershipRequestsLoaded) return;
    emit(AdminMembershipRequestsLoaded(
      requests: current.requests,
      refundRequests: current.refundRequests,
      actingOnRefundId: event.refundId,
    ));
    try {
      final result = await _approveRefund(
        event.refundId,
        event.refundAmount,
        deductionAmount: event.deductionAmount,
        adminNote: event.adminNote,
      );

      // The HTTP call succeeded, but the refund itself may not have — e.g.
      // PayPal/MPGS have no refund API available yet. That is not a request
      // failure; the request stays in the pending list (still needs manual
      // handling), and the admin must see a clear, distinct message.
      if (!result.succeeded) {
        emit(AdminMembershipRequestsActionFailure(
          requests: current.requests,
          refundRequests: current.refundRequests,
          message: event.translateErrorCode(result.errorCode),
        ));
        emit(AdminMembershipRequestsLoaded(
          requests: current.requests,
          refundRequests: current.refundRequests,
        ));
        return;
      }

      final updated = current.refundRequests
          .where((r) => r.refundId != event.refundId)
          .toList();
      emit(AdminMembershipRequestsActionSuccess(
        requests: current.requests,
        refundRequests: updated,
        message: event.successMessage,
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: updated,
      ));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
        requests: current.requests,
        refundRequests: current.refundRequests,
        message: _extractMessage(e),
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: current.refundRequests,
      ));
    }
  }

  Future<void> _onRejectRefund(
    RejectRefundRequestEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    final current = state;
    if (current is! AdminMembershipRequestsLoaded) return;
    emit(AdminMembershipRequestsLoaded(
      requests: current.requests,
      refundRequests: current.refundRequests,
      actingOnRefundId: event.refundId,
    ));
    try {
      await _rejectRefund(event.refundId, event.reason);
      final updated = current.refundRequests
          .where((r) => r.refundId != event.refundId)
          .toList();
      emit(AdminMembershipRequestsActionSuccess(
        requests: current.requests,
        refundRequests: updated,
        message: event.successMessage,
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: updated,
      ));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
        requests: current.requests,
        refundRequests: current.refundRequests,
        message: _extractMessage(e),
      ));
      emit(AdminMembershipRequestsLoaded(
        requests: current.requests,
        refundRequests: current.refundRequests,
      ));
    }
  }

  String _extractMessage(Object e, {String? fallback}) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['message'] as String?
            ?? data['error'] as String?
            ?? data['detail'] as String?;
        if (msg != null && msg.isNotEmpty) return msg;
      }
      if (data is String && data.isNotEmpty) return data;
      return fallback ?? e.message ?? e.toString();
    }
    final msg = e.toString();
    if (fallback != null) return fallback;
    return msg.startsWith('Exception: ') ? msg.replaceFirst('Exception: ', '') : msg;
  }
}
