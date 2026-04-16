import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/theme/app_theme_tokens.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_bloc.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_event.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_state.dart';
import 'package:build4allgym/features/shell/presentation/screens/main_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'otp_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CompleteProfileScreen
//
// Uses the RegisterBloc that was created in SignupScreen and passed through
// OtpScreen via BlocProvider.value — no new BLoC needed.
//
// Navigation into this screen:
//   Navigator.push(ctx, MaterialPageRoute(
//     builder: (_) => BlocProvider.value(
//       value: ctx.read<RegisterBloc>(),
//       child: CompleteProfileScreen(pendingId: id, appConfig: config),
//     ),
//   ));
// ─────────────────────────────────────────────────────────────────────────────
class CompleteProfileScreen extends StatefulWidget {
  final int       pendingId;
  final AppConfig appConfig;

  const CompleteProfileScreen({
    super.key,
    required this.pendingId,
    required this.appConfig,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Sub-step: 1 = names, 2 = username + profile type
  int _subStep = 1;

  final _step1Key      = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();

  final _step2Key     = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  bool  _isPublic     = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  void _submitStep1() {
    if (!_step1Key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<RegisterBloc>().add(
      RegisterNamesSubmitted(
        firstName: _firstNameCtrl.text.trim(),
        lastName:  _lastNameCtrl.text.trim(),
      ),
    );
    setState(() => _subStep = 2);
  }

  void _submitStep2() {
    if (!_step2Key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<RegisterBloc>().add(
      RegisterProfileFinished(
        pendingId:          widget.pendingId,
        username:           _usernameCtrl.text.trim(),
        isPublicProfile:    _isPublic,
        ownerProjectLinkId: int.tryParse(Env.ownerProjectLinkId) ?? 1,
      ),
    );
  }

  void _goBack() {
    if (_subStep == 2) {
      setState(() => _subStep = 1);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final sp     = tokens.spacing;
    final card   = tokens.card;
    final l      = AppLocalizations.of(context)!;

    final gradientEnd = Color.lerp(c.primary, c.success, 0.3) ?? c.primary;

    return MultiBlocListener(
      listeners: [
        // Fires ONLY when profile is freshly completed
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (prev, curr) =>
          !prev.isProfileComplete && curr.isProfileComplete,
          listener: (ctx, state) {
            if (state.completedUser == null) return;
            ctx.read<AuthBloc>().add(
              AuthLoginHydrated(
                user:        state.completedUser,
                token:       '',
                wasInactive: false,
              ),
            );
            Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainShell(appConfig: widget.appConfig),
              ),
                  (_) => false,
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
                content:         Text(_resolveError(state.errorCode, l)),
                backgroundColor: c.error,
                behavior:        SnackBarBehavior.floating,
                margin:          const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(card.radius),
                ),
              ),
            );
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
                      _buildHeader(tokens, l),
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
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: _subStep == 1
                                  ? _SubStep1(
                                key:           const ValueKey(1),
                                formKey:       _step1Key,
                                firstNameCtrl: _firstNameCtrl,
                                lastNameCtrl:  _lastNameCtrl,
                                tokens:        tokens,
                                l:             l,
                                onSubmit:      _submitStep1,
                                onBack:        _goBack,
                              )
                                  : _SubStep2(
                                key:             const ValueKey(2),
                                formKey:         _step2Key,
                                usernameCtrl:    _usernameCtrl,
                                isPublic:        _isPublic,
                                tokens:          tokens,
                                l:               l,
                                onSubmit:        _submitStep2,
                                onBack:          _goBack,
                                onPublicChanged: (v) =>
                                    setState(() => _isPublic = v),
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

  Widget _buildHeader(AppThemeTokens tokens, AppLocalizations l) {
    final c  = tokens.colors;
    final sp = tokens.spacing;

    final title    = _subStep == 1 ? l.completeProfile_title    : l.completeProfile_lastStepTitle;
    final subtitle = _subStep == 1 ? l.completeProfile_subtitle : l.completeProfile_lastStepSubtitle;
    final icon     = _subStep == 1 ? Icons.person_outline_rounded : Icons.alternate_email_rounded;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xl),
      child: Column(
        children: [
          Container(
            width:  72,
            height: 72,
            decoration: BoxDecoration(
              color:        c.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:      c.label.withOpacity(0.10),
                  blurRadius: 20,
                  offset:     const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 36, color: c.primary),
          ),
          SizedBox(height: sp.md),
          Text(
            title,
            style: TextStyle(
              fontSize:   24,
              fontWeight: FontWeight.bold,
              color:      c.onPrimary,
            ),
          ),
          SizedBox(height: sp.xs),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: c.onPrimary.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  String _resolveError(String? code, AppLocalizations l) {
    switch (code) {
      case 'USERNAME_TAKEN': return l.completeProfile_usernameTaken;
      case 'NO_INTERNET':
      case 'NETWORK_ERROR':  return l.connection_offline;
      case 'TIMEOUT':        return l.connection_timeout;
      case 'SERVER_ERROR':   return l.error_serverError;
      default:               return l.error_somethingWentWrong;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-step 1
// ─────────────────────────────────────────────────────────────────────────────
class _SubStep1 extends StatelessWidget {
  final GlobalKey<FormState>  formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final AppThemeTokens        tokens;
  final AppLocalizations      l;
  final VoidCallback          onSubmit;
  final VoidCallback          onBack;

  const _SubStep1({
    super.key,
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.tokens,
    required this.l,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final c          = tokens.colors;
    final btn        = tokens.button;
    final sp         = tokens.spacing;
    final labelColor = c.label.withOpacity(0.7);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: sp.xs),
          _StepIndicator(
            currentStep: 3,
            totalSteps:  3,
            stepLabel:   '${l.completeProfile_stepLabel} (1/2)',
            tokens:      tokens,
          ),
          SizedBox(height: sp.lg),
          Center(
            child: Container(
              width:  80,
              height: 80,
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                size:  42,
                color: c.primary,
              ),
            ),
          ),
          SizedBox(height: sp.md),
          Text(
            l.completeProfile_nameInstruction,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.muted),
          ),
          SizedBox(height: sp.lg),

          Text(l.completeProfile_firstName,
              style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
          SizedBox(height: sp.xs),
          TextFormField(
            controller:    firstNameCtrl,
            textDirection: TextDirection.rtl,
            style: TextStyle(color: c.label, fontSize: 15),
            decoration: _inputDecoration(
              hint: l.completeProfile_firstNameHint,
              icon: Icons.person_outline_rounded,
              tokens: tokens,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l.completeProfile_firstNameRequired
                : null,
          ),
          SizedBox(height: sp.md),

          Text(l.completeProfile_lastName,
              style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
          SizedBox(height: sp.xs),
          TextFormField(
            controller:    lastNameCtrl,
            textDirection: TextDirection.rtl,
            style: TextStyle(color: c.label, fontSize: 15),
            decoration: _inputDecoration(
              hint: l.completeProfile_lastNameHint,
              icon: Icons.person_outline_rounded,
              tokens: tokens,
            ),
          ),
          SizedBox(height: sp.xl),

          SizedBox(
            height: btn.height,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation:       0,
                shadowColor:     c.primary.withOpacity(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btn.radius),
                ),
              ),
              child: Text(
                l.completeProfile_continueButton,
                style: TextStyle(fontSize: btn.textSize, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: sp.md),
          _BackLink(tokens: tokens, l: l, onBack: onBack),
          SizedBox(height: sp.xs),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-step 2
// ─────────────────────────────────────────────────────────────────────────────
class _SubStep2 extends StatelessWidget {
  final GlobalKey<FormState>  formKey;
  final TextEditingController usernameCtrl;
  final bool                  isPublic;
  final AppThemeTokens        tokens;
  final AppLocalizations      l;
  final VoidCallback          onSubmit;
  final VoidCallback          onBack;
  final void Function(bool)   onPublicChanged;

  const _SubStep2({
    super.key,
    required this.formKey,
    required this.usernameCtrl,
    required this.isPublic,
    required this.tokens,
    required this.l,
    required this.onSubmit,
    required this.onBack,
    required this.onPublicChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c          = tokens.colors;
    final btn        = tokens.button;
    final sp         = tokens.spacing;
    final labelColor = c.label.withOpacity(0.7);

    return Form(
      key: formKey,
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (ctx, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: sp.xs),
            _StepIndicator(
              currentStep: 3,
              totalSteps:  3,
              stepLabel:   '${l.completeProfile_stepLabel} (2/2)',
              tokens:      tokens,
            ),
            SizedBox(height: sp.lg),

            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width:  80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: c.primary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alternate_email_rounded,
                      size:  42,
                      color: c.primary,
                    ),
                  ),
                  const Positioned(
                    top: -4, right: -8,
                    child: Text('✨', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.md),
            Text(
              l.completeProfile_usernameInstruction,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.muted),
            ),
            SizedBox(height: sp.lg),

            Text(l.completeProfile_username,
                style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
            SizedBox(height: sp.xs),
            TextFormField(
              controller:    usernameCtrl,
              textDirection: TextDirection.ltr,
              textAlign:     TextAlign.left,
              style: TextStyle(color: c.label, fontSize: 15),
              decoration: _inputDecoration(
                hint:       'username',
                icon:       Icons.alternate_email_rounded,
                tokens:     tokens,
                prefixText: '@  ',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.completeProfile_usernameRequired;
                if (v.trim().length < 3)           return l.completeProfile_usernameTooShort;
                if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(v.trim())) {
                  return l.completeProfile_usernameInvalid;
                }
                return null;
              },
            ),
            SizedBox(height: sp.lg),

            Text(l.completeProfile_profileType,
                style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
            SizedBox(height: sp.sm),

            _ProfileTypeCard(
              title:       l.completeProfile_publicTitle,
              description: l.completeProfile_publicDescription,
              icon:        Icons.public_rounded,
              selected:    isPublic,
              tokens:      tokens,
              onTap:       () => onPublicChanged(true),
            ),
            SizedBox(height: sp.sm),
            _ProfileTypeCard(
              title:       l.completeProfile_privateTitle,
              description: l.completeProfile_privateDescription,
              icon:        Icons.lock_outline_rounded,
              selected:    !isPublic,
              tokens:      tokens,
              onTap:       () => onPublicChanged(false),
            ),
            SizedBox(height: sp.md),

            _InfoBox(message: l.completeProfile_settingsNote, tokens: tokens),
            SizedBox(height: sp.lg),

            SizedBox(
              height: btn.height,
              child: ElevatedButton.icon(
                onPressed: state.isLoading ? null : onSubmit,
                icon: state.isLoading
                    ? SizedBox(
                  width:  18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color:       c.onPrimary,
                  ),
                )
                    : Icon(Icons.check_circle_outline_rounded, color: c.onPrimary, size: 20),
                label: Text(
                  l.completeProfile_finishButton,
                  style: TextStyle(fontSize: btn.textSize, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:         c.primary,
                  foregroundColor:         c.onPrimary,
                  elevation:               0,
                  shadowColor:             c.primary.withOpacity(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(btn.radius),
                  ),
                  disabledBackgroundColor: c.muted.withOpacity(0.3),
                  disabledForegroundColor: c.muted,
                ),
              ),
            ),
            SizedBox(height: sp.md),
            _BackLink(tokens: tokens, l: l, onBack: onBack),
            SizedBox(height: sp.xs),
          ],
        ),
      ),
    );
  }
}

// ── Profile type card ─────────────────────────────────────────────────────────
class _ProfileTypeCard extends StatelessWidget {
  final String         title;
  final String         description;
  final IconData       icon;
  final bool           selected;
  final AppThemeTokens tokens;
  final VoidCallback   onTap;

  const _ProfileTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c    = tokens.colors;
    final card = tokens.card;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? c.primary.withOpacity(0.06) : c.surface,
          borderRadius: BorderRadius.circular(card.radius),
          border: Border.all(
            color: selected ? c.primary : c.border.withOpacity(0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: selected ? c.primary : c.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:   15,
                      fontWeight: FontWeight.w600,
                      color:      selected ? c.primary : c.label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(description,
                      style: TextStyle(fontSize: 12, color: c.muted)),
                ],
              ),
            ),
            Container(
              width:  20,
              height: 20,
              decoration: BoxDecoration(
                shape:  BoxShape.circle,
                border: Border.all(
                  color: selected ? c.primary : c.border,
                  width: 2,
                ),
                color: selected ? c.primary : c.surface,
              ),
              child: selected
                  ? Icon(Icons.check_rounded, size: 12, color: c.onPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info box ──────────────────────────────────────────────────────────────────
class _InfoBox extends StatelessWidget {
  final String         message;
  final AppThemeTokens tokens;

  const _InfoBox({required this.message, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c    = tokens.colors;
    final card = tokens.card;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:        c.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(card.radius),
        border: Border.all(color: c.primary.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: c.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: c.primary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────
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
              Text(stepLabel,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.label)),
              Text(stepText,
                  style: TextStyle(fontSize: 12, color: c.muted)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:           progress,
              backgroundColor: c.primary.withOpacity(0.12),
              valueColor:      AlwaysStoppedAnimation<Color>(c.primary),
              minHeight:       5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Back link ─────────────────────────────────────────────────────────────────
class _BackLink extends StatelessWidget {
  final AppThemeTokens   tokens;
  final AppLocalizations l;
  final VoidCallback     onBack;

  const _BackLink({required this.tokens, required this.l, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return TextButton(
      onPressed: onBack,
      style: TextButton.styleFrom(
        foregroundColor: c.muted,
        padding:         EdgeInsets.zero,
        minimumSize:     const Size(0, 0),
        tapTargetSize:   MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: c.muted),
          const SizedBox(width: 4),
          Text(l.completeProfile_backButton,
              style: TextStyle(fontSize: 13, color: c.muted)),
        ],
      ),
    );
  }
}

// ── Shared input decoration ───────────────────────────────────────────────────
InputDecoration _inputDecoration({
  required String         hint,
  required IconData       icon,
  required AppThemeTokens tokens,
  String?                 prefixText,
}) {
  final c      = tokens.colors;
  final radius = tokens.button.radius;
  final side   = BorderSide(color: c.border.withOpacity(0.3), width: 1);

  return InputDecoration(
    hintText:    hint,
    hintStyle:   TextStyle(color: c.muted, fontSize: 14),
    filled:      true,
    fillColor:   c.surface,
    prefixText:  prefixText,
    prefixStyle: TextStyle(color: c.muted, fontSize: 15, fontWeight: FontWeight.w500),
    suffixIcon:  Icon(icon, color: c.muted, size: 20),
    border:             OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: side),
    enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: side),
    focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
    errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: c.error, width: 1)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: c.error, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}