import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_event.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_state.dart';
import 'package:build4allgym/features/forgotpassword/presentation/widgets/auth_card_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'reset_password_screen.dart';

// SCREEN 2 — Enter OTP
// Purpose: user types the 6-digit code from email/SMS
// Has timer (15 min) + resend button
// On success → navigates to Screen 3
class VerifyOtpScreen extends StatefulWidget {
  final String identifier; // email or phone passed from Screen 1

  const VerifyOtpScreen({super.key, required this.identifier});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // 6 controllers — one for each OTP box
  final List<TextEditingController> _otpCtrl =
  List.generate(6, (_) => TextEditingController());
  // 6 focus nodes — control which box is active
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // Countdown timer — 15 minutes = 900 seconds
  int _secondsLeft = 900;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer(); // start countdown when screen opens
  }

  // Starts (or restarts) the 15-minute countdown
  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 900);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel(); // stop when reaches 0
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // Combines all 6 boxes into one string e.g. "292738"
  String get _otpCode => _otpCtrl.map((c) => c.text).join();

  // Formats seconds as "MM:SS" e.g. "14:35"
  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // Called when user taps "Verify Code"
  void _verify(AppLocalizations l10n) {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // LOCALIZED: 'Please enter all 6 digits'
        content: Text(l10n.forgotPassword_enterAllDigits),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    context.read<ForgotPasswordBloc>().add(ForgotVerifyOtpPressed(
      identifier: widget.identifier,
      otpCode: _otpCode,
    ));
  }

  // Called when user taps "Resend"
  // BACKEND HANDLES EVERYTHING — we just call /auth/forgot-password again!
  // The backend: kills old OTP, makes new one, sends it, resets 15 min expiry
  void _resend() {
    for (final c in _otpCtrl) c.clear(); // clear OTP boxes
    _focusNodes[0].requestFocus(); // focus first box
    _startTimer(); // restart countdown
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(identifier: widget.identifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LOCALIZATION: resolves the correct language class at runtime.
    // Passed into _verify() so the snackbar message is also localized.
    final l10n = AppLocalizations.of(context)!;

    // THEME: brand primary color from ThemeCubit
    final primary = Theme.of(context).colorScheme.primary;

    // THEME: muted/body text color from textTheme for the timer text.
    final mutedColor =
        Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF5F5E5A);

    return AuthCardShell(
      // LOCALIZED: 'Enter OTP'
      title: l10n.forgotPassword_otpScreenTitle,
      // LOCALIZED: 'We sent a 6-digit code.\nEnter it below.'
      subtitle: l10n.forgotPassword_otpScreenSubtitle,
      icon: Icons.mark_email_read_outlined,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // Step became 2 → OTP verified → navigate to Screen 3
          // Pass the resetToken (UUID) to Screen 3
          if (state.step == 2 && state.resetToken != null) {
            // FIX: capture the bloc and resetToken BEFORE entering the builder
            // closure. MaterialPageRoute.builder is re-called on every route
            // rebuild. Using ctx.read() inside the builder risks a
            // ProviderNotFoundException when ctx is stale/unmounted.
            final bloc = ctx.read<ForgotPasswordBloc>();
            final token = state.resetToken!;

            Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: ResetPasswordScreen(resetToken: token),
              ),
            ));

            bloc.add(const ForgotClearState());
          }
        },
        builder: (ctx, state) {
          return Column(
            children: [

              // Show where the code was sent (from state.maskedContact)
              // LOCALIZED + THEMED
              // We pick the right localized string based on deliveryMethod.
              // forgotPassword_checkSms / forgotPassword_checkEmail are
              // parametrized methods that inject the maskedContact at runtime.
              if (state.maskedContact != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.deliveryMethod == 'PHONE'
                    // LOCALIZED: "Check your SMS: jo***@..." (AR: "تحقق من SMS لديك: ...")
                        ? l10n.forgotPassword_checkSms
                    // LOCALIZED: "Check your email: jo***@..." (AR: "تحقق من بريدك: ...")
                        : l10n.forgotPassword_checkEmail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // THEMED
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),

              // 6 OTP boxes in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    6,
                        (i) => SizedBox(
                      width: 44,
                      child: TextFormField(
                        controller: _otpCtrl[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            // THEMED
                            borderSide:
                            BorderSide(color: primary, width: 2),
                          ),
                        ),
                        onChanged: (val) {
                          // Auto-jump to next box when digit is typed
                          if (val.isNotEmpty && i < 5) {
                            _focusNodes[i + 1].requestFocus();
                          }
                          // Auto-go back when deleted
                          if (val.isEmpty && i > 0) {
                            _focusNodes[i - 1].requestFocus();
                          }
                        },
                      ),
                    )),
              ),
              const SizedBox(height: 16),

              // Countdown timer
              // LOCALIZED: both states (active + expired) come from ARB files.
              // FIX: pass _secondsLeft (int) to the parametrized ARB method,
              // not _timerText (String). Casting a String "as int" throws a
              // TypeError at runtime. The ARB method receives the raw seconds
              // and the localization layer formats it, OR pass _timerText if
              // the ARB method signature accepts a String — just don't cast.
              Text(
                _secondsLeft > 0
                // LOCALIZED: 'Code expires in MM:SS'
                    ? l10n.forgotPassword_codeExpiresIn(_secondsLeft)
                // LOCALIZED: 'Code expired — please resend'
                    : l10n.forgotPassword_codeExpired,
                style: TextStyle(
                  color: _secondsLeft > 0 ? mutedColor : Colors.red,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () => _verify(l10n),
                  style: ElevatedButton.styleFrom(
                    // THEMED
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                      : Text(
                    // LOCALIZED: 'Verify Code'
                    l10n.forgotPassword_verifyCode,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Resend button — calls /auth/forgot-password again!
              TextButton(
                onPressed: state.isLoading ? null : _resend,
                child: Text(
                  // LOCALIZED: "Didn't receive a code? Resend"
                  // THEMED: color comes from textButtonTheme in AppThemeBuilder
                  l10n.forgotPassword_didntReceiveCode,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}