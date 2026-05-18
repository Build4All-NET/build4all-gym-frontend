import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_qr_data.dart';
import '../../domain/usecases/get_member_qr_use_case.dart';
import '../../domain/usecases/refresh_member_qr_use_case.dart';
import 'member_qr_event.dart';
import 'member_qr_state.dart';

/// BLoC for the member QR screen.
///
/// Responsibilities:
/// - load QR screen data
/// - refresh QR manually
/// - auto-refresh QR when expiresAt is reached
/// - expose clean states to the UI
///
/// Full chain:
/// UI
/// -> MemberQrEvent
/// -> MemberQrBloc
/// -> UseCase
/// -> Repository
/// -> Service
/// -> Backend
class MemberQrBloc extends Bloc<MemberQrEvent, MemberQrState> {
  final GetMemberQrUseCase getMemberQrUseCase;
  final RefreshMemberQrUseCase refreshMemberQrUseCase;

  /// Timer used to refresh the QR when the current token expires.
  ///
  /// Example:
  /// Backend returns expiresAt = now + 5 minutes.
  /// This timer waits 5 minutes, then dispatches RefreshMemberQr.
  Timer? _refreshTimer;

  MemberQrBloc({
    required this.getMemberQrUseCase,
    required this.refreshMemberQrUseCase,
  }) : super(const MemberQrInitial()) {
    on<LoadMemberQr>(_onLoadMemberQr);
    on<RefreshMemberQr>(_onRefreshMemberQr);
  }

  /// Handles first screen load.
  ///
  /// Event:
  /// LoadMemberQr
  ///
  /// Backend call:
  /// GET /api/member/qr
  Future<void> _onLoadMemberQr(
      LoadMemberQr event,
      Emitter<MemberQrState> emit,
      ) async {
    emit(const MemberQrLoading());

    final result = await getMemberQrUseCase();

    if (result.failure != null) {
      emit(MemberQrError(message: result.failure!.message));
      return;
    }

    final data = result.data;

    if (data == null) {
      emit(const MemberQrError(message: 'member_qr_empty'));
      return;
    }

    _emitLoadedAndScheduleRefresh(data, emit);
  }

  /// Handles QR refresh.
  ///
  /// Event:
  /// RefreshMemberQr
  ///
  /// Used by:
  /// - pull-to-refresh
  /// - token expiration timer
  ///
  /// Backend calls:
  /// POST /api/member/qr/generate
  /// then GET /api/member/qr
  Future<void> _onRefreshMemberQr(
      RefreshMemberQr event,
      Emitter<MemberQrState> emit,
      ) async {
    final result = await refreshMemberQrUseCase();

    if (result.failure != null) {
      emit(MemberQrError(message: result.failure!.message));
      return;
    }

    final data = result.data;

    if (data == null) {
      emit(const MemberQrError(message: 'member_qr_empty'));
      return;
    }

    _emitLoadedAndScheduleRefresh(data, emit);
  }

  void _emitLoadedAndScheduleRefresh(
      MemberQrData data,
      Emitter<MemberQrState> emit,
      ) {
    emit(
      MemberQrLoaded(
        token: data.token,
        expiresAt: data.expiresAt,
        membershipStatus: data.membershipStatus,
        memberName: data.memberName,
        memberCode: data.memberCode,
        packageName: data.packageName,
        validUntil: data.validUntil,

        /*
       * New backend display fields.
       *
       * These allow the UI to show:
       * - session name
       * - trainer
       * - branch
       * - start/end time
       *
       * If there is no session, backend sends membership or none data.
       */
        accessType: data.accessType,
        accessTitle: data.accessTitle,
        accessSubtitle: data.accessSubtitle,
        accessBranchName: data.accessBranchName,
        accessStartTime: data.accessStartTime,
        accessEndTime: data.accessEndTime,

        recentVisits: data.recentVisits,
        planGymAccessStart: data.planGymAccessStart,
        planGymAccessEnd: data.planGymAccessEnd,
      ),
    );

    _scheduleAutoRefresh(data.expiresAt);
  }

  /// Starts a timer that fires exactly when the QR token expires.
  ///
  /// If expiresAt is already passed, refresh immediately.
  void _scheduleAutoRefresh(DateTime expiresAt) {
    _refreshTimer?.cancel();

    final delay = expiresAt.difference(DateTime.now());

    if (delay.isNegative || delay == Duration.zero) {
      add(const RefreshMemberQr());
      return;
    }

    _refreshTimer = Timer(delay, () {
      add(const RefreshMemberQr());
    });
  }

  /// Cancel timer when BLoC is destroyed.
  ///
  /// Without this, the timer may fire after the screen is closed.
  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}