// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/presentation/cubit/role_permissions_state.dart
//
// Immutable state for RolePermissionsCubit. Mirrors admin_settings_state.dart's
// status/isDirty pattern. Carries both screen modes: the "All Staff" matrix
// (permissions/isDirty, unchanged) and the "Specific Account" picker +
// per-account overrides (staffAccounts/selectedAccount/userOverrides/
// isUserOverridesDirty).
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/nav_permission_entity.dart';
import '../../domain/entities/staff_account_entity.dart';
import '../../domain/entities/user_nav_permission_entity.dart';

enum RolePermissionsStatus { loading, loaded, saving, saved, error }

enum RolePermissionsMode { allStaff, specificAccount }

class RolePermissionsState {
  final RolePermissionsStatus status;
  final List<NavPermissionEntity> permissions;
  final bool isDirty;
  final String? errorMessage;

  final RolePermissionsMode mode;
  final List<StaffAccountEntity> staffAccounts;
  final StaffAccountEntity? selectedAccount;
  final List<UserNavPermissionEntity> userOverrides;
  final bool isUserOverridesDirty;

  const RolePermissionsState({
    required this.status,
    required this.permissions,
    required this.isDirty,
    this.errorMessage,
    this.mode = RolePermissionsMode.allStaff,
    this.staffAccounts = const [],
    this.selectedAccount,
    this.userOverrides = const [],
    this.isUserOverridesDirty = false,
  });

  factory RolePermissionsState.initial() => const RolePermissionsState(
    status: RolePermissionsStatus.loading,
    permissions: [],
    isDirty: false,
  );

  RolePermissionsState copyWith({
    RolePermissionsStatus? status,
    List<NavPermissionEntity>? permissions,
    bool? isDirty,
    String? errorMessage,
    RolePermissionsMode? mode,
    List<StaffAccountEntity>? staffAccounts,
    StaffAccountEntity? Function()? selectedAccount,
    List<UserNavPermissionEntity>? userOverrides,
    bool? isUserOverridesDirty,
  }) => RolePermissionsState(
    status: status ?? this.status,
    permissions: permissions ?? this.permissions,
    isDirty: isDirty ?? this.isDirty,
    errorMessage: errorMessage ?? this.errorMessage,
    mode: mode ?? this.mode,
    staffAccounts: staffAccounts ?? this.staffAccounts,
    selectedAccount: selectedAccount != null ? selectedAccount() : this.selectedAccount,
    userOverrides: userOverrides ?? this.userOverrides,
    isUserOverridesDirty: isUserOverridesDirty ?? this.isUserOverridesDirty,
  );
}
