import 'package:build4allgym/core/network/globals.dart' as globals;
import 'package:dio/dio.dart';

import '../models/admin_staff_list_response_model.dart';
import '../models/create_staff_request_model.dart';
import '../models/update_staff_request_model.dart';

class AdminStaffService {
  final Dio _dio;
  const AdminStaffService(this._dio);

  // ── shared header helper ───────────────────────────────────────────────────
  Options _authOptions() {
    final token = globals.readAuthToken().trim();
    return Options(
      headers: token.isNotEmpty
          ? {'Authorization': token}
          : null,
    );
  }

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
      options: _authOptions(), // ← explicitly attach token
    );

    return AdminStaffListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<int> createStaff(CreateStaffRequestModel request) async {
    final response = await _dio.post(
      '/api/admin/staff',
      data: request.toJson(),
      options: _authOptions(), // ← explicitly attach token
    );
    return (response.data as num).toInt();
  }

  Future<void> updateStaff(int staffId, UpdateStaffRequestModel request) async {
    await _dio.put(
      '/api/admin/staff/$staffId',
      data: request.toJson(),
      options: _authOptions(), // ← explicitly attach token
    );
  }

  Future<void> removeStaff(int staffId) async {
    await _dio.delete(
      '/api/admin/staff/$staffId',
      options: _authOptions(), // ← explicitly attach token
    );
  }
}