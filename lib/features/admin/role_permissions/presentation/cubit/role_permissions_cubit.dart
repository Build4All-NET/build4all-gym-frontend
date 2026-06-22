// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/presentation/cubit/role_permissions_cubit.dart
//
// State management for RolePermissionsScreen. Loads the matrix on
// construction, tracks pending toggle edits in memory, and persists all of
// them atomically on save() — same dirty/save flow as AdminSettingsCubit.
// Also drives the "Specific Account" mode: loads the staff picker list,
// resolves one account's per-item overrides, and saves them independently
// of the "All Staff" matrix.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/staff_account_entity.dart';
import '../../domain/usecases/get_role_permissions_usecase.dart';
import '../../domain/usecases/get_staff_accounts_usecase.dart';
import 'role_permissions_state.dart';

class RolePermissionsCubit extends Cubit<RolePermissionsState> {
  final GetRolePermissionsUseCase _getPermissions;
  final SaveRolePermissionsUseCase _savePermissions;
  final GetStaffAccountsUseCase _getStaffAccounts;
  final GetUserOverridesUseCase _getUserOverrides;
  final SaveUserOverridesUseCase _saveUserOverrides;

  RolePermissionsCubit({
    required GetRolePermissionsUseCase getPermissions,
    required SaveRolePermissionsUseCase savePermissions,
    required GetStaffAccountsUseCase getStaffAccounts,
    required GetUserOverridesUseCase getUserOverrides,
    required SaveUserOverridesUseCase saveUserOverrides,
  })  : _getPermissions = getPermissions,
        _savePermissions = savePermissions,
        _getStaffAccounts = getStaffAccounts,
        _getUserOverrides = getUserOverrides,
        _saveUserOverrides = saveUserOverrides,
        super(RolePermissionsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(status: RolePermissionsStatus.loading));
    try {
      final permissions = await _getPermissions();
      emit(state.copyWith(
        status: RolePermissionsStatus.loaded,
        permissions: permissions,
        isDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RolePermissionsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Toggles the trainer or reception flag for a single item id.
  void toggle({required String itemId, required bool isTrainerColumn, required bool value}) {
    final updated = state.permissions.map((p) {
      if (p.itemId != itemId) return p;
      return isTrainerColumn
          ? p.copyWith(trainerAllowed: value)
          : p.copyWith(receptionAllowed: value);
    }).toList();

    emit(state.copyWith(permissions: updated, isDirty: true));
  }

  /// Persists the full matrix. Returns true on success, false on failure
  /// (the screen shows a snackbar either way).
  Future<bool> save() async {
    if (!state.isDirty) return true;

    emit(state.copyWith(status: RolePermissionsStatus.saving));
    try {
      await _savePermissions(state.permissions);
      emit(state.copyWith(status: RolePermissionsStatus.saved, isDirty: false));
      return true;
    } catch (e) {
      emit(state.copyWith(status: RolePermissionsStatus.error, errorMessage: e.toString()));
      return false;
    }
  }

  // ── "Specific Account" mode ────────────────────────────────────────────

  void setMode(RolePermissionsMode mode) {
    emit(state.copyWith(mode: mode));
    if (mode == RolePermissionsMode.specificAccount) {
      if (state.staffAccounts.isEmpty) {
        loadStaffAccounts();
      } else if (state.selectedAccount != null) {
        // roleDefaultAllowed may be stale if the owner just edited the "All
        // Staff" matrix — refresh so the "(default: on/off)" labels stay
        // accurate.
        selectAccount(state.selectedAccount!);
      }
    }
  }

  Future<void> loadStaffAccounts() async {
    emit(state.copyWith(status: RolePermissionsStatus.loading));
    try {
      final accounts = await _getStaffAccounts();
      emit(state.copyWith(status: RolePermissionsStatus.loaded, staffAccounts: accounts));
    } catch (e) {
      emit(state.copyWith(status: RolePermissionsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> selectAccount(StaffAccountEntity account) async {
    emit(state.copyWith(
      selectedAccount: () => account,
      status: RolePermissionsStatus.loading,
      isUserOverridesDirty: false,
    ));
    try {
      final overrides = await _getUserOverrides(account.userId);
      emit(state.copyWith(
        userOverrides: overrides,
        status: RolePermissionsStatus.loaded,
        isUserOverridesDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(status: RolePermissionsStatus.error, errorMessage: e.toString()));
    }
  }

  /// value: null = Use Default, true = Always Allow, false = Always Deny.
  void setOverride({required String itemId, required bool? value}) {
    final updated = state.userOverrides
        .map((o) => o.itemId == itemId ? o.copyWith(override: () => value) : o)
        .toList();
    emit(state.copyWith(userOverrides: updated, isUserOverridesDirty: true));
  }

  Future<bool> saveUserOverrides() async {
    if (!state.isUserOverridesDirty || state.selectedAccount == null) return true;

    emit(state.copyWith(status: RolePermissionsStatus.saving));
    try {
      await _saveUserOverrides(state.selectedAccount!.userId, state.userOverrides);
      emit(state.copyWith(status: RolePermissionsStatus.saved, isUserOverridesDirty: false));
      return true;
    } catch (e) {
      emit(state.copyWith(status: RolePermissionsStatus.error, errorMessage: e.toString()));
      return false;
    }
  }
}
