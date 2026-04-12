import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:build4allgym/features/shell/presentation/screens/main_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../signup/screens/signup_screen.dart';

class UserLoginScreen extends StatefulWidget {
  final AppConfig appConfig;

  const UserLoginScreen({super.key, required this.appConfig});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _usePhone = false;
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
    final pass = _passwordCtrl.text;

    // ✅ Unified login (no more phone/email distinction)
    context.read<AuthBloc>().add(
      AuthLoginSubmitted(email: value, password: pass),
    );
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

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final btn = tokens.button;
    final card = tokens.card;
    final sp = tokens.spacing;
    final l = AppLocalizations.of(context)!;

    // ✅ Derived colors from existing theme
    final gradientStart = c.primary;
    final gradientEnd = Color.lerp(c.primary, c.success, 0.3) ?? c.primary;
    final inputFillColor = c.surface;
    final inputBorderColor = c.border.withOpacity(0.3);
    final hintColor = c.muted;
    final labelColor = c.label.withOpacity(0.7);
    final dividerColor = c.border.withOpacity(0.2);
    final shadowColor = Colors.black;
    final inverseSurface = c.label; // Use label as dark color
    final onInverseSurface = c.onPrimary;

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStart, gradientEnd],
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
                        padding: EdgeInsets.symmetric(vertical: sp.xl),
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: c.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.fitness_center_rounded,
                                size: 36,
                                color: c.primary,
                              ),
                            ),
                            SizedBox(height: sp.md),
                            // Welcome text
                            Text(
                              l.auth_welcomeBack,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: c.onPrimary,
                              ),
                            ),
                            SizedBox(height: sp.xs),
                            Text(
                              l.auth_loginSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: c.onPrimary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── White card container ──
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(sp.lg),
                            child: Form(
                              key: _formKey,
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (ctx, state) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: sp.xs),

                                    // ── Email / Phone toggle ──
                                    Text(
                                      _usePhone ? l.auth_phoneLabel : l.auth_emailLabel,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Identifier field ──
                                    TextFormField(
                                      controller: _identifierCtrl,
                                      keyboardType: _usePhone
                                          ? TextInputType.phone
                                          : TextInputType.emailAddress,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: c.label,
                                        fontSize: 15,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _usePhone
                                            ? l.auth_phoneHint
                                            : l.auth_emailHint,
                                        hintStyle: TextStyle(
                                          color: hintColor,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: inputFillColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: inputBorderColor,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: inputBorderColor,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: c.primary,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: c.error,
                                            width: 1,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          _usePhone
                                              ? Icons.phone_outlined
                                              : Icons.email_outlined,
                                          color: hintColor,
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
                                    SizedBox(height: sp.md),

                                    // ── Password label ──
                                    Text(
                                      l.auth_passwordLabel,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Password field ──
                                    TextFormField(
                                      controller: _passwordCtrl,
                                      obscureText: _obscurePass,
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: c.label,
                                        fontSize: 15,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: l.auth_passwordHint,
                                        hintStyle: TextStyle(
                                          color: hintColor,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: inputFillColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: inputBorderColor,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: inputBorderColor,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: c.primary,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(btn.radius),
                                          borderSide: BorderSide(
                                            color: c.error,
                                            width: 1,
                                          ),
                                        ),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePass
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: hintColor,
                                            size: 20,
                                          ),
                                          onPressed: () => setState(
                                                () => _obscurePass = !_obscurePass,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: hintColor,
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
                                    SizedBox(height: sp.sm),

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
                                          style: TextStyle(
                                            color: c.primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: sp.lg),

                                    // ── Login button ──
                                    SizedBox(
                                      height: btn.height,
                                      child: ElevatedButton(
                                        onPressed: state.isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: c.primary,
                                          foregroundColor: c.onPrimary,
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(btn.radius),
                                          ),
                                          disabledBackgroundColor: c.muted.withOpacity(0.3),
                                        ),
                                        child: state.isLoading
                                            ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: c.onPrimary,
                                          ),
                                        )
                                            : Text(
                                          l.auth_loginButton,
                                          style: TextStyle(
                                            fontSize: btn.textSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: sp.lg),

                                    // ── Divider "or" ──
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: dividerColor,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: sp.md),
                                          child: Text(
                                            l.general_or,
                                            style: TextStyle(
                                              color: c.muted,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: dividerColor,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: sp.lg),

                                    // ── Google login button ──
                                    SizedBox(
                                      height: btn.height,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Google login
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: c.label,
                                          side: BorderSide(
                                            color: inputBorderColor,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(btn.radius),
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
                                    SizedBox(height: sp.sm),

                                    // ── Apple login button ──
                                    SizedBox(
                                      height: btn.height,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Apple login
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: inverseSurface,
                                          foregroundColor: onInverseSurface,
                                          side: BorderSide(
                                            color: inverseSurface,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(btn.radius),
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
                                    SizedBox(height: sp.lg),

                                    // ── Register link ──
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const SignupScreen(),
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            l.auth_createAccount,
                                            style: TextStyle(
                                              color: c.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: sp.xs),
                                        Text(
                                          l.auth_noAccount,
                                          style: TextStyle(
                                            color: c.body,
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