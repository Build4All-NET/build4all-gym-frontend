// =============================================================================
// FILE: admin_members_state.dart
// PATH: lib/features/admin/members/presentation/bloc/admin_members_state.dart
// TASK: GA-270 — added MemberDetailLoading, MemberDetailLoaded, MemberDetailError
// =============================================================================

part of 'admin_members_bloc.dart';

abstract class AdminMembersState {
  const AdminMembersState();
}

// ── List states ───────────────────────────────────────────────────────────────

class MembersInitial extends AdminMembersState {
  const MembersInitial();
}

class MembersLoading extends AdminMembersState {
  const MembersLoading();
}

class MembersLoaded extends AdminMembersState {
  final List<MemberCardEntity> members;
  final int  totalCount;
  final int  currentPage;
  final bool hasNextPage;
  final MembersActiveFilters activeFilters;

  const MembersLoaded({
    required this.members,
    required this.totalCount,
    required this.currentPage,
    required this.hasNextPage,
    required this.activeFilters,
  });

  MembersLoaded copyWith({
    List<MemberCardEntity>? members,
    int?  totalCount,
    int?  currentPage,
    bool? hasNextPage,
    MembersActiveFilters? activeFilters,
  }) {
    return MembersLoaded(
      members:      members      ?? this.members,
      totalCount:   totalCount   ?? this.totalCount,
      currentPage:  currentPage  ?? this.currentPage,
      hasNextPage:  hasNextPage  ?? this.hasNextPage,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class MembersError extends AdminMembersState {
  final String message;
  const MembersError(this.message);
}

// ── GA-270: Detail states ─────────────────────────────────────────────────────

/// Emitted when getMemberDetail API call is in progress.
class MemberDetailLoading extends AdminMembersState {
  const MemberDetailLoading();
}

/// Emitted when getMemberDetail succeeds.
class MemberDetailLoaded extends AdminMembersState {
  final MemberDetailEntity member;
  const MemberDetailLoaded(this.member);
}

/// Emitted when getMemberDetail fails.
class MemberDetailError extends AdminMembersState {
  final String message;
  const MemberDetailError(this.message);
}

// ── Per-card action states ────────────────────────────────────────────────────

class MemberActionLoading extends AdminMembersState {
  final int userId;
  const MemberActionLoading(this.userId);
}

class MemberActionSuccess extends AdminMembersState {
  final int    userId;
  final String actionType;
  const MemberActionSuccess({required this.userId, required this.actionType});
}

class MemberActionError extends AdminMembersState {
  final int    userId;
  final String message;
  const MemberActionError({required this.userId, required this.message});
}

// ── Filter value object ───────────────────────────────────────────────────────

class MembersActiveFilters {
  final String status;
  final String gender;
  final String sort;
  final String search;

  const MembersActiveFilters({
    this.status = '',
    this.gender = '',
    this.sort   = 'newest',
    this.search = '',
  });

  MembersActiveFilters copyWith({
    String? status, String? gender, String? sort, String? search}) {
    return MembersActiveFilters(
      status: status ?? this.status,
      gender: gender ?? this.gender,
      sort:   sort   ?? this.sort,
      search: search ?? this.search,
    );
  }
}