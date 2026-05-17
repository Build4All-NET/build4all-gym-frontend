// =============================================================================
// FILE: admin_members_bloc.dart
// PATH: lib/features/admin/members/presentation/bloc/admin_members_bloc.dart
// TASK: GA-270 — added MemberDetailRequested handler + GetMemberDetailUseCase
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_attendance_item_entity.dart';
import '../../domain/entities/member_card_entity.dart';
import '../../domain/entities/member_detail_entity.dart';
import '../../domain/usecases/block_member_use_case.dart';
import '../../domain/usecases/bulk_delete_members_use_case.dart';
import '../../domain/usecases/delete_member_use_case.dart';
import '../../domain/usecases/get_member_attendance_use_case.dart';
import '../../domain/usecases/get_member_detail_use_case.dart';
import '../../domain/usecases/get_members_use_case.dart';
import '../../domain/usecases/unblock_member_use_case.dart';

part 'admin_members_event.dart';
part 'admin_members_state.dart';

class AdminMembersBloc extends Bloc<AdminMembersEvent, AdminMembersState> {
  final GetMembersUseCase           getMembersUseCase;
  final GetMemberDetailUseCase      getMemberDetailUseCase;
  final GetMemberAttendanceUseCase  getMemberAttendanceUseCase;
  final BlockMemberUseCase          blockMemberUseCase;
  final UnblockMemberUseCase        unblockMemberUseCase;
  final DeleteMemberUseCase         deleteMemberUseCase;
  final BulkDeleteMembersUseCase    bulkDeleteMembersUseCase;
  final int branchId;

  MembersActiveFilters _activeFilters = const MembersActiveFilters();

  AdminMembersBloc({
    required this.getMembersUseCase,
    required this.getMemberDetailUseCase,
    required this.getMemberAttendanceUseCase,
    required this.blockMemberUseCase,
    required this.unblockMemberUseCase,
    required this.deleteMemberUseCase,
    required this.bulkDeleteMembersUseCase,
    required this.branchId,
  }) : super(const MembersInitial()) {
    on<MembersStarted>(_onMembersStarted);
    on<MembersSearchChanged>(_onSearchChanged);
    on<MembersStatusFilterChanged>(_onStatusFilterChanged);
    on<MembersSortChanged>(_onSortChanged);
    on<MembersGenderFilterChanged>(_onGenderFilterChanged);
    on<MemberDetailRequested>(_onMemberDetailRequested);
    on<MemberAttendanceRequested>(_onMemberAttendanceRequested);
    on<MemberBlockRequested>(_onBlockRequested);
    on<MemberUnblockRequested>(_onUnblockRequested);
    on<MemberDeleteRequested>(_onDeleteRequested);
    on<MembersBulkDeleteRequested>(_onBulkDeleteRequested);
  }

  // ---------------------------------------------------------------------------
  // List handlers (unchanged)
  // ---------------------------------------------------------------------------

  Future<void> _onMembersStarted(
      MembersStarted event, Emitter<AdminMembersState> emit) async {
    final isFirstPage = event.page == 1;
    if (isFirstPage) emit(const MembersLoading());
    try {
      final result = await getMembersUseCase(
        branchId: event.branchId,
        status:   _activeFilters.status,
        gender:   _activeFilters.gender,
        search:   _activeFilters.search,
        sort:     _activeFilters.sort,
        page:     event.page,
      );
      final existingMembers = (state is MembersLoaded && !isFirstPage)
          ? (state as MembersLoaded).members
          : <MemberCardEntity>[];
      emit(MembersLoaded(
        members:      [...existingMembers, ...result.items],
        totalCount:   result.totalCount,
        currentPage:  result.page,
        hasNextPage:  result.hasNextPage,
        activeFilters: _activeFilters,
      ));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  Future<void> _onSearchChanged(
      MembersSearchChanged event, Emitter<AdminMembersState> emit) async {
    _activeFilters = _activeFilters.copyWith(search: event.query);
    emit(const MembersLoading());
    await _reloadPage1(emit);
  }

  Future<void> _onStatusFilterChanged(
      MembersStatusFilterChanged event, Emitter<AdminMembersState> emit) async {
    _activeFilters = _activeFilters.copyWith(status: event.status);
    emit(const MembersLoading());
    await _reloadPage1(emit);
  }

  Future<void> _onSortChanged(
      MembersSortChanged event, Emitter<AdminMembersState> emit) async {
    _activeFilters = _activeFilters.copyWith(sort: event.sort);
    emit(const MembersLoading());
    await _reloadPage1(emit);
  }

  Future<void> _onGenderFilterChanged(
      MembersGenderFilterChanged event, Emitter<AdminMembersState> emit) async {
    _activeFilters = _activeFilters.copyWith(gender: event.gender);
    emit(const MembersLoading());
    await _reloadPage1(emit);
  }

  Future<void> _reloadPage1(Emitter<AdminMembersState> emit) async {
    try {
      final result = await getMembersUseCase(
        branchId: branchId,
        status:   _activeFilters.status,
        gender:   _activeFilters.gender,
        search:   _activeFilters.search,
        sort:     _activeFilters.sort,
        page:     1,
      );
      emit(MembersLoaded(
        members:      result.items,
        totalCount:   result.totalCount,
        currentPage:  1,
        hasNextPage:  result.hasNextPage,
        activeFilters: _activeFilters,
      ));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // GA-270: MemberDetailRequested handler
  //
  // Emits MemberDetailLoading → calls use case → MemberDetailLoaded or Error.
  // Does NOT replace the list state — detail states live alongside list states.
  // ---------------------------------------------------------------------------
  Future<void> _onMemberDetailRequested(
      MemberDetailRequested event, Emitter<AdminMembersState> emit) async {
    emit(const MemberDetailLoading());
    try {
      final member = await getMemberDetailUseCase(event.userId);
      emit(MemberDetailLoaded(member));
    } catch (e) {
      emit(MemberDetailError(e.toString()));
    }
  }

  Future<void> _onMemberAttendanceRequested(
      MemberAttendanceRequested event, Emitter<AdminMembersState> emit) async {
    emit(MemberAttendanceLoading(event.userId));
    try {
      final items = await getMemberAttendanceUseCase(event.userId);
      emit(MemberAttendanceLoaded(event.userId, items));
    } catch (e) {
      emit(MemberAttendanceError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Card action handlers (unchanged)
  // ---------------------------------------------------------------------------

  Future<void> _onBlockRequested(
      MemberBlockRequested event, Emitter<AdminMembersState> emit) async {
    emit(MemberActionLoading(event.userId));
    try {
      await blockMemberUseCase(event.userId, event.reason);
      _patchMemberStatus(event.userId, 'blocked', emit);
      emit(MemberActionSuccess(userId: event.userId, actionType: 'blocked'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  Future<void> _onUnblockRequested(
      MemberUnblockRequested event, Emitter<AdminMembersState> emit) async {
    emit(MemberActionLoading(event.userId));
    try {
      await unblockMemberUseCase(event.userId);
      _patchMemberStatus(event.userId, 'active', emit);
      emit(MemberActionSuccess(userId: event.userId, actionType: 'unblocked'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
      MemberDeleteRequested event, Emitter<AdminMembersState> emit) async {
    emit(MemberActionLoading(event.userId));
    try {
      await deleteMemberUseCase(event.userId);
      if (state is MembersLoaded) {
        final current = state as MembersLoaded;
        emit(current.copyWith(
          members:    current.members.where((m) => m.userId != event.userId).toList(),
          totalCount: current.totalCount - 1,
        ));
      }
      emit(MemberActionSuccess(userId: event.userId, actionType: 'deleted'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  Future<void> _onBulkDeleteRequested(
      MembersBulkDeleteRequested event, Emitter<AdminMembersState> emit) async {
    try {
      await bulkDeleteMembersUseCase(event.userIds);
      if (state is MembersLoaded) {
        final current    = state as MembersLoaded;
        final deletedSet = event.userIds.toSet();
        emit(current.copyWith(
          members:    current.members.where((m) => !deletedSet.contains(m.userId)).toList(),
          totalCount: current.totalCount - event.userIds.length,
        ));
      }
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  void _patchMemberStatus(
      int userId, String newStatus, Emitter<AdminMembersState> emit) {
    if (state is MembersLoaded) {
      final current = state as MembersLoaded;
      emit(current.copyWith(
        members: current.members.map((m) =>
        m.userId == userId ? m.copyWith(membershipStatus: newStatus) : m,
        ).toList(),
      ));
    }
  }
}