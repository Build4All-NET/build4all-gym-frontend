import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_event.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_state.dart';
import 'package:build4allgym/features/forgotpassword/presentation/widgets/auth_card_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'verify_otp_screen.dart';

// SCREEN 1 — Forgot Password
// Purpose: user types email or phone → taps "Send OTP"
// On success → navigates to Screen 2
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();

  @override
  void dispose() {
    _identifierCtrl.dispose(); // clean up memory when screen closes
    super.dispose();
  }

  // Called when user taps "Send OTP" button
  void _submit() {
    // Check all validators pass before doing anything
    if (!_formKey.currentState!.validate()) return;

    // Fire event → BLoC calls initiateForgotPassword use case
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(identifier: _identifierCtrl.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LOCALIZATION: resolves the correct language class at runtime.
    // If device is Arabic → AppLocalizationsAr, English → AppLocalizationsEn.
    // Every string from here on comes from here — ZERO hardcoded text.
    final l10n = AppLocalizations.of(context)!;

    // THEME: pulls the primary brand color that was set by ThemeCubit.
    // If the remote theme JSON has "primary": "#E91E8C" → this becomes pink.
    final primary = Theme.of(context).colorScheme.primary;

    // THEME: muted color for hint/tip text — uses bodySmall from our
    // TextTheme which is configured in AppThemeBuilder. Falls back to a
    // neutral grey if the token has no value.
    final mutedColor =
        Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF5F5E5A);

    return AuthCardShell(
      // LOCALIZED: reads from ARB file → "Reset your password" (EN) / "إعادة تعيين كلمة المرور" (AR)
      title: l10n.forgotPassword_title,

      // LOCALIZED: English subtitle
      subtitle: l10n.forgotPassword_subtitle,

      icon: Icons.lock_reset,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        // listener: reacts to STATE CHANGES (navigation, toasts)
        listener: (ctx, state) {
          // Show error as a red snackbar
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // Step became 1 → OTP was sent → navigate to Screen 2
          if (state.step == 1) {
            // FIX: capture the bloc BEFORE entering the builder closure.
            // MaterialPageRoute.builder is re-called on every route rebuild
            // (theme change, keyboard, orientation, etc.). If we called
            // ctx.read() inside the builder, ctx would be stale/unmounted
            // on subsequent calls → ProviderNotFoundException.
            final bloc = ctx.read<ForgotPasswordBloc>();
            final identifier = _identifierCtrl.text.trim();

            Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                // Pass the SAME BLoC to Screen 2 — it carries the state!
                value: bloc,
                child: VerifyOtpScreen(identifier: identifier),
              ),
            ));

            // Reset state so this listener doesn't fire again when going back
            bloc.add(const ForgotClearState());
          }
        },
        // builder: rebuilds the UI when state changes (loading spinner etc.)
        builder: (ctx, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Email or phone input
                TextFormField(
                  controller: _identifierCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // LOCALIZED: 'Email or Phone'
                    labelText: l10n.forgotPassword_emailOrPhone,
                    // LOCALIZED: 'john@gmail.com or +96170123456'
                    hintText: l10n.forgotPassword_emailOrPhoneHint,
                    // THEMED: icon color
                    prefixIcon: Icon(Icons.person_outline, color: primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // THEMED: focused border color
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    // LOCALIZED: 'This field is required'
                    if (val.isEmpty) return l10n.forgotPassword_fieldRequired;
                    if (!val.contains('@') && val.length < 8) {
                      // LOCALIZED: 'Enter a valid email or phone number'
                      return l10n.forgotPassword_invalidEmailOrPhone;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Send OTP button — shows spinner when loading
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submit,
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
                      // LOCALIZED: 'Send OTP'
                      l10n.forgotPassword_sendOtp,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  // LOCALIZED: 'Check your email or SMS for the verification code.'
                  l10n.forgotPassword_checkEmailOrSms,
                  style: TextStyle(fontSize: 12, color: mutedColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}