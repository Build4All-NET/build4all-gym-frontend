part of 'checkins_bloc.dart';

// =============================================================================
// FILE: checkins_state.dart
// PATH: lib/features/admin/checkins/presentation/bloc/checkins_state.dart
// LAYER: Presentation Layer → BLoC States
// =============================================================================

abstract class CheckinsState {
  const CheckinsState();
}

// ── Lifecycle ──────────────────────────────────────────────────────────────────

/// Before any data has been requested.
class CheckinsInitial extends CheckinsState {
  const CheckinsInitial();
}

/// List is being fetched (first load or refresh).
class CheckinsLoading extends CheckinsState {
  const CheckinsLoading();
}

/// List + stats loaded successfully.
class CheckinsLoaded extends CheckinsState {
  final CheckinStats   stats;
  final List<Checkin>  checkins;

  const CheckinsLoaded({required this.stats, required this.checkins});
}

/// An unrecoverable list error (network down, server 500, etc.).
class CheckinsError extends CheckinsState {
  final String message;
  const CheckinsError(this.message);
}

// ── QR scan result ─────────────────────────────────────────────────────────────

/// Scan succeeded — [memberName] is shown in the green snackbar.
class CheckinsScanSuccess extends CheckinsState {
  final String memberName;
  const CheckinsScanSuccess(this.memberName);
}

// ── Card action results ────────────────────────────────────────────────────────

/// Any card action (checkout, freeze, block) succeeded.
/// [message] is shown in a green snackbar.
class CheckinsActionSuccess extends CheckinsState {
  final String message;
  const CheckinsActionSuccess(this.message);
}

/// A card action failed — shown in a red snackbar.
class CheckinsActionError extends CheckinsState {
  final String message;
  const CheckinsActionError(this.message);
}
