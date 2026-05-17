// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/bloc/admin_classes_event.dart
//
// PURPOSE:
//   All events that can be dispatched to AdminClassesBloc.
//   Events are dispatched by the UI (widgets/screens) and handled by the BLoC.
//   Each event maps to exactly one handler in admin_classes_bloc.dart.
//
// NAMING CONVENTION: [Subject][Action] — e.g. ClassesStarted, ClassCancelRequested
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';
import '../../data/models/create_class_request_model.dart';
import '../../data/models/update_class_request_model.dart';

abstract class AdminClassesEvent extends Equatable {
  const AdminClassesEvent();

  @override
  List<Object?> get props => [];
}

// ── ClassesStarted ─────────────────────────────────────────────────────────
// Dispatched in initState of AdminClassesScreen with DateTime.now().
// Also re-dispatched after create/update/cancel to refresh the list.
class ClassesStarted extends AdminClassesEvent {
  final DateTime date;
  const ClassesStarted(this.date);

  @override
  List<Object?> get props => [date];
}

// ── ClassesDateChanged ─────────────────────────────────────────────────────
// Dispatched when admin taps a date chip in ClassDateFilterWidget.
// Triggers a fresh getClassesByDate call with the new date.
class ClassesDateChanged extends AdminClassesEvent {
  final DateTime date;
  const ClassesDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

// ── ClassFormOptionsRequested ──────────────────────────────────────────────
// Dispatched when the Add/Edit bottom sheet opens.
// Triggers loading of all three dropdowns (types, trainers, branches).
class ClassFormOptionsRequested extends AdminClassesEvent {
  final int? branchId; // optional — currently unused but available for future filtering
  const ClassFormOptionsRequested({this.branchId});

  @override
  List<Object?> get props => [branchId];
}

// ── ClassCreateRequested ───────────────────────────────────────────────────
// Dispatched when Save Class is tapped in the Add New Class bottom sheet.
class ClassCreateRequested extends AdminClassesEvent {
  final CreateClassRequestModel request;
  const ClassCreateRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// ── ClassUpdateRequested ───────────────────────────────────────────────────
// Dispatched when Save Class is tapped in the Edit Class bottom sheet.
class ClassUpdateRequested extends AdminClassesEvent {
  final int sessionId;
  final UpdateClassRequestModel request;
  const ClassUpdateRequested(this.sessionId, this.request);

  @override
  List<Object?> get props => [sessionId, request];
}

// ── ClassCancelRequested ───────────────────────────────────────────────────
// Dispatched after the admin confirms the cancel confirmation dialog.
// cancelReason is optional.
class ClassCancelRequested extends AdminClassesEvent {
  final int     sessionId;
  final String? cancelReason;
  const ClassCancelRequested(this.sessionId, {this.cancelReason});

  @override
  List<Object?> get props => [sessionId, cancelReason];
}

// ── ClassReactivateRequested ───────────────────────────────────────────────
// Dispatched after the admin confirms the reactivate confirmation dialog.
class ClassReactivateRequested extends AdminClassesEvent {
  final int sessionId;
  const ClassReactivateRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

// ── SessionBookingsRequested ───────────────────────────────────────────────
// Dispatched when the Bookings action button is tapped on a ClassCardWidget.
// Opens the SessionBookingsBottomSheet and loads the bookings list inside it.
class SessionBookingsRequested extends AdminClassesEvent {
  final int sessionId;
  const SessionBookingsRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}