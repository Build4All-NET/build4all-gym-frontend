import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:build4allgym/features/shell/presentation/screens/main_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../../domain/facade/dual_login_orchestrator.dart';

class UserLoginScreen extends StatefulWidget {
  final AppConfig appConfig;

  const UserLoginScreen({super.key, required this.appConfig});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl   = TextEditingController();

  bool _usePhone    = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ─── submit ─────────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final value = _identifierCtrl.text.trim();
    final pass  = _passwordCtrl.text;

    if (_usePhone) {
      context.read<AuthBloc>().add(
        AuthPhoneLoginSubmitted(phone: value, password: pass),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthLoginSubmitted(email: value, password: pass),
      );
    }
  }

  // ─── navigation helpers ─────────────────────────────────────────────────────

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainShell(appConfig: widget.appConfig),
      ),
          (_) => false,
    );
  }

  void _goAdmin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/admin', (_) => false);
  }

  // ─── role choice bottom sheet ────────────────────────────────────────────────

  Future<void> _showRoleSheet(DualLoginResult result) async {
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
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
    if (choice != null) {
      context.read<AuthBloc>().add(AuthRoleChosen(choice));
    }
  }

  // ─── reactivation dialog ─────────────────────────────────────────────────────

  Future<void> _showInactiveDialog() async {
    final l = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.auth_accountInactiveTitle),
        content: Text(l.auth_accountInactiveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.general_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.auth_reactivate),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: call reactivation API then hydrate
    }
  }

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l      = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) async {
        switch (state.status) {

          case AuthStatus.authenticated:
            if (state.role == 'admin') {
              _goAdmin();
            } else {
              _goHome();
            }
            break;

          case AuthStatus.roleChoice:
            if (state.dualResult != null) {
              await _showRoleSheet(state.dualResult!);
            }
            break;

          case AuthStatus.inactive:
            await _showInactiveDialog();
            break;

          case AuthStatus.deleted:
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  state.canRestoreDeleted
                      ? l.auth_accountDeletedRestorableMessage
                      : l.auth_accountDeletedPermanentMessage,
                ),
                backgroundColor: c.error,
                duration: const Duration(seconds: 5),
              ),
            );
            break;

          case AuthStatus.failure:
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(_resolveError(state.errorCode, state.errorMessage, l)),
                backgroundColor: c.error,
              ),
            );
            break;

          default:
            break;
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1FCC79), // Green
                Color(0xFF2DBAB8), // Teal/Blue
              ],
            ),
          ),
          child: Column(
            children: [
              // Connection banner at top
              const ConnectionBanner(),

              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // ── Top section with logo and title ──
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center_rounded,
                                size: 36,
                                color: Color(0xFF1FCC79),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Welcome text
                            Text(
                              l.auth_welcomeBack,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.auth_loginSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── White card container ──
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (ctx, state) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 8),

                                    // ── Email / Phone toggle ──
                                    Text(
                                      _usePhone ? l.auth_phoneLabel : l.auth_emailLabel,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(height: 8),

                                    // ── Identifier field ──
                                    TextFormField(
                                      controller: _identifierCtrl,
                                      keyboardType: _usePhone
                                          ? TextInputType.phone
                                          : TextInputType.emailAddress,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _usePhone
                                            ? l.auth_phoneHint
                                            : l.auth_emailHint,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF1FCC79),
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          _usePhone
                                              ? Icons.phone_outlined
                                              : Icons.email_outlined,
                                          color: Colors.grey[400],
                                          size: 20,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return _usePhone
                                              ? l.validation_phoneRequired
                                              : l.validation_emailRequired;
                                        }
                                        if (!_usePhone && !v.contains('@')) {
                                          return l.validation_emailInvalid;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // ── Password label ──
                                    Text(
                                      l.auth_passwordLabel,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(height: 8),

                                    // ── Password field ──
                                    TextFormField(
                                      controller: _passwordCtrl,
                                      obscureText: _obscurePass,
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: l.auth_passwordHint,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF1FCC79),
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePass
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                          onPressed: () => setState(
                                                () => _obscurePass = !_obscurePass,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.grey[400],
                                          size: 20,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return l.validation_passwordRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    // ── Forgot password ──
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // TODO: navigate to forgot password
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          l.auth_forgotPassword,
                                          style: const TextStyle(
                                            color: Color(0xFF1FCC79),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Login button ──
                                    SizedBox(
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: state.isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1FCC79),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          disabledBackgroundColor: Colors.grey[300],
                                        ),
                                        child: state.isLoading
                                            ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                            : Text(
                                          l.auth_loginButton,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Divider "or" ──
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            l.general_or,
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Google login button ──
                                    SizedBox(
                                      height: 52,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Google login
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.grey[800],
                                          side: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: Image.network(
                                          'https://www.google.com/favicon.ico',
                                          width: 20,
                                          height: 20,
                                        ),
                                        label: Text(
                                          l.auth_continueWithGoogle,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // ── Apple login button ──
                                    SizedBox(
                                      height: 52,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Apple login
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.apple,
                                          size: 22,
                                        ),
                                        label: Text(
                                          l.auth_continueWithApple,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Register link ──
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            // TODO: navigate to register
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            l.auth_createAccount,
                                            style: const TextStyle(
                                              color: Color(0xFF1FCC79),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          l.auth_noAccount,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Error resolver ──────────────────────────────────────────────────────────

  String _resolveError(String? code, String? msg, AppLocalizations l) {
    switch (code) {
      case 'WRONG_PASSWORD':
      case 'INVALID_CREDENTIALS':
        return l.validation_invalidCredentials;
      case 'USER_NOT_FOUND':
        return l.auth_userNotFound;
      case 'LOGIN_LOCKED':
        return l.auth_loginLocked;
      case 'INACTIVE':
        return l.auth_accountInactive;
      case 'NETWORK_ERROR':
        return l.connection_offline;
      default:
        return msg ?? l.error_somethingWentWrong;
    }
  }
}