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
  final AuthTokenStore _tokenStore;

  AuthBloc()
      : _tokenStore = const AuthTokenStore(),
        _authApi = AuthApiService(tokenStore: const AuthTokenStore()),
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

  // ────────────────────────────────────────────────────────────────────────────
  // EMAIL LOGIN
  // ────────────────────────────────────────────────────────────────────────────

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

  // ────────────────────────────────────────────────────────────────────────────
  // PHONE LOGIN
  // ────────────────────────────────────────────────────────────────────────────

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

  // ────────────────────────────────────────────────────────────────────────────
  // SHARED LOGIN LOGIC
  // ────────────────────────────────────────────────────────────────────────────

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

      // Helpful debug while testing dual-role login.
      debugPrint('🧭 LOGIN RESULT FLAGS:');
      debugPrint('none=${result.none}');
      debugPrint('userOk=${result.userOk}');
      debugPrint('adminOk=${result.adminOk}');
      debugPrint('both=${result.both}');
      debugPrint('wasDeletedUser=${result.wasDeletedUser}');
      debugPrint('wasInactiveUser=${result.wasInactiveUser}');
      debugPrint('userToken null=${result.userToken == null}');
      debugPrint('adminToken null=${result.adminToken == null}');
      debugPrint('userEntity id=${result.userEntity?.id}');
      debugPrint('userEntity email=${result.userEntity?.email}');

      // Both admin and user failed.
      if (result.none) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: result.error ?? 'Login failed. Please try again.',
          ),
        );
        return;
      }

      // Deleted user.
      if (result.userOk && result.wasDeletedUser) {
        emit(
          state.copyWith(
            status: AuthStatus.deleted,
            user: result.userEntity,
            token: result.userToken,
            wasDeleted: true,
            canRestoreDeleted: result.canRestoreDeletedUser,
          ),
        );
        return;
      }

      // Inactive user.
      if (result.userOk && result.wasInactiveUser) {
        emit(
          state.copyWith(
            status: AuthStatus.inactive,
            user: result.userEntity,
            token: result.userToken,
            wasInactive: true,
          ),
        );
        return;
      }

      // Same credentials are valid as both Admin/Owner and Regular User.
      //
      // You requested:
      // - ask again every login
      // - do NOT auto-select the previous role
      //
      // So we always emit roleChoice here.
      if (result.both) {
        emit(
          state.copyWith(
            status: AuthStatus.roleChoice,
            dualResult: result,
          ),
        );
        return;
      }

      // Admin only.
      //
      // Admin token is handled by admin flow/admin store.
      if (result.adminOk) {
        await _roleStore.saveRole('admin');

        g.setAuthToken(result.adminToken!);

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            role: 'admin',
            token: result.adminToken,
          ),
        );
        return;
      }

      // User only.
      //
      // Must save auth_user_id because Build4All profile feature calls:
      // GET /api/users/{userId}
      if (result.userOk) {
        // Reset any stale admin role so drawer doesn't treat this user as owner.
        await const AdminTokenStore().save(token: '', role: 'user');

        await _saveUserSession(
          token: result.userToken!,
          user: result.userEntity!,
        );

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            role: 'user',
            user: result.userEntity,
            token: result.userToken,
          ),
        );
        return;
      }
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.message,
          errorCode: e.code,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.message,
          errorCode: e.code,
        ),
      );
    } catch (e) {
      debugPrint('[AuthBloc] Unexpected error: $e');

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Unexpected error. Please try again.',
        ),
      );
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // SAVE USER SESSION
  // ────────────────────────────────────────────────────────────────────────────

  /// Saves a regular USER session after successful login or role choice.
  ///
  /// Required by member account/profile features because they need:
  /// - auth_token
  /// - auth_user_id
  /// - auth_user_json
  ///
  /// Without auth_user_id, Build4All profile loading fails because it calls:
  /// GET /api/users/{userId}
  Future<void> _saveUserSession({
    required String token,
    required dynamic user,
  }) async {
    await _roleStore.saveRole('user');

    // Current runtime token for Dio/interceptors.
    g.setAuthToken(token);

    // Secure persistent token.
    await _tokenStore.saveToken(
      token: token,
      tenantId: Env.ownerProjectLinkId,
    );

    // Save user ID for Build4All profile API.
    if (user.id != null && user.id > 0) {
      await _tokenStore.saveUserId(user.id);
    } else {
      throw Exception('Missing user id after login.');
    }

    // Save full user JSON for hydration/fallback.
    await _tokenStore.saveUserJson({
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'profilePictureUrl': user.profilePictureUrl,
    });

    // Keep old cached fields for compatibility.
    await _tokenStore.saveUserProfileInfo(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
    );

    debugPrint(
      '✅ USER SESSION SAVED TOKEN = ${(await _tokenStore.getToken()) != null}',
    );
    debugPrint(
      '✅ USER SESSION SAVED USER ID = ${await _tokenStore.getUserId()}',
    );
    debugPrint(
      '✅ USER SESSION SAVED USER JSON = ${await _tokenStore.getUserJson()}',
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ROLE CHOSEN
  // ────────────────────────────────────────────────────────────────────────────

  /// Runs when both Admin/Owner and Regular User are valid and the user chooses.
  ///
  /// Important:
  /// If Regular User is chosen, save full user session.
  /// Do not just emit authenticated, because Build4All profile needs auth_user_id.
  Future<void> _onRoleChosen(
      AuthRoleChosen event,
      Emitter<AuthState> emit,
      ) async {
    final result = state.dualResult;
    if (result == null) return;

    if (event.role == 'admin') {
      await _roleStore.saveRole('admin');

      g.setAuthToken(result.adminToken!);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          role: 'admin',
          token: result.adminToken,
          dualResult: null,
        ),
      );
      return;
    }

    await _saveUserSession(
      token: result.userToken!,
      user: result.userEntity!,
    );

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        role: 'user',
        user: result.userEntity,
        token: result.userToken,
        dualResult: null,
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // HYDRATE
  // ────────────────────────────────────────────────────────────────────────────

  void _onHydrated(
      AuthLoginHydrated event,
      Emitter<AuthState> emit,
      ) {
    debugPrint('DEBUG hydrated with role: ${event.role}');
    debugPrint('DEBUG hydrated token empty: ${event.token.isEmpty}');

    g.setAuthToken(event.token);

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: event.user,
        token: event.token,
        wasInactive: event.wasInactive,
        role: event.role,
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // PATCH USER IN STATE
  // ────────────────────────────────────────────────────────────────────────────

  void _onUserPatched(
      AuthUserPatched event,
      Emitter<AuthState> emit,
      ) {
    final current = state.user;
    if (current == null) return;

    emit(
      state.copyWith(
        user: current.copyWith(
          username: event.username,
          firstName: event.firstName,
          lastName: event.lastName,
          profilePictureUrl: event.profilePictureUrl,
          status: event.status,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // LOGOUT
  // ────────────────────────────────────────────────────────────────────────────

  Future<void> _onLoggedOut(
      AuthLoggedOut event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _authApi.logoutRemote();
    } catch (_) {
      // Remote logout can fail if token expired/server unavailable.
      // Local logout must still happen.
    }

    // Clears tokens and cached auth/user data.
    await _authApi.clearAuth();

    // You requested role popup every login.
    // Therefore we clear the remembered role on logout.
    await _roleStore.clear();

    g.setAuthToken('');

    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}