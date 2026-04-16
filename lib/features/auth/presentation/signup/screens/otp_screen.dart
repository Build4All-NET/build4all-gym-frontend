import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/core/theme/app_theme_tokens.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_banner.dart';
import 'package:build4allgym/features/auth/data/repository/auth_repository_impl.dart';
import 'package:build4allgym/features/auth/data/services/auth_api_service.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/features/auth/domain/usecases/verify_email_code.dart';
import 'package:build4allgym/features/auth/domain/usecases/verify_phone_code.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_bloc.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_event.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_state.dart';
import 'package:build4allgym/features/auth/presentation/signup/screens/complete_profile_screen.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OTP screen — step 2 of 3 in the signup flow.
//
// Receives RegisterBloc via BlocProvider.value from SignupScreen.
// On successful verification navigates to CompleteProfileScreen,
// also passing the same BLoC via BlocProvider.value.
// ─────────────────────────────────────────────────────────────────────────────
class OtpScreen extends StatefulWidget {
  /// Contact string shown in the "sent to" box (masked email or phone).
  final String  contact;

  /// Raw email used for the verify API call (empty string when phone flow).
  final String  email;

  /// Raw phone for the verify API call (null when email flow).
  final String? phone;

  /// Password carried forward to CompleteProfileScreen if needed.
  final String  password;

  const OtpScreen({
    super.key,
    required this.contact,
    required this.email,
    this.phone,
    required this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // ── OTP boxes ─────────────────────────────────────────────────────────────
  static const int _boxCount = 6;
  final List<TextEditingController> _controllers =
  List.generate(_boxCount, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_boxCount, (_) => FocusNode());

  // ── Timer ─────────────────────────────────────────────────────────────────
  static const int _timerStart = 60;
  int    _secondsLeft = _timerStart;
  Timer? _timer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _focusNodes[0].requestFocus(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes)   f.dispose();
    super.dispose();
  }

  // ─── timer ────────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _timerStart);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _timerLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return m > 0
        ? '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '$_secondsLeft';
  }

  // ─── OTP helpers ──────────────────────────────────────────────────────────

  String get _code => _controllers.map((c) => c.text).join();

  void _onBoxChanged(String value, int index) {
    if (value.length == 1 && index < _boxCount - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  // ─── verify ───────────────────────────────────────────────────────────────
  // Creates use cases inline — AuthRepositoryImpl is NOT in the widget tree,
  // so we never use context.read<AuthRepositoryImpl>().

  Future<void> _verify(AppThemeTokens tokens, AppLocalizations l) async {
    final code = _code.trim();
    if (code.length < _boxCount) {
      _showSnack(l.otp_enterAllDigits, tokens.colors.error, tokens);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Build use cases directly — same pattern as signup_screen.dart
      final tokenStore = const AuthTokenStore();
      final apiService = AuthApiService(
        client:     http.Client(),
        tokenStore: tokenStore,
      );
      final repo    = AuthRepositoryImpl(apiService);
      final isPhone = widget.phone != null && widget.phone!.isNotEmpty;

      int pendingId;

      if (isPhone) {
        final result = await VerifyPhoneCode(repo)(
          phoneNumber: widget.phone!,
          code:        code,
        );
        pendingId = result.fold(
              (failure) => throw Exception(failure.message),
              (id)      => id,
        );
      } else {
        final result = await VerifyEmailCode(repo)(
          email: widget.email,
          code:  code,
        );
        pendingId = result.fold(
              (failure) => throw Exception(failure.message),
              (id)      => id,
        );
      }

      if (!mounted) return;

      _showSnack(l.otp_verifiedSuccess, tokens.colors.success, tokens);

      // Navigate to CompleteProfileScreen.
      // Pass the existing RegisterBloc via BlocProvider.value so the whole
      // signup flow shares one BLoC instance.
      // AppConfig.fromEnv() is used here instead of threading AppConfig
      // through the entire OtpScreen widget chain.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<RegisterBloc>(),
            child: CompleteProfileScreen(
              pendingId: pendingId,
              appConfig: AppConfig.fromEnv(),
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack(l.validation_invalidCode, tokens.colors.error, tokens);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── resend ───────────────────────────────────────────────────────────────

  void _resend(AppThemeTokens tokens, AppLocalizations l) {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();

    context.read<RegisterBloc>().add(
      RegisterSendCodeSubmitted(
        method:      widget.phone != null && widget.phone!.isNotEmpty
            ? RegisterMethod.phone
            : RegisterMethod.email,
        email:       (widget.phone != null) ? null : widget.email,
        phoneNumber: widget.phone,
        password:    widget.password,
      ),
    );

    _showSnack(l.otp_codeSentAgain, tokens.colors.success, tokens);
  }

  // ─── snackbar helper ──────────────────────────────────────────────────────

  void _showSnack(String msg, Color bg, AppThemeTokens tokens) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: bg,
        behavior:        SnackBarBehavior.floating,
        margin:          const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.card.radius),
        ),
      ),
    );
  }

  // ─── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final btn    = tokens.button;
    final sp     = tokens.spacing;
    final l      = AppLocalizations.of(context)!;

    final gradientEnd  = Color.lerp(c.primary, c.success, 0.3) ?? c.primary;
    final codeComplete = _code.length == _boxCount;
    final canResend    = _secondsLeft == 0;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (ctx, state) {
        if (state.errorCode != null) {
          _showSnack(_resolveError(state.errorCode, l), c.error, tokens);
        }
      },
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
                      // ── Gradient header ─────────────────────────────
                      Padding(
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
                              child: Icon(
                                Icons.fitness_center_rounded,
                                size:  36,
                                color: c.primary,
                              ),
                            ),
                            SizedBox(height: sp.md),
                            Text(
                              l.otp_title,
                              style: TextStyle(
                                fontSize:   24,
                                fontWeight: FontWeight.bold,
                                color:      c.onPrimary,
                              ),
                            ),
                            SizedBox(height: sp.xs),
                            Text(
                              l.otp_subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color:    c.onPrimary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── White card ──────────────────────────────────
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
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: sp.xs),

                                // Step 2 of 3
                                _StepIndicator(
                                  currentStep: 2,
                                  totalSteps:  3,
                                  stepLabel:   l.otp_step2Label,
                                  tokens:      tokens,
                                ),
                                SizedBox(height: sp.lg),

                                // "Sent to" box
                                _SentToBox(
                                  contact: widget.contact,
                                  tokens:  tokens,
                                  isPhone: widget.phone != null &&
                                      widget.phone!.isNotEmpty,
                                ),
                                SizedBox(height: sp.lg),

                                // Instruction
                                Text(
                                  l.otp_enterDigits(_boxCount),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:   14,
                                    fontWeight: FontWeight.w500,
                                    color:      c.label,
                                  ),
                                ),
                                SizedBox(height: sp.md),

                                // OTP boxes
                                _OtpBoxRow(
                                  controllers: _controllers,
                                  focusNodes:  _focusNodes,
                                  boxCount:    _boxCount,
                                  tokens:      tokens,
                                  onChanged:   _onBoxChanged,
                                ),
                                SizedBox(height: sp.lg),

                                // "Didn't receive?" + countdown/resend
                                Column(
                                  children: [
                                    Text(
                                      l.otp_didntReceive,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:    c.muted,
                                      ),
                                    ),
                                    SizedBox(height: sp.xs),
                                    canResend
                                        ? TextButton(
                                      onPressed: () =>
                                          _resend(tokens, l),
                                      style: TextButton.styleFrom(
                                        foregroundColor: c.primary,
                                        padding:         EdgeInsets.zero,
                                        minimumSize:
                                        const Size(0, 0),
                                        tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                      ),
                                      child: Text(
                                        l.otp_resendNow,
                                        style: TextStyle(
                                          fontSize:   14,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: c.primary,
                                        ),
                                      ),
                                    )
                                        : Text(
                                      isAr
                                          ? 'إعادة الإرسال بعد $_timerLabel ثانية'
                                          : 'Resend after $_timerLabel seconds',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:   14,
                                        fontWeight: FontWeight.w500,
                                        color:      c.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sp.lg),

                                // Verify button
                                SizedBox(
                                  height: btn.height,
                                  child: ElevatedButton(
                                    onPressed: (_isLoading || !codeComplete)
                                        ? null
                                        : () => _verify(tokens, l),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:         c.primary,
                                      foregroundColor:         c.onPrimary,
                                      elevation:               0,
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
                                    child: _isLoading
                                        ? SizedBox(
                                      width:  22,
                                      height: 22,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:       c.onPrimary,
                                      ),
                                    )
                                        : Text(
                                      l.otp_verifyButton,
                                      style: TextStyle(
                                        fontSize:   btn.textSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: sp.md),

                                // Debug tip — only in debug builds
                                _DebugTipBox(tokens: tokens),
                                SizedBox(height: sp.lg),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // "← Back to registration" — outside card
                      Container(
                        color: c.surface,
                        padding:
                        EdgeInsets.symmetric(vertical: sp.md),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: c.muted,
                            padding:         EdgeInsets.zero,
                            minimumSize:     const Size(0, 0),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size:  13,
                                color: c.muted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l.otp_backToSignup,
                                style: TextStyle(
                                  fontSize: 13,
                                  color:    c.muted,
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
            ],
          ),
        ),
      ),
    );
  }

  String _resolveError(String? code, AppLocalizations l) {
    switch (code) {
      case 'INVALID_CODE':
      case 'INVALID_OTP':  return l.validation_invalidCode;
      case 'NO_INTERNET':
      case 'NETWORK_ERROR': return l.connection_offline;
      case 'TIMEOUT':      return l.connection_timeout;
      default:             return l.error_somethingWentWrong;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step indicator
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
                  fontSize: 13, fontWeight: FontWeight.w600, color: c.label,
                ),
              ),
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

// ─────────────────────────────────────────────────────────────────────────────
// "Sent to" info box
// ─────────────────────────────────────────────────────────────────────────────
class _SentToBox extends StatelessWidget {
  final String         contact;
  final AppThemeTokens tokens;
  final bool           isPhone;

  const _SentToBox({
    required this.contact,
    required this.tokens,
    required this.isPhone,
  });

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final l   = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        c.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.success.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color: c.success.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPhone ? Icons.phone_outlined : Icons.email_outlined,
              color: c.success,
              size:  20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.otp_sentTo,
                  style: TextStyle(fontSize: 12, color: c.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  contact,
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                    color:      c.label,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OTP boxes row
// ─────────────────────────────────────────────────────────────────────────────
class _OtpBoxRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode>             focusNodes;
  final int                         boxCount;
  final AppThemeTokens              tokens;
  final void Function(String, int)  onChanged;

  const _OtpBoxRow({
    required this.controllers,
    required this.focusNodes,
    required this.boxCount,
    required this.tokens,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final btn = tokens.button;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(boxCount, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width:  46,
            height: 52,
            child: TextField(
              controller:    controllers[i],
              focusNode:     focusNodes[i],
              textAlign:     TextAlign.center,
              keyboardType:  TextInputType.number,
              maxLength:     1,
              style: TextStyle(
                fontSize:   22,
                fontWeight: FontWeight.w700,
                color:      c.label,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                filled:      true,
                fillColor:   c.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(btn.radius),
                  borderSide:
                  BorderSide(color: c.border.withOpacity(0.35), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(btn.radius),
                  borderSide:
                  BorderSide(color: c.border.withOpacity(0.35), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(btn.radius),
                  borderSide: BorderSide(color: c.primary, width: 2),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) => onChanged(val, i),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Debug tip — only shown in debug builds
// ─────────────────────────────────────────────────────────────────────────────
class _DebugTipBox extends StatelessWidget {
  final AppThemeTokens tokens;

  const _DebugTipBox({required this.tokens});

  @override
  Widget build(BuildContext context) {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    if (!isDebug) return const SizedBox.shrink();

    final c = tokens.colors;
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        c.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧪 ', style: TextStyle(fontSize: 14)),
          Text(
            l.otp_debugTip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.w500,
              color:      c.success,
            ),
          ),
        ],
      ),
    );
  }
}