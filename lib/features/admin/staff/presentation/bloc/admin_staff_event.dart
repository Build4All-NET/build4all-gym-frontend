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

class StaffStarted extends AdminStaffEvent {
  final int? branchId; // null = All Branches
  const StaffStarted({this.branchId});
}

class StaffSearchChanged extends AdminStaffEvent {
  final String query;
  const StaffSearchChanged(this.query);
}

class StaffCreateRequested extends AdminStaffEvent {
  final CreateStaffRequestModel request;
  const StaffCreateRequested(this.request);
}

class StaffUpdateRequested extends AdminStaffEvent {
  final int staffId;
  final UpdateStaffRequestModel request;
  const StaffUpdateRequested(this.staffId, this.request);
}

class StaffRemoveRequested extends AdminStaffEvent {
  final int staffId;
  const StaffRemoveRequested(this.staffId);
}