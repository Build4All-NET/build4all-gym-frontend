// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/data/repositories/role_permissions_repository_impl.dart
//
// Mirrors admin_settings_repository_impl.dart: wraps the Dio service, maps
// data models to/from domain entities, and rethrows DioException as plain
// Exception so the cubit never sees raw HTTP error types.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import '../../domain/entities/nav_permission_entity.dart';
import '../../domain/entities/staff_account_entity.dart';
import '../../domain/entities/user_nav_permission_entity.dart';
import '../../domain/repositories/role_permissions_repository.dart';
import '../models/nav_permission_model.dart';
import '../models/user_nav_permission_model.dart';
import '../services/role_permissions_remote_service.dart';

class RolePermissionsRepositoryImpl implements RolePermissionsRepository {
  final RolePermissionsRemoteService _service;

  const RolePermissionsRepositoryImpl(this._service);

  @override
  Future<List<NavPermissionEntity>> getPermissions() async {
    try {
      final models = await _service.fetchPermissions();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load staff access permissions: ${e.message}');
    }
  }

  @override
  Future<void> savePermissions(List<NavPermissionEntity> permissions) async {
    try {
      final models = permissions.map(NavPermissionModel.fromEntity).toList();
      await _service.updatePermissions(models);
    } on DioException catch (e) {
      throw Exception('Failed to save staff access permissions: ${e.message}');
    }
  }

  @override
  Future<List<StaffAccountEntity>> getStaffAccounts() async {
    try {
      final models = await _service.fetchStaffAccounts();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load staff accounts: ${e.message}');
    }
  }

  @override
  Future<List<UserNavPermissionEntity>> getUserOverrides(int userId) async {
    try {
      final models = await _service.fetchUserOverrides(userId);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load account permissions: ${e.message}');
    }
  }

  @override
  Future<void> saveUserOverrides(int userId, List<UserNavPermissionEntity> overrides) async {
    try {
      final models = overrides.map(UserNavPermissionModel.fromEntity).toList();
      await _service.updateUserOverrides(userId, models);
    } on DioException catch (e) {
      throw Exception('Failed to save account permissions: ${e.message}');
    }
  }
}
