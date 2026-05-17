part of 'checkins_bloc.dart';

// =============================================================================
// FILE: checkins_event.dart
// PATH: lib/features/admin/checkins/presentation/bloc/checkins_event.dart
// LAYER: Presentation Layer → BLoC Events
//
// Each event = one user action or lifecycle trigger.
// =============================================================================

abstract class CheckinsEvent {
  const CheckinsEvent();
}

// ── Screen startup / list refresh ─────────────────────────────────────────────

/// Fired on screen open and after any action that should refresh the list.
/// [search] lets us re-apply the current search term after an action.
class LoadTodayCheckins extends CheckinsEvent {
  final String? search;
  const LoadTodayCheckins({this.search});
}

// ── Search ────────────────────────────────────────────────────────────────────

/// Fired by the debounced search bar (400 ms after user stops typing).
class SearchMembers extends CheckinsEvent {
  final String query;
  const SearchMembers(this.query);
}

// ── QR scan ───────────────────────────────────────────────────────────────────

/// Fired by the QR scanner sheet after the camera reads a code.
/// [token] is the UUID string embedded in the QR code.
class ScanQrCode extends CheckinsEvent {
  final String token;
  const ScanQrCode(this.token);
}

// ── Per-member card actions ───────────────────────────────────────────────────

/// Admin presses "Out" on a member card.
class CheckOutMember extends CheckinsEvent {
  final int checkinId;
  const CheckOutMember(this.checkinId);
}

/// Admin confirms the freeze bottom sheet.
class FreezeMember extends CheckinsEvent {
  final int    userId;
  final String fromDate;
  final String toDate;
  final String reason;
  const FreezeMember({
    required this.userId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });
}

/// Admin confirms the block dialog.
class BlockMember extends CheckinsEvent {
  final int    userId;
  final String reason;
  const BlockMember({required this.userId, required this.reason});
}
