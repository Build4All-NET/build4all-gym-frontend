// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/data/services/admin_staff_service.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';

import '../models/admin_staff_card_model.dart';
import '../models/admin_staff_list_response_model.dart';
import '../models/create_staff_request_model.dart';
import '../models/update_staff_request_model.dart';

class AdminStaffService {
  final Dio _dio; // Uses the project's Dio singleton from globals.dart

  const AdminStaffService(this._dio);

  // ── GET /api/admin/staff ───────────────────────────────────────────────────

  Future<AdminStaffListResponseModel> getStaff({
    int? branchId,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (branchId != null) queryParams['branchId'] = branchId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _dio.get(
      '/api/admin/staff',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    return AdminStaffListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // ── POST /api/admin/staff ──────────────────────────────────────────────────

  Future<int> createStaff(CreateStaffRequestModel request) async {
    final response = await _dio.post(
      '/api/admin/staff',
      data: request.toJson(),
    );

    return (response.data as num).toInt();
  }

  // ── PUT /api/admin/staff/{staffId} ────────────────────────────────────────

  Future<void> updateStaff(int staffId, UpdateStaffRequestModel request) async {
    await _dio.put(
      '/api/admin/staff/$staffId',
      data: request.toJson(),
    );
  }

  // ── DELETE /api/admin/staff/{staffId} ─────────────────────────────────────

  Future<void> removeStaff(int staffId) async {
    await _dio.delete('/api/admin/staff/$staffId');
  }
}