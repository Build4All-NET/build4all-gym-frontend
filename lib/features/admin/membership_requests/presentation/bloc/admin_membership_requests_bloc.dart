import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/membership_request_entity.dart';
import '../../domain/usecases/membership_requests_usecases.dart';

part 'admin_membership_requests_event.dart';
part 'admin_membership_requests_state.dart';

class AdminMembershipRequestsBloc
    extends Bloc<AdminMembershipRequestsEvent, AdminMembershipRequestsState> {
  final GetMembershipRequestsUseCase _getRequests;
  final ApproveMembershipRequestUseCase _approve;
  final RejectMembershipRequestUseCase _reject;

  AdminMembershipRequestsBloc({
    required GetMembershipRequestsUseCase getRequests,
    required ApproveMembershipRequestUseCase approve,
    required RejectMembershipRequestUseCase reject,
  })  : _getRequests = getRequests,
        _approve = approve,
        _reject = reject,
        super(AdminMembershipRequestsInitial()) {
    on<LoadMembershipRequestsEvent>(_onLoad);
    on<ApproveMembershipRequestEvent>(_onApprove);
    on<RejectMembershipRequestEvent>(_onReject);
  }

  Future<void> _onLoad(
    LoadMembershipRequestsEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    emit(AdminMembershipRequestsLoading());
    try {
      final requests = await _getRequests();
      emit(AdminMembershipRequestsLoaded(requests: requests));
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
        requests: current.requests, actingOnId: event.requestId));
    try {
      await _approve(event.requestId, event.amountPaid, notes: event.notes);
      final updated =
          current.requests.where((r) => r.requestId != event.requestId).toList();
      emit(AdminMembershipRequestsActionSuccess(
          requests: updated, message: 'تمت الموافقة على الطلب'));
      emit(AdminMembershipRequestsLoaded(requests: updated));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
          requests: current.requests, message: 'حدث خطأ، حاول مجدداً'));
      emit(AdminMembershipRequestsLoaded(requests: current.requests));
    }
  }

  Future<void> _onReject(
    RejectMembershipRequestEvent event,
    Emitter<AdminMembershipRequestsState> emit,
  ) async {
    final current = state;
    if (current is! AdminMembershipRequestsLoaded) return;
    emit(AdminMembershipRequestsLoaded(
        requests: current.requests, actingOnId: event.requestId));
    try {
      await _reject(event.requestId, event.reason);
      final updated =
          current.requests.where((r) => r.requestId != event.requestId).toList();
      emit(AdminMembershipRequestsActionSuccess(
          requests: updated, message: 'تم رفض الطلب'));
      emit(AdminMembershipRequestsLoaded(requests: updated));
    } catch (e) {
      emit(AdminMembershipRequestsActionFailure(
          requests: current.requests, message: 'حدث خطأ، حاول مجدداً'));
      emit(AdminMembershipRequestsLoaded(requests: current.requests));
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.replaceFirst('Exception: ', '') : msg;
  }
}
