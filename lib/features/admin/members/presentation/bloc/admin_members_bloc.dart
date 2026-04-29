// =============================================================================
// FILE: admin_members_bloc.dart
// LAYER: Presentation Layer → BLoC
// PURPOSE: The central controller of the Members feature.
//          Listens to events dispatched by the UI, calls use cases,
//          and emits states that the UI rebuilds from.
//          Contains NO business logic — delegates everything to use cases.
//          Contains NO HTTP code — delegates everything to the repository (via use cases).
//
// POSITION IN FLOW:
//   UI Widget dispatches Event
//     → [this file] AdminMembersBloc event handler
//         → Use Case .call()
//         ← Domain Entity returned
//     → BLoC emits new State
//   BlocBuilder in UI rebuilds widget tree
//
// RELATED FILES:
//   ← Events from: admin_members_event.dart (part of this file)
//   → States to:   admin_members_state.dart (part of this file)
//   → Calls:       members_use_cases.dart (GetMembers, Block, Unblock, Delete, BulkDelete)
//   ← Provided by: admin_members_page.dart via BlocProvider
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_card_entity.dart';
import '../../domain/usecases/block_member_use_case.dart';
import '../../domain/usecases/bulk_delete_members_use_case.dart';
import '../../domain/usecases/delete_member_use_case.dart';
import '../../domain/usecases/get_members_use_case.dart';
import '../../domain/usecases/unblock_member_use_case.dart';


part 'admin_members_event.dart';
part 'admin_members_state.dart';

class AdminMembersBloc extends Bloc<AdminMembersEvent, AdminMembersState> {
  // ---------------------------------------------------------------------------
  // Injected use cases — each handles one specific operation.
  // These are provided by your DI container (e.g. get_it).
  // ---------------------------------------------------------------------------
  final GetMembersUseCase getMembersUseCase;
  final BlockMemberUseCase blockMemberUseCase;
  final UnblockMemberUseCase unblockMemberUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;
  final BulkDeleteMembersUseCase bulkDeleteMembersUseCase;

  /// The branch the admin is currently viewing. Set on init, updated if branch changes.
  final int branchId;

  AdminMembersBloc({
    required this.getMembersUseCase,
    required this.blockMemberUseCase,
    required this.unblockMemberUseCase,
    required this.deleteMemberUseCase,
    required this.bulkDeleteMembersUseCase,
    required this.branchId,
  }) : super(const MembersInitial()) {
    // Register one handler per event type.
    on<MembersStarted>(_onMembersStarted);
    on<MembersSearchChanged>(_onSearchChanged);
    on<MembersStatusFilterChanged>(_onStatusFilterChanged);
    on<MembersSortChanged>(_onSortChanged);
    on<MembersGenderFilterChanged>(_onGenderFilterChanged);
    on<MemberBlockRequested>(_onBlockRequested);
    on<MemberUnblockRequested>(_onUnblockRequested);
    on<MemberDeleteRequested>(_onDeleteRequested);
    on<MembersBulkDeleteRequested>(_onBulkDeleteRequested);
  }

  // ---------------------------------------------------------------------------
  // Helper: reads the current active filters from the last MembersLoaded state,
  // or returns defaults if no loaded state exists yet.
  // ---------------------------------------------------------------------------
  MembersActiveFilters _currentFilters() {
    final s = state;
    if (s is MembersLoaded) return s.activeFilters;
    return const MembersActiveFilters();
  }

  // ---------------------------------------------------------------------------
  // _onMembersStarted — handles initial load AND infinite scroll pagination.
  //
  // Logic:
  //   • page == 1  → fresh load: emit MembersLoading, clear old list.
  //   • page  > 1  → pagination: keep existing list visible, just append.
  //   • Accumulates members across pages for smooth infinite scroll UX.
  // ---------------------------------------------------------------------------
  Future<void> _onMembersStarted(
      MembersStarted event,
      Emitter<AdminMembersState> emit,
      ) async {
    final filters = _currentFilters();
    final isFirstPage = event.page == 1;

    // First page: show full-screen spinner. Subsequent pages: keep current list.
    if (isFirstPage) {
      emit(const MembersLoading());
    }

    try {
      final result = await getMembersUseCase(
        branchId: event.branchId,
        status: filters.status,
        gender: filters.gender,
        search: filters.search,
        sort: filters.sort,
        page: event.page,
      );

      // For pagination, prepend the existing members to the new page.
      final existingMembers = (state is MembersLoaded && !isFirstPage)
          ? (state as MembersLoaded).members
          : <MemberCardEntity>[];

      emit(MembersLoaded(
        members: [...existingMembers, ...result.items],
        totalCount: result.totalCount,
        currentPage: result.page,
        hasNextPage: result.hasNextPage,
        activeFilters: filters,
      ));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Filter/search handlers — all reset to page 1 because the result set changes.
  // ---------------------------------------------------------------------------

  Future<void> _onSearchChanged(
      MembersSearchChanged event,
      Emitter<AdminMembersState> emit,
      ) async {
    // Update filters snapshot then reload from page 1.
    final newFilters = _currentFilters().copyWith(search: event.query);
    emit(const MembersLoading());
    await _reloadWithFilters(newFilters, emit);
  }

  Future<void> _onStatusFilterChanged(
      MembersStatusFilterChanged event,
      Emitter<AdminMembersState> emit,
      ) async {
    final newFilters = _currentFilters().copyWith(status: event.status);
    emit(const MembersLoading());
    await _reloadWithFilters(newFilters, emit);
  }

  Future<void> _onSortChanged(
      MembersSortChanged event,
      Emitter<AdminMembersState> emit,
      ) async {
    final newFilters = _currentFilters().copyWith(sort: event.sort);
    emit(const MembersLoading());
    await _reloadWithFilters(newFilters, emit);
  }

  Future<void> _onGenderFilterChanged(
      MembersGenderFilterChanged event,
      Emitter<AdminMembersState> emit,
      ) async {
    final newFilters = _currentFilters().copyWith(gender: event.gender);
    emit(const MembersLoading());
    await _reloadWithFilters(newFilters, emit);
  }

  /// Shared helper: fetch page 1 with updated filters and emit loaded/error.
  Future<void> _reloadWithFilters(
      MembersActiveFilters filters,
      Emitter<AdminMembersState> emit,
      ) async {
    try {
      final result = await getMembersUseCase(
        branchId: branchId,
        status: filters.status,
        gender: filters.gender,
        search: filters.search,
        sort: filters.sort,
        page: 1,
      );

      emit(MembersLoaded(
        members: result.items,
        totalCount: result.totalCount,
        currentPage: 1,
        hasNextPage: result.hasNextPage,
        activeFilters: filters,
      ));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // _onBlockRequested — blocks a member.
  // Emits MemberActionLoading (card shows spinner) → calls use case
  // → updates the member in the list in-place → emits MemberActionSuccess.
  // ---------------------------------------------------------------------------
  Future<void> _onBlockRequested(
      MemberBlockRequested event,
      Emitter<AdminMembersState> emit,
      ) async {
    emit(MemberActionLoading(event.userId));
    try {
      final updated = await blockMemberUseCase(event.userId, event.reason);
      _emitUpdatedMember(updated, emit);
      emit(MemberActionSuccess(userId: event.userId, actionType: 'blocked'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // _onUnblockRequested — unblocks a member.
  // ---------------------------------------------------------------------------
  Future<void> _onUnblockRequested(
      MemberUnblockRequested event,
      Emitter<AdminMembersState> emit,
      ) async {
    emit(MemberActionLoading(event.userId));
    try {
      final updated = await unblockMemberUseCase(event.userId);
      _emitUpdatedMember(updated, emit);
      emit(MemberActionSuccess(userId: event.userId, actionType: 'unblocked'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // _onDeleteRequested — deletes a member and removes their card from the list.
  // ---------------------------------------------------------------------------
  Future<void> _onDeleteRequested(
      MemberDeleteRequested event,
      Emitter<AdminMembersState> emit,
      ) async {
    emit(MemberActionLoading(event.userId));
    try {
      await deleteMemberUseCase(event.userId);

      // Remove the deleted member from the current loaded list.
      if (state is MembersLoaded) {
        final current = state as MembersLoaded;
        final updatedList = current.members
            .where((m) => m.userId != event.userId)
            .toList();
        emit(current.copyWith(
          members: updatedList,
          totalCount: current.totalCount - 1,
        ));
      }

      emit(MemberActionSuccess(userId: event.userId, actionType: 'deleted'));
    } catch (e) {
      emit(MemberActionError(userId: event.userId, message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // _onBulkDeleteRequested — deletes multiple members and removes all cards.
  // ---------------------------------------------------------------------------
  Future<void> _onBulkDeleteRequested(
      MembersBulkDeleteRequested event,
      Emitter<AdminMembersState> emit,
      ) async {
    try {
      await bulkDeleteMembersUseCase(event.userIds);

      if (state is MembersLoaded) {
        final current = state as MembersLoaded;
        final deletedSet = event.userIds.toSet();
        final updatedList = current.members
            .where((m) => !deletedSet.contains(m.userId))
            .toList();
        emit(current.copyWith(
          members: updatedList,
          totalCount: current.totalCount - event.userIds.length,
        ));
      }
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Helper: replaces a single member in the loaded list after block/unblock.
  // Emits a new MembersLoaded with the one card updated in-place.
  // ---------------------------------------------------------------------------
  void _emitUpdatedMember(
      MemberCardEntity updated,
      Emitter<AdminMembersState> emit,
      ) {
    if (state is MembersLoaded) {
      final current = state as MembersLoaded;
      final updatedList = current.members.map((m) {
        return m.userId == updated.userId ? updated : m;
      }).toList();
      emit(current.copyWith(members: updatedList));
    }
  }
}