// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/models/admin_staff_list_response_model.dart
//
// Maps the full GET /api/admin/staff response body.
//
// totalStaff and activeStaff come directly from the backend stats queries
// (countTotalByTenantIdAndBranchId / countActiveByTenantIdAndBranchId).
// They are BRANCH-SCOPED — not tenant-wide — and power the two stats cards.
// ─────────────────────────────────────────────────────────────────────────────

import 'admin_staff_card_model.dart';

class AdminStaffListResponseModel {
  final List<AdminStaffCardModel> staff;
  final int totalStaff;   // feeds "Total Staff" stats card
  final int activeStaff;  // feeds "Active" stats card

  const AdminStaffListResponseModel({
    required this.staff,
    required this.totalStaff,
    required this.activeStaff,
  });

  factory AdminStaffListResponseModel.fromJson(Map<String, dynamic> json) {
    // 'staff' is a JSON array — map each element through AdminStaffCardModel.fromJson
    final rawList = json['staff'] as List<dynamic>;

    return AdminStaffListResponseModel(
      staff: rawList
          .map((e) => AdminStaffCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalStaff: (json['totalStaff'] as num).toInt(),
      activeStaff: (json['activeStaff'] as num).toInt(),
    );
  }
}