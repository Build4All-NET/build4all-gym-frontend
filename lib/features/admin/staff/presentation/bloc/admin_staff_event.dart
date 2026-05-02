// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/bloc/admin_staff_event.dart
//
// All events are immutable. Using 'abstract class + extends' (not sealed)
// so it compiles on older Dart versions — adjust to sealed if your project uses Dart 3.
// ─────────────────────────────────────────────────────────────────────────────
import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';

// Adjust the import paths above to match your project structure.
// They should point to:
//   lib/features/admin/staff/data/models/create_staff_request_model.dart
//   lib/features/admin/staff/data/models/update_staff_request_model.dart

abstract class AdminStaffEvent {
  const AdminStaffEvent();
}

/// Dispatched on screen init (initState) to trigger the initial data load.
class StaffStarted extends AdminStaffEvent {
  const StaffStarted();
}

/// Dispatched by StaffSearchBarWidget on every keystroke (debounced 300 ms in BLoC).
class StaffSearchChanged extends AdminStaffEvent {
  final String query;
  const StaffSearchChanged(this.query);
}

/// Dispatched when the user taps "Add Staff Member" and confirms in the bottom sheet.
class StaffCreateRequested extends AdminStaffEvent {
  final CreateStaffRequestModel request;
  const StaffCreateRequested(this.request);
}

/// Dispatched when the user taps "Save Changes" in edit mode of the bottom sheet.
class StaffUpdateRequested extends AdminStaffEvent {
  final int staffId;
  final UpdateStaffRequestModel request;
  const StaffUpdateRequested(this.staffId, this.request);
}

/// Dispatched after the user confirms the remove dialog on a staff card.
class StaffRemoveRequested extends AdminStaffEvent {
  final int staffId;
  const StaffRemoveRequested(this.staffId);
}