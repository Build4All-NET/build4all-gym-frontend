import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/app_exception.dart';
import 'package:build4allgym/core/exceptions/auth_exception.dart';
import 'package:build4allgym/core/network/globals.dart' as g;

import '../../../data/services/admin_token_store.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/services/auth_token_store.dart';
import '../../../data/services/session_role_store.dart';
import '../../../domain/facade/dual_login_orchestrator.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DualLoginOrchestrator _orchestrator;
  final AuthApiService _authApi;
  final SessionRoleStore _roleStore;

  AuthBloc()
      : _authApi = AuthApiService(tokenStore: const AuthTokenStore()),
        _orchestrator = DualLoginOrchestrator(
          authApi: AuthApiService(tokenStore: const AuthTokenStore()),
          adminStore: const AdminTokenStore(),
        ),
        _roleStore = SessionRoleStore(),
        super(const AuthState()) {
    on<AuthLoginSubmitted>(_onEmailLogin);
    on<AuthPhoneLoginSubmitted>(_onPhoneLogin);
    on<AuthRoleChosen>(_onRoleChosen);
    on<AuthLoginHydrated>(_onHydrated);
    on<AuthUserPatched>(_onUserPatched);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  // ─── Email login ────────────────────────────────────────────────────────────

  Future<void> _onEmailLogin(
      AuthLoginSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    await _runLogin(
      emit: emit,
      identifier: event.email,
      password: event.password,
      usePhone: false,
    );
  }

  // ─── Phone login ────────────────────────────────────────────────────────────

  Future<void> _onPhoneLogin(
      AuthPhoneLoginSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    await _runLogin(
      emit: emit,
      identifier: event.phone,
      password: event.password,
      usePhone: true,
    );
  }

  // ─── Shared login logic ─────────────────────────────────────────────────────

  Future<void> _runLogin({
    required Emitter<AuthState> emit,
    required String identifier,
    required String password,
    required bool usePhone,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final ownerProjectLinkId = int.tryParse(Env.ownerProjectLinkId) ?? 1;

      final result = await _orchestrator.login(
        identifier: identifier,
        password: password,
        usePhoneForUser: usePhone,
        ownerProjectLinkId: ownerProjectLinkId,
      );

      // Both failed
      if (result.none) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: result.error ?? 'Login failed. Please try again.',
        ));
        return;
      }

      // Deleted user
      if (result.userOk && result.wasDeletedUser) {
        emit(state.copyWith(
          status: AuthStatus.deleted,
          user: result.userEntity,
          token: result.userToken,
          wasDeleted: true,
          canRestoreDeleted: result.canRestoreDeletedUser,
        ));
        return;
      }

      // Inactive user
      if (result.userOk && result.wasInactiveUser) {
        emit(state.copyWith(
          status: AuthStatus.inactive,
          user: result.userEntity,
          token: result.userToken,
          wasInactive: true,
        ));
        return;
      }

      // Both admin and user → ask role
      if (result.both) {
        emit(state.copyWith(
          status: AuthStatus.roleChoice,
          dualResult: result,
        ));
        return;
      }

      // Admin only
      if (result.adminOk) {
        await _roleStore.saveRole('admin');
        g.setAuthToken(result.adminToken!);
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          role: 'admin',
          token: result.adminToken,
        ));
        return;
      }

      // User only
      if (result.userOk) {
        await _roleStore.saveRole('user');
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          role: 'user',
          user: result.userEntity,
          token: result.userToken,
        ));
      }
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      debugPrint('[AuthBloc] Unexpected error: $e');
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Unexpected error. Please try again.',
      ));
    }
  }

  // ─── Role chosen (when both valid) ─────────────────────────────────────────

  Future<void> _onRoleChosen(
      AuthRoleChosen event,
      Emitter<AuthState> emit,
      ) async {
    final result = state.dualResult;
    if (result == null) return;

    await _roleStore.saveRole(event.role);

    if (event.role == 'admin') {
      g.setAuthToken(result.adminToken!);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        role: 'admin',
        token: result.adminToken,
        dualResult: null,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        role: 'user',
        user: result.userEntity,
        token: result.userToken,
        dualResult: null,
      ));
    }
  }

  // ─── Hydrate (from AuthGate token restore) ──────────────────────────────────

  void _onHydrated(AuthLoginHydrated event, Emitter<AuthState> emit) {
    g.setAuthToken(event.token);
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: event.user,
      token: event.token,
      wasInactive: event.wasInactive,
      role: 'user',
    ));
  }

  // ─── Patch user ─────────────────────────────────────────────────────────────

  void _onUserPatched(AuthUserPatched event, Emitter<AuthState> emit) {
    final current = state.user;
    if (current == null) return;

    emit(state.copyWith(
      user: current.copyWith(
        username: event.username,
        firstName: event.firstName,
        lastName: event.lastName,
        profilePictureUrl: event.profilePictureUrl,
        status: event.status,
      ),
    ));
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────

  Future<void> _onLoggedOut(
      AuthLoggedOut event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _authApi.logoutRemote();
    } catch (_) {}

    await _authApi.clearAuth();
    await _roleStore.clear();
    g.setAuthToken('');

    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}