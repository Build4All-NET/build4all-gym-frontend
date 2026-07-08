import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_member_memberships_usecase.dart';
import 'member_membership_event.dart';
import 'member_membership_state.dart';

/*
 * BLoC responsible for loading the logged-in member's memberships.
 *
 * Flow:
 *
 * Screen
 * -> MemberMembershipEvent
 * -> MemberMembershipBloc
 * -> GetMemberMembershipsUseCase
 * -> Repository
 * -> Service
 * -> GET /api/member/memberships
 */
class MemberMembershipBloc
    extends Bloc<MemberMembershipEvent, MemberMembershipState> {
  final GetMemberMembershipsUseCase getMemberMembershipsUseCase;

  MemberMembershipBloc({
    required this.getMemberMembershipsUseCase,
  }) : super(const MemberMembershipInitial()) {
    on<MemberMembershipStarted>(_onStarted);
    on<MemberMembershipRefreshed>(_onRefreshed);
  }

  /*
   * Called when the screen opens for the first time.
   */
  Future<void> _onStarted(
      MemberMembershipStarted event,
      Emitter<MemberMembershipState> emit,
      ) async {
    await _loadMemberships(
      emit: emit,
      status: event.status,
    );
  }

  /*
   * Called when the user performs pull-to-refresh.
   */
  Future<void> _onRefreshed(
      MemberMembershipRefreshed event,
      Emitter<MemberMembershipState> emit,
      ) async {
    await _loadMemberships(
      emit: emit,
      status: event.status,
    );
  }

  /*
   * Shared loading logic used by both:
   *
   * - initial screen loading
   * - pull-to-refresh
   */
  Future<void> _loadMemberships({
    required Emitter<MemberMembershipState> emit,
    String? status,
  }) async {
    emit(const MemberMembershipLoading());

    try {
      final memberships = await getMemberMembershipsUseCase(
        status: status,
      );

      emit(
        MemberMembershipLoaded(
          memberships: memberships,
        ),
      );
    } catch (_) {
      /*
       * We emit a localization key instead of hardcoded visible text.
       *
       * The screen will later convert this key using AppLocalizations.
       */
      emit(
        const MemberMembershipError(
          message: 'memberMembershipLoadFailed',
        ),
      );
    }
  }
}