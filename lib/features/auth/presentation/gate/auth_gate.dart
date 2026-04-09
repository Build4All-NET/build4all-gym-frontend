import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/auth_refresh_coordinator.dart';
import 'package:build4allgym/core/network/globals.dart' as g;
import 'package:build4allgym/core/realtime/realtime_cubit.dart';
import 'package:build4allgym/core/utils/jwt_utils.dart';
import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/features/auth/data/services/session_role_store.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/auth/presentation/login/screens/login_screen.dart';
import 'package:build4allgym/features/shell/presentation/screens/main_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatefulWidget {
  final AppConfig appConfig;

  const AuthGate({super.key, required this.appConfig});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // ─── stores ─────────────────────────────────────────────────────────────────
  final _roleStore          = SessionRoleStore();
  final _adminStore         = const AdminTokenStore();
  final _userStore          = const AuthTokenStore();
  final _refreshCoordinator = AuthRefreshCoordinator.instance;

  // ─── state ──────────────────────────────────────────────────────────────────
  bool _loading   = true;
  bool _appBlocked      = false;
  String _blockReason        = '';
  String _serverBlockMessage = '';

  // ────────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _boot();
  }

  // ─── helpers ─────────────────────────────────────────────────────────────────

  String _stripBearer(String? t) {
    final v = (t ?? '').trim();
    if (v.toLowerCase().startsWith('bearer ')) return v.substring(7).trim();
    return v;
  }

  /// Returns the current tenant id as String — prefers runtime AppConfig,
  /// falls back to Env.
  String _tenantIdString() {
    final fromConfig = widget.appConfig.ownerProjectId?.toString().trim() ?? '';
    if (fromConfig.isNotEmpty) return fromConfig;
    return Env.ownerProjectLinkId.trim();
  }

  int _tenantIdInt() => int.tryParse(_tenantIdString()) ?? 0;

  // ─── realtime ────────────────────────────────────────────────────────────────

  void _startRealtimeForAdmin(String rawJwt) {
    if (!mounted) return;
    final tenant = _tenantIdInt();
    if (rawJwt.trim().isEmpty || tenant <= 0) return;

    context.read<RealtimeCubit>().bind(
      tokenMaybeBearerOrRaw: rawJwt,
      tenantId: tenant,
    );
  }

  void _stopRealtime() {
    if (!mounted) return;
    try {
      context.read<RealtimeCubit>().bind(
        tokenMaybeBearerOrRaw: '',
        tenantId: 0,
      );
    } catch (_) {}
  }

  // ─── logout all ──────────────────────────────────────────────────────────────

  Future<void> _logoutAll() async {
    await _userStore.clear();
    await _adminStore.clear();
    await _roleStore.clear();
    g.setAuthToken('');
    _stopRealtime();
  }

  // ─── tenant enforcement ───────────────────────────────────────────────────────
  /// If saved tenant doesn't match current app tenant → logout.
  /// Prevents cross-app token leakage.
  Future<void> _enforceTenantMatchOrLogout() async {
    final current = _tenantIdString();
    if (current.isEmpty) return; // fail-open: unknown tenant

    final savedUser  = (await _userStore.getTenantId())?.trim()  ?? '';
    final savedAdmin = (await _adminStore.getTenantId())?.trim() ?? '';

    final mismatchUser  = savedUser.isNotEmpty  && savedUser  != current;
    final mismatchAdmin = savedAdmin.isNotEmpty && savedAdmin != current;

    if (mismatchUser || mismatchAdmin) {
      debugPrint('[AuthGate] Tenant mismatch → logging out all');
      await _logoutAll();
    }
  }

  // ─── public access check ──────────────────────────────────────────────────────
  /// Ask the backend if this app (linkId) is still active / not expired.
  Future<bool> _checkPublicAppAccess() async {
    final linkId = widget.appConfig.ownerProjectId;
    if (linkId == null) return true; // no linkId configured → allow

    try {
      final res = await g.dio().get('/api/public/app-access/$linkId');

      final data = (res.data is Map)
          ? Map<String, dynamic>.from(res.data as Map)
          : <String, dynamic>{};

      if (data['allowed'] == true) return true;

      // Explicitly blocked
      if (!mounted) return false;
      setState(() {
        _appBlocked         = true;
        _blockReason        = (data['reason']  ?? '').toString();
        _serverBlockMessage = (data['message'] ?? '').toString();
        _loading            = false;
      });
      return false;
    } on DioException catch (e) {
      // 410 Gone = permanently deleted / expired
      if (e.response?.statusCode == 410) {
        final raw  = e.response?.data;
        final data = (raw is Map)
            ? Map<String, dynamic>.from(raw)
            : <String, dynamic>{};

        if (!mounted) return false;
        setState(() {
          _appBlocked         = true;
          _blockReason        = (data['reason']  ?? 'APP_NOT_AVAILABLE').toString();
          _serverBlockMessage = (data['message'] ?? '').toString();
          _loading            = false;
        });
        return false;
      }
      // Network error or other → fail-open (let the app try anyway)
      return true;
    } catch (_) {
      return true;
    }
  }

  // ─── token refresh ────────────────────────────────────────────────────────────

  Future<String?> _tryRefreshUserIfNeeded({
    required String? tokenStored,
    required bool userWasInactive,
  }) async {
    return _refreshCoordinator.refreshUserIfNeeded(
      tokenStored:    tokenStored,
      userWasInactive: userWasInactive,
      tenantId:       _tenantIdString(),
    );
  }

  Future<String?> _tryRefreshAdminIfNeeded({
    required String? tokenStored,
  }) async {
    return _refreshCoordinator.refreshAdminIfNeeded(
      tokenStored: tokenStored,
      tenantId:    _tenantIdString(),
    );
  }

  // ─── boot ─────────────────────────────────────────────────────────────────────
  /// Runs once on init. Decides where to navigate.
  Future<void> _boot() async {
    // Debug dump in development
    await const AdminTokenStore().debugDump();

    try {
      // 1. Is the app allowed?
      final canOpen = await _checkPublicAppAccess();
      if (!canOpen) return;

      // 2. Same tenant as before?
      await _enforceTenantMatchOrLogout();

      // 3. Read saved tokens
      final lastRole       = await _roleStore.getRole();
      final adminStored    = (await _adminStore.getToken())?.trim();
      final userStored     = (await _userStore.getToken())?.trim();
      final userWasInactive = await _userStore.getWasInactive();

      // 4. Try refresh (silently gets new access token using refresh token)
      final adminToken = await _tryRefreshAdminIfNeeded(tokenStored: adminStored);
      final userToken  = await _tryRefreshUserIfNeeded(
        tokenStored:    userStored,
        userWasInactive: userWasInactive,
      );

      // 5. Validate
      final adminValid =
          adminToken != null &&
              adminToken.isNotEmpty &&
              !JwtUtils.isExpired(adminToken);

      final userValid =
          userToken != null &&
              userToken.isNotEmpty &&
              !JwtUtils.isExpired(userToken);

      // user must not be inactive to auto-login
      final userAutoValid = userValid && !userWasInactive;

      // 6. Clean up invalid tokens from storage
      if (!adminValid) await _adminStore.clear();
      if (!userValid)  await _userStore.clear();

      if (!mounted) return;

      // 7. Route decision
      //    Priority: respect lastRole first, then fallback priority

      if (lastRole == 'admin' && adminValid) {
        _goAdminWithToken(adminToken!);
        return;
      }

      if (lastRole == 'user' && userAutoValid) {
        _hydrateUserAndGo(userToken!);
        return;
      }

      // Both valid but no lastRole saved → ask
      if (adminValid && userAutoValid && (lastRole == null || lastRole.isEmpty)) {
        setState(() => _loading = false);
        await _askRoleAndGo(adminToken!, userToken!);
        return;
      }

      // Fallback priority (lastRole existed but that role's token expired)
      if (adminValid) {
        _goAdminWithToken(adminToken!);
        return;
      }

      if (userAutoValid) {
        _hydrateUserAndGo(userToken!);
        return;
      }

      // Inactive user — still go to login but could show a reactivation prompt
      if (userValid && userWasInactive) {
        _goLogin();
        return;
      }

      // Nothing valid → login
      _goLogin();
    } catch (e) {
      debugPrint('[AuthGate] Boot error: $e');
      if (!mounted) return;
      _goLogin();
    }
  }

  // ─── routing ─────────────────────────────────────────────────────────────────

  /// Shows a bottom sheet when both admin and user tokens are valid.
  Future<void> _askRoleAndGo(String adminToken, String userToken) async {
    final l = AppLocalizations.of(context)!;

    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.authGateContinueAs,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: Text(l.authGateRoleAdminOwner),
              onTap: () => Navigator.pop(ctx, 'admin'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l.authGateRoleUser),
              onTap: () => Navigator.pop(ctx, 'user'),
            ),
          ],
        ),
      ),
    );

    if (!mounted) return;

    if (choice == 'admin') {
      await _roleStore.saveRole('admin');
      _goAdminWithToken(adminToken);
      return;
    }
    if (choice == 'user') {
      await _roleStore.saveRole('user');
      _hydrateUserAndGo(userToken);
      return;
    }

    // Dismissed → show login
    _goLogin();
  }

  /// Hydrate the AuthBloc with the saved user token and navigate to MainShell.
  void _hydrateUserAndGo(String rawJwt) {
    if (!mounted) return;

    g.setAuthToken(rawJwt);

    // Tell the BLoC the user is already logged in
    // MainShell will start realtime on its own initState
    context.read<AuthBloc>().add(
      AuthLoginHydrated(
        user:        null, // user entity loaded lazily by MainShell
        token:       rawJwt,
        wasInactive: false,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainShell(appConfig: widget.appConfig),
      ),
    );
  }

  /// Set admin token globally, start realtime, navigate to admin dashboard.
  void _goAdminWithToken(String rawJwt) {
    if (!mounted) return;

    g.setAuthToken(rawJwt);

    // Admin starts realtime here because admin may not go through MainShell
    _startRealtimeForAdmin(rawJwt);

    Navigator.of(context).pushNamedAndRemoveUntil('/admin', (_) => false);
  }

  /// Clear everything and go to login.
  void _goLogin() {
    if (!mounted) return;

    g.setAuthToken('');
    _stopRealtime();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => UserLoginScreen(appConfig: widget.appConfig),
      ),
    );
  }

  // ─── blocked UI ──────────────────────────────────────────────────────────────

  String _titleForReason(AppLocalizations l, String reason) {
    switch (reason) {
      case 'APP_DELETED':   return l.appAccessTitleDeleted;
      case 'APP_EXPIRED':   return l.appAccessTitleExpired;
      default:              return l.appAccessTitleUnavailable;
    }
  }

  String _messageForReason(AppLocalizations l, String reason) {
    switch (reason) {
      case 'APP_DELETED':   return l.appAccessMessageDeleted;
      case 'APP_EXPIRED':   return l.appAccessMessageExpired;
      default:              return l.appAccessMessageUnavailable;
    }
  }

  IconData _iconForReason(String reason) {
    switch (reason) {
      case 'APP_DELETED':   return Icons.block_rounded;
      case 'APP_EXPIRED':   return Icons.timer_off_rounded;
      default:              return Icons.no_accounts_rounded;
    }
  }

  Widget _buildBlockedScreen() {
    final l       = AppLocalizations.of(context)!;
    final title   = _titleForReason(l, _blockReason);
    final message = _messageForReason(l, _blockReason);
    final icon    = _iconForReason(_blockReason);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      child: Icon(icon, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(message, textAlign: TextAlign.center),

                    // Extra server message if provided
                    if (_serverBlockMessage.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _serverBlockMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (!mounted) return;
                          setState(() {
                            _loading            = true;
                            _appBlocked         = false;
                            _blockReason        = '';
                            _serverBlockMessage = '';
                          });
                          await _boot();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l.appAccessRetry),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Blocked by backend
    if (_appBlocked) return _buildBlockedScreen();

    // Still booting
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Boot finished — navigation already called inside _boot()
    // This empty scaffold is shown for a split second at most
    return const Scaffold(body: SizedBox.shrink());
  }
}