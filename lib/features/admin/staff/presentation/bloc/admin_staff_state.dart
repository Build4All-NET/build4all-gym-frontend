// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/bloc/admin_staff_state.dart
//
// STATE DESIGN:
//
// StaffLoaded carries totalStaff + activeStaff because the stats cards must
// always reflect the currently displayed branch filter, not a stale count.
// Every action that mutates the list triggers a full reload so counts stay
// in sync automatically.
//
// StaffActionLoading(staffId):
//   staffId = 0 means the action is a CREATE (no specific card to highlight).
//   staffId > 0 means a specific card's Edit or Remove button is in progress
//   — the card widget checks this to show a per-card spinner.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/admin_staff_card_entity.dart';

abstract class AdminStaffState {
  const AdminStaffState();
}

/// Initial state — shown before StaffStarted is dispatched.
class StaffInitial extends AdminStaffState {
  const StaffInitial();
}

/// Full-screen loading spinner while the list is being fetched.
class StaffLoading extends AdminStaffState {
  const StaffLoading();
}

/// The main state — drives the entire screen.
class StaffLoaded extends AdminStaffState {
  final List<AdminStaffCardEntity> staff;
  final int totalStaff;       // branch-scoped count for stats card
  final int activeStaff;      // branch-scoped count for stats card
  final String? activeSearch; // current search query (used for reload after action)

  const StaffLoaded({
    required this.staff,
    required this.totalStaff,
    required this.activeStaff,
    this.activeSearch,
  });
}

/// Shown when the initial load or a reload fails.
class StaffError extends AdminStaffState {
  final String message;
  const StaffError(this.message);
}

/// Per-card (or global for create) action in progress.
/// The UI checks this to show a spinner on the relevant card's buttons.
class StaffActionLoading extends AdminStaffState {
  final int staffId; // 0 for CREATE action, >0 for edit/remove on a specific card
  const StaffActionLoading(this.staffId);
}

/// Action completed — triggers a green snackbar then a full reload.
class StaffActionSuccess extends AdminStaffState {
  final int staffId;
  final String actionType; // "create" | "update" | "remove" — used for snackbar text
  const StaffActionSuccess(this.staffId, this.actionType);
}

/// Action failed — triggers a red snackbar.
class StaffActionError extends AdminStaffState {
  final int staffId;
  final String message;
  const StaffActionError(this.staffId, this.message);
}