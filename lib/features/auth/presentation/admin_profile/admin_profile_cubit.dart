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

  // branchId is read from AdminTokenStore.getTenantId() which the
  //            auth flow writes at login time. Every screen that previously
  //            used branchId: 1 (a stub) can now read:
  //              context.read<AdminProfileCubit>().state.branchId ?? 1
  final int? branchId;

  const AdminProfile({
    required this.adminName,
    required this.adminEmail,
    required this.gymName,
    required this.branchName,
    this.avatarUrl,
    this.branchId, // nullable — null if the tenant ID is not stored yet
  });

  // Fallback used before _load() completes
  static const empty = AdminProfile(
    adminName:  'Admin',
    adminEmail: '',
    gymName:    'Gym',
    branchName: '',
    branchId:   null,
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

    // Read tenantId that the auth flow stored at login.
    //    AdminTokenStore writes this key when the login response contains
    //    a tenantId / branchId field. We parse it to int; null if absent.
    final rawTenantId = await tokenStore.getTenantId();
    final branchId    = rawTenantId != null ? int.tryParse(rawTenantId) : null;

    emit(AdminProfile(
      // Full name of the logged-in admin (from "name" claim in JWT)
      adminName:  claims['name']       as String? ?? 'Admin',

      // Email / username (from "sub" claim — standard JWT subject)
      adminEmail: claims['sub']        as String? ?? '',

      // Gym display name comes from compile-time --dart-define=APP_NAME
      // (not from the JWT, since one token can serve multiple gym apps)
      gymName:    Env.appName,

      // Branch the admin belongs to (set at login by backend, stored in JWT)
      branchName: claims['branchName'] as String? ?? 'Main Branch',

      // Optional avatar URL (may not exist in all JWT implementations)
      avatarUrl:  claims['avatarUrl']  as String?,

      //  Numeric branch / tenant ID — used to pass to API calls that need it
      branchId:   branchId,
    ));
  }
}