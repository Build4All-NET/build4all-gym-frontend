// =============================================================================
// FILE: admin_members_event.dart
// LAYER: Presentation Layer → BLoC
// PURPOSE: Defines every user action or system trigger that the
//          AdminMembersBloc can handle. Each event is an immutable class.
//          Think of events as "commands sent to the BLoC".
//
// EVENT FLOW MAP:
//   User opens page         → MembersStarted  (initial load, pagination)
//   User types in search    → MembersSearchChanged  (debounced in widget)
//   User picks status filter→ MembersStatusFilterChanged
//   User picks sort order   → MembersSortChanged
//   User picks gender filter→ MembersGenderFilterChanged
//   User taps Block icon    → MemberBlockRequested
//   User taps Unblock icon  → MemberUnblockRequested
//   User taps Delete icon   → MemberDeleteRequested
//   User taps Bulk Delete   → MembersBulkDeleteRequested
//
// RELATED FILES:
//   → Handled by:   admin_members_bloc.dart  (one handler per event)
//   ← Dispatched by:
//       admin_members_page.dart    (MembersStarted on init + scroll)
//       members_search_bar_widget.dart (MembersSearchChanged after debounce)
//       members_filter_bar_widget.dart (filter/sort events)
//       member_card_widget.dart    (block / delete / unblock events)
// =============================================================================

part of 'admin_members_bloc.dart';

/// Base class — all events extend this.
abstract class AdminMembersEvent {
  const AdminMembersEvent();
}

// ---------------------------------------------------------------------------
// Triggered on page init and each time the user scrolls to the bottom.
// When page == 1 it's a fresh load (or filter reset), page > 1 is pagination.
// ---------------------------------------------------------------------------
class MembersStarted extends AdminMembersEvent {
  final int branchId;
  final int page;

  const MembersStarted({required this.branchId, this.page = 1});
}

// ---------------------------------------------------------------------------
// Fired by the search bar widget AFTER its 300ms debounce timer fires.
// Always resets to page 1 because the result set changes.
// ---------------------------------------------------------------------------
class MembersSearchChanged extends AdminMembersEvent {
  final String query;

  const MembersSearchChanged(this.query);
}

// ---------------------------------------------------------------------------
// Fired when the user picks a status in the filter bar dropdown.
// value: "active" | "pending" | "blocked" | "" (all)
// ---------------------------------------------------------------------------
class MembersStatusFilterChanged extends AdminMembersEvent {
  final String status;

  const MembersStatusFilterChanged(this.status);
}

// ---------------------------------------------------------------------------
// Fired when the user picks a sort order in the filter bar dropdown.
// value: "newest" | "oldest" | "alphabetical"
// ---------------------------------------------------------------------------
class MembersSortChanged extends AdminMembersEvent {
  final String sort;

  const MembersSortChanged(this.sort);
}

// ---------------------------------------------------------------------------
// Fired when the user picks a gender in the filter bar dropdown.
// value: "male" | "female" | "other" | "" (all)
// ---------------------------------------------------------------------------
class MembersGenderFilterChanged extends AdminMembersEvent {
  final String gender;

  const MembersGenderFilterChanged(this.gender);
}

// ---------------------------------------------------------------------------
// Fired when the user taps the Block icon on a member card.
// reason is required by the backend for audit purposes.
// ---------------------------------------------------------------------------
class MemberBlockRequested extends AdminMembersEvent {
  final int userId;
  final String reason;

  const MemberBlockRequested({required this.userId, required this.reason});
}

// ---------------------------------------------------------------------------
// Fired when the user taps the Unblock icon (Block icon toggled for blocked).
// ---------------------------------------------------------------------------
class MemberUnblockRequested extends AdminMembersEvent {
  final int userId;

  const MemberUnblockRequested(this.userId);
}

// ---------------------------------------------------------------------------
// Fired when the user taps the Delete icon on a member card.
// ---------------------------------------------------------------------------
class MemberDeleteRequested extends AdminMembersEvent {
  final int userId;

  const MemberDeleteRequested(this.userId);
}

// ---------------------------------------------------------------------------
// Fired when the admin selects multiple members and taps Bulk Delete.
// ---------------------------------------------------------------------------
class MembersBulkDeleteRequested extends AdminMembersEvent {
  final List<int> userIds;

  const MembersBulkDeleteRequested(this.userIds);
}