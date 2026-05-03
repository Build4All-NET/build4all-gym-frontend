// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/repositories/admin_staff_repository_impl.dart
//
// Implements the abstract AdminStaffRepository (domain layer).
//
// RESPONSIBILITY OF THIS CLASS:
//   1. Call the service (HTTP layer)
//   2. Convert data models → domain entities
//   3. Catch any exceptions and re-throw as domain-friendly errors
//      so the BLoC doesn't depend on Dio or HTTP concepts.
//
// WHY CONVERT MODEL → ENTITY HERE?
//   The domain layer must not know about JSON or HTTP. The entity is a pure
//   Dart object. All conversion happens in this impl, keeping domain clean.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/admin_staff_card_entity.dart';
import '../../domain/entities/admin_staff_list_result_entity.dart';
import '../../domain/repositories/admin_staff_repository.dart';
import '../models/admin_staff_card_model.dart';
import '../models/create_staff_request_model.dart';
import '../models/update_staff_request_model.dart';
import '../services/admin_staff_service.dart';

class AdminStaffRepositoryImpl implements AdminStaffRepository {
  final AdminStaffService _service;

  const AdminStaffRepositoryImpl(this._service);

  // ── getStaff ───────────────────────────────────────────────────────────────

  @override
  Future<AdminStaffListResultEntity> getStaff({
    int? branchId,
    String? search,
  }) async {
    try {
      final model = await _service.getStaff(branchId: branchId, search: search);

      // Convert each AdminStaffCardModel → AdminStaffCardEntity
      final entities = model.staff.map(_toEntity).toList();

      return AdminStaffListResultEntity(
        staff: entities,
        totalStaff: model.totalStaff,
        activeStaff: model.activeStaff,
      );
    } catch (e) {
      // Re-throw with context so the BLoC can show a meaningful message
      throw Exception('Failed to load staff list: $e');
    }
  }

  // ── createStaff ────────────────────────────────────────────────────────────

  @override
  Future<int> createStaff(CreateStaffRequestModel request) async {
    try {
      return await _service.createStaff(request);
    } catch (e) {
      throw Exception('Failed to create staff member: $e');
    }
  }

  // ── updateStaff ────────────────────────────────────────────────────────────

  @override
  Future<void> updateStaff(int staffId, UpdateStaffRequestModel request) async {
    try {
      await _service.updateStaff(staffId, request);
    } catch (e) {
      throw Exception('Failed to update staff member: $e');
    }
  }

  // ── removeStaff ────────────────────────────────────────────────────────────

  @override
  Future<void> removeStaff(int staffId) async {
    try {
      await _service.removeStaff(staffId);
    } catch (e) {
      throw Exception('Failed to remove staff member: $e');
    }
  }

  // ── private helper ─────────────────────────────────────────────────────────

  /// Converts one data model to a domain entity.
  /// This is the only place the mapping lives — single responsibility.
  AdminStaffCardEntity _toEntity(AdminStaffCardModel model) {
    return AdminStaffCardEntity(
      staffId: model.staffId,
      fullName: model.fullName,
      profileFileId: model.profileFileId,
      email: model.email,
      phone: model.phone,
      roleName: model.roleName,
      branchName: model.branchName,
      status: model.status,
    );
  }
}