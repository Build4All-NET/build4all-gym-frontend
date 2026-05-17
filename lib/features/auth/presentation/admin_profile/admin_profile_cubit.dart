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

  /// All gym-specific roles from gym_user_roles: e.g. ['TRAINER', 'RECEPTION'].
  final List<String> gymRoles;

  /// Primary gym role (first in list, or 'MEMBER' if empty). Kept for backward compat.
  String get gymRole => gymRoles.isNotEmpty ? gymRoles.first : 'MEMBER';

  bool get isTrainerRole   => gymRoles.contains('TRAINER');
  bool get isReceptionRole => gymRoles.contains('RECEPTION');
  bool get isAdminRole     => role == 'ADMIN' || role == 'OWNER' || role == 'MANAGER';
  bool get hasMultipleGymRoles => gymRoles.length > 1;

  const AdminProfile({
    required this.adminName,
    required this.adminEmail,
    required this.gymName,
    required this.branchName,
    this.avatarUrl,
    this.branchId,
    this.userId,
    this.role     = '',
    this.gymRoles = const [],
  });

  AdminProfile copyWith({List<String>? gymRoles}) => AdminProfile(
    adminName:  adminName,
    adminEmail: adminEmail,
    gymName:    gymName,
    branchName: branchName,
    avatarUrl:  avatarUrl,
    branchId:   branchId,
    userId:     userId,
    role:       role,
    gymRoles:   gymRoles ?? this.gymRoles,
  );

  static const empty = AdminProfile(
    adminName:  'Admin',
    adminEmail: '',
    gymName:    'Gym',
    branchName: '',
    branchId:   null,
    userId:     null,
    role:       '',
    gymRoles:   [],
  );
}

// ── AdminProfileCubit ──────────────────────────────────────────────────────────

class AdminProfileCubit extends Cubit<AdminProfile> {
  AdminProfileCubit() : super(AdminProfile.empty) {
    _load();
  }

  Future<void> _load() async {
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

    final claims = JwtUtils.decode(token);
    if (claims == null) {
      debugPrint('❌ AdminProfileCubit: JWT decode failed');
      return;
    }

    debugPrint('🔍 AdminProfileCubit: JWT claims keys = ${claims.keys.toList()}');

    final branchId = tenantIdStr != null ? int.tryParse(tenantIdStr) : null;

    // Prefer the user token's userId for gym-member operations (e.g. trainerId).
    // When the admin token is in use, its userId is the admin account ID, not the
    // gym member ID that trainer/PT endpoints expect.
    int? userId = JwtUtils.userIdFromToken(token);
    final userTok = await const AuthTokenStore().getToken();
    if (userTok != null && userTok.isNotEmpty && userTok != token) {
      userId = JwtUtils.userIdFromToken(userTok) ?? userId;
    }

    // Backend JWT may use a 'roles' list ["ROLE_TRAINER"] or a singular 'role' string.
    String rawRole = '';
    final rolesList = claims['roles'];
    if (rolesList is List && rolesList.isNotEmpty) {
      rawRole = rolesList.first.toString();
    } else {
      rawRole = claims['role'] as String? ?? '';
    }
    final role = rawRole.toUpperCase().replaceFirst('ROLE_', '');

    debugPrint('🔑 AdminProfileCubit: JWT role="$role", userId=$userId, tenantId=$tenantIdStr');

    emit(AdminProfile(
      adminName:  claims['name']       as String? ?? 'Admin',
      adminEmail: claims['sub']        as String? ?? '',
      gymName:    Env.appName,
      branchName: claims['branchName'] as String? ?? 'Main Branch',
      avatarUrl:  claims['avatarUrl']  as String?,
      branchId:   branchId,
      userId:     userId,
      role:       role,
      gymRoles:   [],
    ));

    await _fetchGymRole(token);
  }

  Future<void> _fetchGymRole(String adminToken) async {
    debugPrint('🔄 AdminProfileCubit: fetching gym role from backend...');
    try {
      final dio = Dio();

      // /api/user/gym-role is a user endpoint — prefer the user token so that
      // trainers who also have an admin JWT get their gym role returned correctly.
      final userToken = await const AuthTokenStore().getToken();
      final token = (userToken != null && userToken.isNotEmpty) ? userToken : adminToken;

      final response = await dio.get(
        '${Env.apiProjectBaseUrl}/api/user/gym-role',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('📡 gym-role response: ${response.statusCode} → ${response.data}');

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map;

        // Parse gymRoles list (new format)
        final rolesList = (data['gymRoles'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [];

        // Fallback to single gymRole if gymRoles list is empty
        if (rolesList.isEmpty) {
          final singleRole = data['gymRole'] as String? ?? 'MEMBER';
          if (singleRole != 'MEMBER') {
            rolesList.add(singleRole);
          }
        }

        debugPrint('✅ gymRoles resolved to: $rolesList');
        emit(state.copyWith(gymRoles: rolesList));
      } else {
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
