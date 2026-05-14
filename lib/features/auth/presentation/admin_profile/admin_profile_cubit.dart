import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/env.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../../auth/data/services/admin_token_store.dart';
import '../../../auth/data/services/auth_token_store.dart';

// ── AdminProfile entity ────────────────────────────────────────────────────────

class AdminProfile {
  final String  adminName;
  final String  adminEmail;
  final String  gymName;
  final String  branchName;
  final String? avatarUrl;
  final int?    branchId;
  final int?    userId;

  /// Base role from JWT: 'ADMIN', 'OWNER', 'MANAGER', 'MEMBER', etc.
  final String role;

  /// Gym-specific role from gym_user_roles: 'TRAINER', 'RECEPTION', 'MEMBER'.
  final String gymRole;

  bool get isTrainerRole   => gymRole == 'TRAINER';
  bool get isReceptionRole => gymRole == 'RECEPTION';
  bool get isAdminRole     => role == 'ADMIN' || role == 'OWNER' || role == 'MANAGER';

  const AdminProfile({
    required this.adminName,
    required this.adminEmail,
    required this.gymName,
    required this.branchName,
    this.avatarUrl,
    this.branchId,
    this.userId,
    this.role    = '',
    this.gymRole = 'MEMBER',
  });

  AdminProfile copyWith({String? gymRole}) => AdminProfile(
    adminName:  adminName,
    adminEmail: adminEmail,
    gymName:    gymName,
    branchName: branchName,
    avatarUrl:  avatarUrl,
    branchId:   branchId,
    userId:     userId,
    role:       role,
    gymRole:    gymRole ?? this.gymRole,
  );

  static const empty = AdminProfile(
    adminName:  'Admin',
    adminEmail: '',
    gymName:    'Gym',
    branchName: '',
    branchId:   null,
    userId:     null,
    role:       '',
    gymRole:    'MEMBER',
  );
}

// ── AdminProfileCubit ──────────────────────────────────────────────────────────

class AdminProfileCubit extends Cubit<AdminProfile> {
  AdminProfileCubit() : super(AdminProfile.empty) {
    _load();
  }

  Future<void> _load() async {
    // ── 1. Find the token ──────────────────────────────────────────────────────
    String? token       = await const AdminTokenStore().getToken();
    String? tenantIdStr = await const AdminTokenStore().getTenantId();

    if (token == null || token.isEmpty) {
      token       = await const AuthTokenStore().getToken();
      tenantIdStr = await const AuthTokenStore().getTenantId();
      debugPrint('🔑 AdminProfileCubit: using AuthTokenStore');
    } else {
      debugPrint('🔑 AdminProfileCubit: using AdminTokenStore');
    }

    if (token == null || token.isEmpty) {
      debugPrint('❌ AdminProfileCubit: no token found in either store');
      return;
    }

    // ── 2. Decode JWT ──────────────────────────────────────────────────────────
    final claims = JwtUtils.decode(token);
    if (claims == null) {
      debugPrint('❌ AdminProfileCubit: JWT decode failed');
      return;
    }

    debugPrint('🔍 AdminProfileCubit: JWT claims keys = ${claims.keys.toList()}');

    final branchId = tenantIdStr != null ? int.tryParse(tenantIdStr) : null;
    final userId   = JwtUtils.userIdFromToken(token);

    // ── FIX 1: JWT uses 'role' (singular), not 'roles' (plural) ───────────────
    final rawRole = claims['role'] as String? ?? '';
    final role    = rawRole.replaceFirst('ROLE_', '');

    debugPrint('🔑 AdminProfileCubit: JWT role="$role", userId=$userId, tenantId=$tenantIdStr');

    // ── 3. Emit base profile immediately ──────────────────────────────────────
    emit(AdminProfile(
      adminName:  claims['name']       as String? ?? 'Admin',
      adminEmail: claims['sub']        as String? ?? '',
      gymName:    Env.appName,
      branchName: claims['branchName'] as String? ?? 'Main Branch',
      avatarUrl:  claims['avatarUrl']  as String?,
      branchId:   branchId,
      userId:     userId,
      role:       role,
      gymRole:    'MEMBER',
    ));

    // ── 4. Fetch gym-specific role ─────────────────────────────────────────────
    await _fetchGymRole(token);
  }

  Future<void> _fetchGymRole(String token) async {
    debugPrint('🔄 AdminProfileCubit: fetching gym role from backend...');
    try {
      // ── FIX 2: Use a fresh Dio — never use appDio here.
      // appDio may have interceptors that override the Authorization header
      // with a different token, causing the backend to see the wrong userId.
      final dio = Dio();

      final response = await dio.get(
        '${Env.apiProjectBaseUrl}/api/user/gym-role',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          // ── FIX 3: Don't follow redirects silently; surface real errors
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('📡 gym-role response: ${response.statusCode} → ${response.data}');

      if (response.statusCode == 200 && response.data is Map) {
        final gymRole = (response.data as Map)['gymRole'] as String? ?? 'MEMBER';
        debugPrint('✅ gymRole resolved to: $gymRole');
        emit(state.copyWith(gymRole: gymRole));
      } else {
        // ── FIX 4: Log unexpected status so you can see it — don't fail silently
        debugPrint('⚠️ gym-role unexpected status ${response.statusCode}: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('❌ gym-role DioException: ${e.type} | ${e.response?.statusCode} | ${e.message}');
      debugPrint('   Request URL: ${e.requestOptions.uri}');
      debugPrint('   Request headers: ${e.requestOptions.headers}');
    } catch (e) {
      debugPrint('❌ gym-role unexpected error: $e');
    }
  }
}