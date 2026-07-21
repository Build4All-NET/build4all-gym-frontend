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

import '../../../../../core/error/exceptions.dart';
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
  /// Null means "All Branches" — stats/list aggregate across the tenant.
  int? branchId;

  /// The date currently shown (null means "today"). Set via [FilterByDate].
  DateTime? selectedDate;

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
    on<FilterByDate>(_onFilterByDate);
  }

  // Extracts the stable backend errorCode from a caught exception, when one
  // is present. UI code must translate this via translateBackendErrorCode()
  // rather than ever displaying the exception's raw message.
  String? _errorCodeOf(Object e) {
    if (e is AppFailureException) return e.errorCode;
    if (e is ServerException) return e.errorCode;
    if (e is ForbiddenException) return e.errorCode;
    return null;
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
          branchId: branchId,
          search:   search.isEmpty ? null : search,
          date:     selectedDate);
      emit(CheckinsLoaded(stats: result.stats, checkins: result.checkins));
    } catch (e) {
      // A silent background poll fails quietly — keep showing the last good
      // list rather than blanking it out over one missed tick.
      if (!event.silent) {
        emit(CheckinsError(e.toString(), errorCode: _errorCodeOf(e) ?? 'CHECKINS_LOAD_FAILED'));
      }
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
          search:   event.query.isEmpty ? null : event.query,
          date:     selectedDate);
      emit(CheckinsLoaded(stats: result.stats, checkins: result.checkins));
    } catch (e) {
      emit(CheckinsError(e.toString(), errorCode: _errorCodeOf(e) ?? 'CHECKINS_LOAD_FAILED'));
    }
  }

  // ── ScanQrCode ─────────────────────────────────────────────────────────────
  Future<void> _onScanQr(
      ScanQrCode event, Emitter<CheckinsState> emit) async {
    final currentBranchId = branchId;
    if (currentBranchId == null) {
      emit(const CheckinsActionError(
          'Select a specific branch to scan QR codes.',
          errorCode: 'CHECKIN_NO_BRANCH_SCAN'));
      return;
    }
    try {
      final result = await scanQrCheckin(
          token: event.token, branchId: currentBranchId);
      emit(CheckinsScanSuccess(result.memberName, checkedOut: result.checkedOut));
      // Call _onLoad directly (not via add) so we own the emit and cannot
      // be beaten by a concurrent background-poll _onLoad overwriting our
      // result with stale data (flutter_bloc 8+ default is concurrent).
      await _onLoad(const LoadTodayCheckins(), emit);
    } catch (e) {
      emit(CheckinsActionError(e.toString(), errorCode: _errorCodeOf(e)));
    }
  }

  // ── CheckOutMember ─────────────────────────────────────────────────────────
  Future<void> _onCheckOut(
      CheckOutMember event, Emitter<CheckinsState> emit) async {
    final currentBranchId = branchId;
    if (currentBranchId == null) {
      emit(const CheckinsActionError(
          'Select a specific branch to check out members.',
          errorCode: 'CHECKIN_NO_BRANCH_CHECKOUT'));
      return;
    }
    try {
      await checkOutMember(checkinId: event.checkinId, branchId: currentBranchId);
      emit(CheckinsActionSuccess(event.successMessage));
      await _onLoad(const LoadTodayCheckins(), emit);
    } catch (e) {
      emit(CheckinsActionError(e.toString(), errorCode: _errorCodeOf(e)));
    }
  }

  // ── BlockMember ────────────────────────────────────────────────────────────
  Future<void> _onBlock(
      BlockMember event, Emitter<CheckinsState> emit) async {
    try {
      await blockMember(userId: event.userId, reason: event.reason);
      emit(CheckinsActionSuccess(event.successMessage));
      await _onLoad(const LoadTodayCheckins(), emit);
    } catch (e) {
      emit(CheckinsActionError(e.toString(), errorCode: _errorCodeOf(e)));
    }
  }

  // ── ChangeBranch ───────────────────────────────────────────────────────────
  Future<void> _onChangeBranch(
      ChangeBranch event, Emitter<CheckinsState> emit) async {
    if (event.branchId == branchId) return;
    branchId = event.branchId;
    add(const LoadTodayCheckins());
  }

  // ── FilterByDate ───────────────────────────────────────────────────────────
  Future<void> _onFilterByDate(
      FilterByDate event, Emitter<CheckinsState> emit) async {
    selectedDate = event.date;
    add(const LoadTodayCheckins());
  }
}
