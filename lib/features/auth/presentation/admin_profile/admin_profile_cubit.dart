// lib/features/auth/presentation/admin_profile/admin_profile_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../../auth/data/services/admin_token_store.dart';
import '../../../../core/config/env.dart';
class AdminProfile {
  final String adminName;
  final String adminEmail;
  final String gymName;
  final String branchName;
  final String? avatarUrl;

  const AdminProfile({
    required this.adminName,
    required this.adminEmail,
    required this.gymName,
    required this.branchName,
    this.avatarUrl,
  });

  static const empty = AdminProfile(
    adminName:  'Admin',
    adminEmail: '',
    gymName:    'Gym',
    branchName: '',
  );
}

class AdminProfileCubit extends Cubit<AdminProfile> {
  AdminProfileCubit() : super(AdminProfile.empty) {
    _load();
  }

  Future<void> _load() async {
    final token = await const AdminTokenStore().getToken();
    if (token == null || token.isEmpty) return;
    final claims = JwtUtils.decode(token);
    if (claims == null) return;

    emit(AdminProfile(
      adminName:  claims['name']       as String? ?? 'Admin',
      adminEmail: claims['sub']      as String? ?? '',
      gymName:    Env.appName   as String? ?? 'Gym',
      branchName: claims['branchName'] as String? ?? 'Main Branch',
      avatarUrl:  claims['avatarUrl']  as String?,
    ));
  }
}