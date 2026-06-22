// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/data/services/role_permissions_remote_service.dart
//
// Raw HTTP layer. Mirrors admin_settings_remote_service.dart.
//
// ENDPOINTS (from the backend GymNavPermissionController):
//   GET  /api/admin/role-permissions  → returns List<NavPermissionDto> JSON
//   PUT  /api/admin/role-permissions  → body: List<NavPermissionDto> JSON
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../models/nav_permission_model.dart';
import '../models/staff_account_model.dart';
import '../models/user_nav_permission_model.dart';

class RolePermissionsRemoteService {
  static const _basePath = '/api/admin/role-permissions';

  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: Env.apiProjectBaseUrl));

  Future<List<NavPermissionModel>> fetchPermissions() async {
    final response = await _dio.get('${Env.apiProjectBaseUrl}$_basePath');
    return (response.data as List<dynamic>)
        .map((e) => NavPermissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updatePermissions(List<NavPermissionModel> models) async {
    await _dio.put(
      '${Env.apiProjectBaseUrl}$_basePath',
      data: models.map((m) => m.toJson()).toList(),
    );
  }

  Future<List<StaffAccountModel>> fetchStaffAccounts() async {
    final response = await _dio.get('${Env.apiProjectBaseUrl}$_basePath/users');
    return (response.data as List<dynamic>)
        .map((e) => StaffAccountModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserNavPermissionModel>> fetchUserOverrides(int userId) async {
    final response = await _dio.get('${Env.apiProjectBaseUrl}$_basePath/users/$userId');
    return (response.data as List<dynamic>)
        .map((e) => UserNavPermissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateUserOverrides(int userId, List<UserNavPermissionModel> models) async {
    await _dio.put(
      '${Env.apiProjectBaseUrl}$_basePath/users/$userId',
      data: models.map((m) => m.toJson()).toList(),
    );
  }
}
