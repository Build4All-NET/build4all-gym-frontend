// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/domain/entities/admin_staff_list_result_entity.dart
//
// Wraps the staff list together with the two branch-scoped stats counts.
// The BLoC receives this from GetStaffUseCase and stores totalStaff +
// activeStaff directly in StaffLoaded so they reach the stats row widgets.
// ─────────────────────────────────────────────────────────────────────────────

import 'admin_staff_card_entity.dart';

class AdminStaffListResultEntity {
  final List<AdminStaffCardEntity> staff;
  final int totalStaff;   // for "Total Staff" stats card
  final int activeStaff;  // for "Active" stats card

  const AdminStaffListResultEntity({
    required this.staff,
    required this.totalStaff,
    required this.activeStaff,
  });
}