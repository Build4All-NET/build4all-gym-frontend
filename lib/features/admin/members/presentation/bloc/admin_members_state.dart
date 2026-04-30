// =============================================================================
// FILE: admin_members_state.dart
// LAYER: Presentation Layer → BLoC
// PURPOSE: Defines every possible UI state the AdminMembersBloc can emit.
//          The BlocBuilder in AdminMembersPage listens to these and renders
//          the correct widget tree for each state.
//
// STATE LIFECYCLE:
//   App boots             → MembersInitial
//   API call in progress  → MembersLoading  (first page) or same MembersLoaded
//                           (pagination — keep showing existing list + spinner)
//   API call succeeded    → MembersLoaded (accumulates pages for infinite scroll)
//   API call failed       → MembersError
//   Per-card action start → MemberActionLoading (card shows its own spinner)
//   Per-card action done  → MemberActionSuccess (card updates in list)
//   Per-card action fail  → MemberActionError (card shows error snackbar)
//
// RELATED FILES:
//   → Emitted by:   admin_members_bloc.dart
//   ← Listened by:  admin_members_page.dart (BlocBuilder)
//                   member_card_widget.dart  (checks MemberActionLoading)
// =============================================================================

part of 'admin_members_bloc.dart';

/// Base class — all states extend this.
abstract class AdminMembersState {
  const AdminMembersState();
}

// ---------------------------------------------------------------------------
// Default starting state before any API call is made.
// Page shows nothing — BlocProvider immediately dispatches MembersStarted.
// ---------------------------------------------------------------------------
class MembersInitial extends AdminMembersState {
  const MembersInitial();
}

// ---------------------------------------------------------------------------
// Emitted during the FIRST page load (page == 1) to show a full-screen spinner.
// During pagination (page > 1) the BLoC keeps MembersLoaded + adds a footer
// spinner — it does NOT re-emit MembersLoading (avoids list flash).
// ---------------------------------------------------------------------------
class MembersLoading extends AdminMembersState {
  const MembersLoading();
}

// ---------------------------------------------------------------------------
// Emitted when at least one page of members has been fetched successfully.
// The BLoC ACCUMULATES members across pages for infinite scroll.
//
// Fields:
//   members      — the full list shown in the ListView (all pages so far)
//   totalCount   — total matching records (shown in header, e.g. "50 members")
//   currentPage  — the last page number fetched
//   hasNextPage  — whether the ListView should show the "load more" footer
//   activeFilters— current filter state so filter bar can highlight active ones
// ---------------------------------------------------------------------------
class MembersLoaded extends AdminMembersState {
  final List<MemberCardEntity> members;
  final int totalCount;
  final int currentPage;
  final bool hasNextPage;

  /// Snapshot of active filters — used by filter bar to highlight selections.
  final MembersActiveFilters activeFilters;

  const MembersLoaded({
    required this.members,
    required this.totalCount,
    required this.currentPage,
    required this.hasNextPage,
    required this.activeFilters,
  });

  /// Creates a copy with specific fields replaced — used in BLoC when updating
  /// the list after a block/delete action without re-fetching from API.
  MembersLoaded copyWith({
    List<MemberCardEntity>? members,
    int? totalCount,
    int? currentPage,
    bool? hasNextPage,
    MembersActiveFilters? activeFilters,
  }) {
    return MembersLoaded(
      members: members ?? this.members,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

// ---------------------------------------------------------------------------
// Emitted when any API call fails. Page shows an error message + retry button.
// ---------------------------------------------------------------------------
class MembersError extends AdminMembersState {
  final String message;

  const MembersError(this.message);
}

// ---------------------------------------------------------------------------
// Per-card action states — emitted alongside MembersLoaded (not replacing it).
// The MemberCardWidget checks if this state's userId matches its own userId
// before showing a loading indicator or error.
// ---------------------------------------------------------------------------

/// A single card is performing a block/unblock/delete action.
class MemberActionLoading extends AdminMembersState {
  final int userId;

  const MemberActionLoading(this.userId);
}

/// A single card's action completed successfully.
/// actionType: "blocked" | "unblocked" | "deleted"
class MemberActionSuccess extends AdminMembersState {
  final int userId;
  final String actionType;

  const MemberActionSuccess({required this.userId, required this.actionType});
}

/// A single card's action failed.
class MemberActionError extends AdminMembersState {
  final int userId;
  final String message;

  const MemberActionError({required this.userId, required this.message});
}

// ---------------------------------------------------------------------------
// Helper value-object that holds the current filter selections.
// Kept separate so MembersLoaded can carry it and filter bar can read it.
// ---------------------------------------------------------------------------
class MembersActiveFilters {
  final String status; // "" | "active" | "pending" | "blocked"
  final String gender; // "" | "male" | "female" | "other"
  final String sort;   // "newest" | "oldest" | "alphabetical"
  final String search; // current search query string

  const MembersActiveFilters({
    this.status = '',
    this.gender = '',
    this.sort = 'newest',
    this.search = '',
  });

  MembersActiveFilters copyWith({
    String? status,
    String? gender,
    String? sort,
    String? search,
  }) {
    return MembersActiveFilters(
      status: status ?? this.status,
      gender: gender ?? this.gender,
      sort: sort ?? this.sort,
      search: search ?? this.search,
    );
  }
}