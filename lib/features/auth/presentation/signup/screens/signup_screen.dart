import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/theme/app_theme_tokens.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_bloc.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_event.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_state.dart';
import 'package:build4allgym/features/auth/domain/usecases/send_verification_code.dart';
import 'package:build4allgym/features/auth/data/repository/auth_repository_impl.dart';
import 'package:build4allgym/features/auth/data/services/auth_api_service.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../../domain/usecases/complete_user_profile.dart';
import 'otp_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — wires BLoC, same pattern as login_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final tokenStore           = const AuthTokenStore();
        final apiService           = AuthApiService(
          client:     http.Client(),
          tokenStore: tokenStore,
        );
        final repository           = AuthRepositoryImpl(apiService);
        return RegisterBloc(
          sendVerificationCode: SendVerificationCode(repository),
          completeUserProfile:  CompleteUserProfile(repository),  // ← add this
        );
      },
      child: const _SignupContent(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main content widget
// ─────────────────────────────────────────────────────────────────────────────
class _SignupContent extends StatefulWidget {
  const _SignupContent();

  @override
  State<_SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<_SignupContent> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  bool _usePhone       = false;
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ─── submit ──────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    context.read<RegisterBloc>().add(
      RegisterSendCodeSubmitted(
        method:      _usePhone ? RegisterMethod.phone : RegisterMethod.email,
        email:       _usePhone ? null : _emailCtrl.text.trim(),
        phoneNumber: _usePhone ? _phoneCtrl.text.trim() : null,
        password:    _passwordCtrl.text,
      ),
    );
  }

  // ─── validators ──────────────────────────────────────────────────────────

  String? _validateIdentifier(String? value, AppLocalizations l) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return _usePhone ? l.validation_phoneRequired : l.validation_emailRequired;
    }
    if (!_usePhone && !v.contains('@')) return l.validation_emailInvalid;
    if (_usePhone && v.length < 7)      return l.validation_phoneRequired;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l) {
    final v = value ?? '';
    if (v.isEmpty)    return l.validation_passwordRequired;
    if (v.length < 6) return l.validation_passwordTooShort;
    return null;
  }

  String? _validateConfirm(String? value, AppLocalizations l) {
    if ((value ?? '').isEmpty)       return l.validation_confirmPasswordRequired;
    if (value != _passwordCtrl.text) return l.validation_passwordsMismatch;
    return null;
  }

  // ─── error resolver ──────────────────────────────────────────────────────

  String _resolveError(String? code, AppLocalizations l) {
    switch (code) {
      case 'EMAIL_ALREADY_EXISTS': return l.validation_emailAlreadyExists;
      case 'PHONE_ALREADY_EXISTS': return l.validation_phoneAlreadyExists;
      case 'WEAK_PASSWORD':        return l.validation_passwordTooShort;
      case 'NO_INTERNET':
      case 'NETWORK_ERROR':        return l.connection_offline;
      case 'TIMEOUT':              return l.connection_timeout;
      case 'SERVER_ERROR':         return l.error_serverError;
      default:                     return l.error_somethingWentWrong;
    }
  }

  // ─── build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Pull ONLY from AppThemeTokens — zero hardcoded Colors.*
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final btn    = tokens.button;
    final card   = tokens.card;
    final sp     = tokens.spacing;
    final l      = AppLocalizations.of(context)!;

    // Derived — same technique used in login_screen.dart
    final gradientEnd = Color.lerp(c.primary, c.success, 0.3) ?? c.primary;
    final labelColor  = c.label.withOpacity(0.7);

    return MultiBlocListener(
      listeners: [
        // Fires ONLY when codeSent flips false → true
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (prev, curr) =>
          !prev.codeSent && curr.codeSent,
          listener: (ctx, state) {
            if (state.contact == null) return;
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: ctx.read<RegisterBloc>(),
                  child: OtpScreen(
                    contact:  state.contact!,
                    email:    _usePhone ? '' : _emailCtrl.text.trim(),
                    phone:    _usePhone ? _phoneCtrl.text.trim() : null,
                    password: _passwordCtrl.text,
                  ),
                ),
              ),
            );
          },
        ),

        // Fires ONLY when a new error appears
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (prev, curr) =>
          prev.errorCode != curr.errorCode && curr.errorCode != null,
          listener: (ctx, state) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(_resolveError(state.errorCode, l)),
                backgroundColor: c.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(card.radius),
                ),
              ),
            );
          },
        ),

        // Fires ONLY when resumeCompleteProfile flips false → true
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (prev, curr) =>
          !prev.resumeCompleteProfile && curr.resumeCompleteProfile,
          listener: (ctx, state) {
            if (state.resumePendingId == null) return;
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(l.signup_alreadyVerifiedResume),
                backgroundColor: c.success,
              ),
            );
            // TODO: Navigate to CompleteProfileScreen(pendingId: state.resumePendingId!)
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
              colors: [c.primary, gradientEnd],
            ),
          ),
          child: Column(
            children: [
              const ConnectionBanner(),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // ── Gradient header ───────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sp.xl),
                        child: Column(
                          children: [
                            // Logo — c.surface background, c.primary icon
                            Container(
                              width:  72,
                              height: 72,
                              decoration: BoxDecoration(
                                color:        c.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    // Use c.label (dark) for shadow — no hardcoded black
                                    color:      c.label.withOpacity(0.10),
                                    blurRadius: 20,
                                    offset:     const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.fitness_center_rounded,
                                size:  36,
                                color: c.primary,
                              ),
                            ),
                            SizedBox(height: sp.md),
                            Text(
                              l.signup_title,
                              style: TextStyle(
                                fontSize:   24,
                                fontWeight: FontWeight.bold,
                                color:      c.onPrimary,
                              ),
                            ),
                            SizedBox(height: sp.xs),
                            Text(
                              l.signup_subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color:    c.onPrimary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── White card ────────────────────────────────────
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft:  Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(sp.lg),
                            child: Form(
                              key: _formKey,
                              child: BlocBuilder<RegisterBloc, RegisterState>(
                                builder: (ctx, state) => Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: sp.xs),

                                    // ── Step 1 indicator ────────────────
                                    _StepIndicator(
                                      currentStep: 1,
                                      totalSteps:  3,
                                      stepLabel:   l.signup_step1Label,
                                      tokens:      tokens,
                                    ),
                                    SizedBox(height: sp.lg),

                                    // ── Method label ────────────────────
                                    Text(
                                      l.signup_registrationMethod,
                                      style: TextStyle(
                                        fontSize:   14,
                                        color:      labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Email / Phone toggle ────────────
                                    _MethodToggle(
                                      usePhone:   _usePhone,
                                      tokens:     tokens,
                                      emailLabel: l.auth_emailLabel,
                                      phoneLabel: l.auth_phoneLabel,
                                      onChanged:  (val) => setState(() {
                                        _usePhone = val;
                                        _emailCtrl.clear();
                                        _phoneCtrl.clear();
                                      }),
                                    ),
                                    SizedBox(height: sp.md),

                                    // ── Identifier label ────────────────
                                    Text(
                                      _usePhone
                                          ? l.auth_phoneLabel
                                          : l.auth_emailLabel,
                                      style: TextStyle(
                                        fontSize:   14,
                                        color:      labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Identifier field ────────────────
                                    TextFormField(
                                      controller: _usePhone
                                          ? _phoneCtrl
                                          : _emailCtrl,
                                      keyboardType: _usePhone
                                          ? TextInputType.phone
                                          : TextInputType.emailAddress,
                                      textDirection: TextDirection.ltr,
                                      textAlign:     TextAlign.left,
                                      style: TextStyle(
                                        color:    c.label,
                                        fontSize: 15,
                                      ),
                                      decoration: _inputDecoration(
                                        hint: _usePhone
                                            ? l.auth_phoneHint
                                            : l.auth_emailHint,
                                        suffixIcon: Icon(
                                          _usePhone
                                              ? Icons.phone_outlined
                                              : Icons.email_outlined,
                                          color: c.muted,
                                          size:  20,
                                        ),
                                        tokens: tokens,
                                      ),
                                      validator: (v) =>
                                          _validateIdentifier(v, l),
                                    ),
                                    SizedBox(height: sp.md),

                                    // ── Password label ──────────────────
                                    Text(
                                      l.auth_passwordLabel,
                                      style: TextStyle(
                                        fontSize:   14,
                                        color:      labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Password field ──────────────────
                                    TextFormField(
                                      controller:    _passwordCtrl,
                                      obscureText:   _obscurePass,
                                      textAlign:     TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color:    c.label,
                                        fontSize: 15,
                                      ),
                                      decoration: _inputDecoration(
                                        hint: l.auth_passwordHint,
                                        suffixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: c.muted,
                                          size:  20,
                                        ),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePass
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: c.muted,
                                            size:  20,
                                          ),
                                          onPressed: () => setState(
                                                () => _obscurePass = !_obscurePass,
                                          ),
                                        ),
                                        tokens: tokens,
                                      ),
                                      validator: (v) =>
                                          _validatePassword(v, l),
                                    ),
                                    SizedBox(height: sp.md),

                                    // ── Confirm password label ──────────
                                    Text(
                                      l.signup_confirmPasswordLabel,
                                      style: TextStyle(
                                        fontSize:   14,
                                        color:      labelColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),

                                    // ── Confirm password field ──────────
                                    TextFormField(
                                      controller:    _confirmCtrl,
                                      obscureText:   _obscureConfirm,
                                      textAlign:     TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color:    c.label,
                                        fontSize: 15,
                                      ),
                                      decoration: _inputDecoration(
                                        hint: l.signup_confirmPasswordHint,
                                        suffixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: c.muted,
                                          size:  20,
                                        ),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirm
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: c.muted,
                                            size:  20,
                                          ),
                                          onPressed: () => setState(
                                                () => _obscureConfirm =
                                            !_obscureConfirm,
                                          ),
                                        ),
                                        tokens: tokens,
                                      ),
                                      validator: (v) =>
                                          _validateConfirm(v, l),
                                    ),
                                    SizedBox(height: sp.lg),

                                    // ── Continue button ─────────────────
                                    SizedBox(
                                      height: btn.height,
                                      child: ElevatedButton(
                                        onPressed: state.isLoading
                                            ? null
                                            : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:          c.primary,
                                          foregroundColor:          c.onPrimary,
                                          elevation:                0,
                                          shadowColor:
                                          c.primary.withOpacity(0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                btn.radius),
                                          ),
                                          disabledBackgroundColor:
                                          c.muted.withOpacity(0.3),
                                          disabledForegroundColor: c.muted,
                                        ),
                                        child: state.isLoading
                                            ? SizedBox(
                                          width:  22,
                                          height: 22,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: c.onPrimary,
                                          ),
                                        )
                                            : Text(
                                          l.signup_continueButton,
                                          style: TextStyle(
                                            fontSize:   btn.textSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: sp.md),

                                    // ── Already have account ─────────────
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize:
                                            const Size(0, 0),
                                            tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Text(
                                            l.signup_signIn,
                                            style: TextStyle(
                                              color:      c.primary,
                                              fontSize:   14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: sp.xs),
                                        Text(
                                          l.signup_alreadyHaveAccount,
                                          style: TextStyle(
                                            color:    c.body,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: sp.sm),

                                    // ── Terms ───────────────────────────
                                    Text(
                                      l.signup_termsAgreement,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // c.muted is the theme token for subtle text
                                        color:    c.muted,
                                        fontSize: 11,
                                        height:   1.5,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),
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

  // ── Shared input decoration — only token values, no Colors.* ─────────────
  InputDecoration _inputDecoration({
    required String         hint,
    required AppThemeTokens tokens,
    Widget?                 suffixIcon,
    Widget?                 prefixIcon,
  }) {
    final c      = tokens.colors;
    final radius = tokens.button.radius;
    final side   = BorderSide(color: c.border.withOpacity(0.3), width: 1);

    return InputDecoration(
      hintText:  hint,
      hintStyle: TextStyle(color: c.muted, fontSize: 14),
      filled:    true,
      fillColor: c.surface,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius), borderSide: side),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius), borderSide: side),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:   BorderSide(color: c.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:   BorderSide(color: c.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:   BorderSide(color: c.error, width: 1.5),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step indicator — only AppThemeTokens, no Colors.*
// ─────────────────────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int            currentStep;
  final int            totalSteps;
  final String         stepLabel;
  final AppThemeTokens tokens;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c        = tokens.colors;
    final progress = currentStep / totalSteps;
    final isAr     = Localizations.localeOf(context).languageCode == 'ar';
    final stepText = isAr
        ? 'الخطوة $currentStep من $totalSteps'
        : 'Step $currentStep of $totalSteps';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        // Very subtle tint of primary — same technique used in card tokens
        color:        c.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stepLabel,
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                  color:      c.label,        // token: dark heading color
                ),
              ),
              Text(
                stepText,
                style: TextStyle(
                  fontSize: 12,
                  color:    c.muted,          // token: subtle/secondary text
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:           progress,
              backgroundColor: c.primary.withOpacity(0.12), // token-derived track
              valueColor:      AlwaysStoppedAnimation<Color>(c.primary),
              minHeight:       5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Email / Phone toggle — only AppThemeTokens, no Colors.*
//
// Active tab:   c.surface background  +  c.primary text/icon
// Inactive tab: transparent           +  c.muted text/icon
// This matches the reference image exactly.
// ─────────────────────────────────────────────────────────────────────────────
class _MethodToggle extends StatelessWidget {
  final bool               usePhone;
  final AppThemeTokens     tokens;
  final String             emailLabel;
  final String             phoneLabel;
  final void Function(bool) onChanged;

  const _MethodToggle({
    required this.usePhone,
    required this.tokens,
    required this.emailLabel,
    required this.phoneLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        // Track background — very light border tint, same opacity pattern
        // used in AppThemeBuilder for card borders
        color:        c.border.withOpacity(0.08),
        borderRadius: BorderRadius.circular(tokens.button.radius),
        border: Border.all(color: c.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleTab(
              label:    emailLabel,
              icon:     Icons.email_outlined,
              selected: !usePhone,
              tokens:   tokens,
              onTap:    () { if (usePhone) onChanged(false); },
            ),
          ),
          Expanded(
            child: _ToggleTab(
              label:    phoneLabel,
              icon:     Icons.phone_outlined,
              selected: usePhone,
              tokens:   tokens,
              onTap:    () { if (!usePhone) onChanged(true); },
            ),
          ),
        ],
      ),
    );
  }
}

// Single tab — only AppThemeTokens, no Colors.*
class _ToggleTab extends StatelessWidget {
  final String         label;
  final IconData       icon;
  final bool           selected;
  final AppThemeTokens tokens;
  final VoidCallback   onTap;

  const _ToggleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    // Active:   c.surface pill  + c.primary text (matches image: white pill, green text)
    // Inactive: transparent     + c.muted text
    final bgColor = selected ? c.surface : c.surface.withOpacity(0);
    final fgColor = selected ? c.primary : c.muted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color:        bgColor,
          borderRadius: BorderRadius.circular(tokens.button.radius - 3),
          boxShadow: selected
              ? [
            BoxShadow(
              // c.label (near-black) at very low opacity — no hardcoded Colors.black
              color:      c.label.withOpacity(0.07),
              blurRadius: 6,
              offset:     const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize:   13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color:      fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}