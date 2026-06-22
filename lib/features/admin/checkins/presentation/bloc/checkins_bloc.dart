// =============================================================================
// FILE: checkins_bloc.dart
// PATH: lib/features/admin/checkins/presentation/bloc/checkins_bloc.dart
// LAYER: Presentation Layer → BLoC
//
// PURPOSE:
//   Wires events → use cases → states.
//   The screen and widgets only dispatch events and react to states.
//   Business logic stays in use cases; HTTP stays in the data layer.
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/checkin.dart';
import '../../domain/entities/checkin_stats.dart';
import '../../domain/usecases/checkins_usecases.dart';

part 'checkins_event.dart';
part 'checkins_state.dart';

class CheckinsBloc extends Bloc<CheckinsEvent, CheckinsState> {
  final GetTodayCheckinsUseCase getTodayCheckins;
  final ScanQrCheckinUseCase    scanQrCheckin;
  final CheckOutMemberUseCase   checkOutMember;
  final BlockMemberUseCase      blockMember;

  /// The branch the admin is currently managing.
  /// Seeded from the router (defaults to 1) and corrected to the admin's
  /// home branch — or switched explicitly — via [ChangeBranch].
  int branchId;

  /// Last known search query — remembered so refreshes after actions re-apply it.
  String _lastSearch = '';

  CheckinsBloc({
    required this.getTodayCheckins,
    required this.scanQrCheckin,
    required this.checkOutMember,
    required this.blockMember,
    required this.branchId,
  }) : super(const CheckinsInitial()) {
    on<LoadTodayCheckins>(_onLoad);
    on<SearchMembers>(_onSearch);
    on<ScanQrCode>(_onScanQr);
    on<CheckOutMember>(_onCheckOut);
    on<BlockMember>(_onBlock);
    on<ChangeBranch>(_onChangeBranch);
  }

  // ── LoadTodayCheckins ──────────────────────────────────────────────────────
  Future<void> _onLoad(
      LoadTodayCheckins event, Emitter<CheckinsState> emit) async {
    // Re-use any previous search if the caller didn't supply one.
    final search = event.search ?? _lastSearch;
    _lastSearch  = search;

    if (!event.silent) emit(const CheckinsLoading());
    try {
      final result = await getTodayCheckins(
          branchId: branchId, search: search.isEmpty ? null : search);
      emit(CheckinsLoaded(stats: result.stats, checkins: result.checkins));
    } catch (e) {
      // A silent background poll fails quietly — keep showing the last good
      // list rather than blanking it out over one missed tick.
      if (!event.silent) emit(CheckinsError(e.toString()));
    }
  }

  // ── SearchMembers ──────────────────────────────────────────────────────────
  Future<void> _onSearch(
      SearchMembers event, Emitter<CheckinsState> emit) async {
    _lastSearch = event.query;
    emit(const CheckinsLoading());
    try {
      final result = await getTodayCheckins(
          branchId: branchId,
          search:   event.query.isEmpty ? null : event.query);
      emit(CheckinsLoaded(stats: result.stats, checkins: result.checkins));
    } catch (e) {
      emit(CheckinsError(e.toString()));
    }
  }

  // ── ScanQrCode ─────────────────────────────────────────────────────────────
  Future<void> _onScanQr(
      ScanQrCode event, Emitter<CheckinsState> emit) async {
    try {
      final result = await scanQrCheckin(
          token: event.token, branchId: branchId);
      // Emit success so the sheet can show the snackbar and close.
      emit(CheckinsScanSuccess(result.memberName, checkedOut: result.checkedOut));
      // Then immediately refresh the list so the change appears.
      add(const LoadTodayCheckins());
    } catch (e) {
      emit(CheckinsActionError(e.toString()));
    }
  }

  // ── CheckOutMember ─────────────────────────────────────────────────────────
  Future<void> _onCheckOut(
      CheckOutMember event, Emitter<CheckinsState> emit) async {
    try {
      await checkOutMember(checkinId: event.checkinId, branchId: branchId);
      emit(const CheckinsActionSuccess('Member checked out successfully.'));
      add(const LoadTodayCheckins()); // refresh list
    } catch (e) {
      emit(CheckinsActionError(e.toString()));
    }
  }

  // ── BlockMember ────────────────────────────────────────────────────────────
  Future<void> _onBlock(
      BlockMember event, Emitter<CheckinsState> emit) async {
    try {
      await blockMember(userId: event.userId, reason: event.reason);
      emit(const CheckinsActionSuccess('Member blocked successfully.'));
      add(const LoadTodayCheckins());
    } catch (e) {
      emit(CheckinsActionError(e.toString()));
    }
  }

  // ── ChangeBranch ───────────────────────────────────────────────────────────
  Future<void> _onChangeBranch(
      ChangeBranch event, Emitter<CheckinsState> emit) async {
    if (event.branchId == branchId) return;
    branchId = event.branchId;
    add(const LoadTodayCheckins());
  }
}
