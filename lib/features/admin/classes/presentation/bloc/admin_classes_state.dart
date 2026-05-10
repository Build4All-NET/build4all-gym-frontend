// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/bloc/admin_classes_state.dart
//
// PURPOSE:
//   All possible states emitted by AdminClassesBloc.
//   The UI rebuilds whenever the BLoC emits a new state.
//
// IMPORTANT: Multiple state "groups" coexist here:
//   - List states (ClassesLoading, ClassesLoaded, ClassesError)
//     → rebuild the main list screen
//   - Form-options states (ClassFormOptionsLoading, ClassFormOptionsLoaded)
//     → rebuild the dropdowns inside the Add/Edit bottom sheet
//   - Action states (ClassActionLoading, ClassActionSuccess, ClassActionError)
//     → per-card spinners and snackbars
//   - Bookings states (SessionBookingsLoading, SessionBookingsLoaded)
//     → rebuild the bookings bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_class_card_entity.dart';
import '../../domain/entities/class_form_option_item_entity.dart';
import '../../domain/entities/session_booking_item_entity.dart';

abstract class AdminClassesState extends Equatable {
  const AdminClassesState();

  @override
  List<Object?> get props => [];
}

// ── List states ────────────────────────────────────────────────────────────

class ClassesInitial extends AdminClassesState {}

class ClassesLoading extends AdminClassesState {}

class ClassesLoaded extends AdminClassesState {
  final List<AdminClassCardEntity> classes;
  final DateTime selectedDate; // the date currently being viewed

  const ClassesLoaded(this.classes, this.selectedDate);

  @override
  List<Object?> get props => [classes, selectedDate];
}

class ClassesError extends AdminClassesState {
  final String message;
  const ClassesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Form options states (dropdowns inside Add/Edit sheet) ─────────────────

class ClassFormOptionsLoading extends AdminClassesState {}

class ClassFormOptionsLoaded extends AdminClassesState {
  final ClassFormOptionsEntity options;
  const ClassFormOptionsLoaded(this.options);

  @override
  List<Object?> get props => [options];
}

// ── Action states (per-card spinner + snackbar) ───────────────────────────

// Emitted while create/update/cancel API call is in-flight.
// sessionId targets the specific card so only THAT card shows a spinner.
class ClassActionLoading extends AdminClassesState {
  final int sessionId; // 0 when creating (no card exists yet)
  const ClassActionLoading(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

// Emitted on success — triggers a green snackbar and list refresh.
// actionType is e.g. "created", "updated", "cancelled"
class ClassActionSuccess extends AdminClassesState {
  final int    sessionId;
  final String actionType;
  const ClassActionSuccess(this.sessionId, this.actionType);

  @override
  List<Object?> get props => [sessionId, actionType];
}

// Emitted when an action (create/update/cancel) fails — triggers a red snackbar.
class ClassActionError extends AdminClassesState {
  final int    sessionId;
  final String message;
  const ClassActionError(this.sessionId, this.message);

  @override
  List<Object?> get props => [sessionId, message];
}

// ── Bookings states (inside SessionBookingsBottomSheet) ───────────────────

class SessionBookingsLoading extends AdminClassesState {
  final int sessionId;
  const SessionBookingsLoading(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SessionBookingsLoaded extends AdminClassesState {
  final int                         sessionId;
  final List<SessionBookingItemEntity> bookings;
  const SessionBookingsLoaded(this.sessionId, this.bookings);

  @override
  List<Object?> get props => [sessionId, bookings];
}

// admin_classes_state.dart

class SessionBookingsError extends AdminClassesState {
  final int    sessionId;
  final String message;

  const SessionBookingsError({
    required this.sessionId,
    required this.message,
  });

  @override
  List<Object?> get props => [sessionId, message];
}