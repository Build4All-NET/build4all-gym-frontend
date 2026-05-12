// FILE: lib/features/auth/presentation/admin_profile/admin_profile_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../../auth/data/services/admin_token_store.dart';
import '../../../../core/config/env.dart';

// ── AdminProfile entity ────────────────────────────────────────────────────────
// Holds the currently logged-in admin's profile data, decoded from the JWT.
// Provided app-wide via BlocProvider in app_router _withProfile().
class AdminProfile {
  final String  adminName;
  final String  adminEmail;
  final String  gymName;
  final String  branchName;
  final String? avatarUrl;

  /// tenantId (ownerProjectLinkId) stored at login.
  final int? branchId;

  /// DB user ID decoded from JWT 'userId' claim.
  /// Used as trainerId when the logged-in user is a TRAINER.
  final int? userId;

  /// Role decoded from JWT 'roles' claim, e.g. "TRAINER", "ADMIN", "OWNER".
  final String role;

  bool get isTrainerRole => role == 'TRAINER';
  bool get isAdminRole   => role == 'ADMIN' || role == 'OWNER' || role == 'MANAGER';

  const AdminProfile({
    required this.adminName,
    required this.adminEmail,
    required this.gymName,
    required this.branchName,
    this.avatarUrl,
    this.branchId,
    this.userId,
    this.role = '',
  });

  static const empty = AdminProfile(
    adminName:  'Admin',
    adminEmail: '',
    gymName:    'Gym',
    branchName: '',
    branchId:   null,
    userId:     null,
    role:       '',
  );
}

// ── AdminProfileCubit ─────────────────────────────────────────────────────────
// Reads the JWT once at startup, decodes the claims, and emits an AdminProfile.
// Lives as long as the admin section of the app (provided by _withProfile()).
class AdminProfileCubit extends Cubit<AdminProfile> {
  AdminProfileCubit() : super(AdminProfile.empty) {
    _load();
  }

  Future<void> _load() async {
    final tokenStore = const AdminTokenStore();

    // Read raw JWT (stored without "Bearer " prefix by AdminTokenStore.save())
    final token = await tokenStore.getToken();
    if (token == null || token.isEmpty) return;

    // Decode JWT payload — returns null if the token is malformed
    final claims = JwtUtils.decode(token);
    if (claims == null) return;

    final rawTenantId = await tokenStore.getTenantId();
    final branchId    = rawTenantId != null ? int.tryParse(rawTenantId) : null;

    // DB user ID from JWT 'userId' claim (set by JwtService.generateToken).
    final userId = JwtUtils.userIdFromToken(token);

    // Role from JWT 'roles' list, e.g. ["ROLE_TRAINER"] → "TRAINER".
    final rawRoles = claims['roles'];
    String role = '';
    if (rawRoles is List && rawRoles.isNotEmpty) {
      role = rawRoles.first.toString().replaceFirst('ROLE_', '');
    } else if (rawRoles is String && rawRoles.isNotEmpty) {
      role = rawRoles.replaceFirst('ROLE_', '');
    }

    emit(AdminProfile(
      adminName:  claims['name']       as String? ?? 'Admin',
      adminEmail: claims['sub']        as String? ?? '',
      gymName:    Env.appName,
      branchName: claims['branchName'] as String? ?? 'Main Branch',
      avatarUrl:  claims['avatarUrl']  as String?,
      branchId:   branchId,
      userId:     userId,
      role:       role,
    ));
  }
}