// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/screens/forgot_password_screen.dart
//
// PURPOSE:
//   SCREEN 1 of the forgot-password flow.
//   The user types their email and taps "Send OTP".
//   On success → navigates to Screen 2 (ForgotPasswordVerifyScreen).
//   On failure → shows an error toast.
//
// STATE MANAGEMENT:
//   - _formKey     : controls Form validation (validate on submit only)
//   - _emailCtrl   : reads the email text when submitting
//   - BlocConsumer : listens for state changes (navigation, toasts) AND
//                    rebuilds the button's loading state
//
// NAVIGATION:
//   Pushes ForgotPasswordVerifyScreen and passes the SAME BLoC instance via
//   BlocProvider.value so all three screens share state seamlessly.
//
// RELATIONSHIPS:
//   ▶ Fires:     ForgotSendCodePressed, ForgotClearMessage
//   ▶ Listens to: ForgotPasswordState (isLoading, successMessage, error)
//   ▶ Navigates to: ForgotPasswordVerifyScreen
//   ▶ Uses:      AuthCardShell, AppTextField, PrimaryButton, AppToast
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:build4allgym/common/widgets/app_text_field.dart';
import 'package:build4allgym/common/widgets/primary_button.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/exception_mapper.dart';

import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';
import '../widgets/auth_card_shell.dart';
import 'verify_otp_screen.dart';


class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState
    extends State<ForgotPasswordEmailScreen> {
  // Controls Form.validate() — validates only on submit, not on every keystroke
  final _formKey = GlobalKey<FormState>();

  // Reads what the user typed in the email field
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    // Must dispose to free memory when screen is removed from the widget tree
    _emailCtrl.dispose();
    super.dispose();
  }

  // Called when user taps "Send Code" button
  void _submit() {
    final l10n = AppLocalizations.of(context)!;

    // Run all validators — if any return an error string, stop here
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();

    // Extra safety check (validator already catches this, but just in case)
    if (email.isEmpty) {
      AppToast.error(context, l10n.forgotPassword_fieldRequired);
      return;
    }

    // Fire Step 1 event → BLoC._onSend() → SendResetCode use case → API
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(
        email: email,
        ownerProjectLinkId: int.tryParse(Env.ownerProjectLinkId) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolves to AppLocalizationsEn or AppLocalizationsAr at runtime
    final l10n = AppLocalizations.of(context)!;

    return AuthCardShell(
      title: l10n.forgotPassword_title,       // "Reset your password"
      subtitle: l10n.forgotPassword_subtitle, // "Enter your email and we'll send you a code."
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(

        // listener: runs side-effects only (navigation + toasts)
        // Does NOT rebuild the UI — that's the builder's job
        listener: (ctx, state) {
          // API call failed → show cleaned error message
          if (state.error != null) {
            AppToast.error(ctx, ExceptionMapper.toMessage(state.error!));
          }

          // API call succeeded → show success toast and navigate to Screen 2
          if (state.successMessage != null) {
            AppToast.success(ctx, state.successMessage!);

            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  // BlocProvider.value passes the EXISTING BLoC instance (not a new one)
                  // This is critical — all 3 screens must share the same BLoC
                  value: ctx.read<ForgotPasswordBloc>(),
                  child: ForgotPasswordVerifyScreen(
                    email: _emailCtrl.text.trim(),
                  ),
                ),
              ),
            );

            // Clear successMessage so pressing Back doesn't retrigger navigation
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearMessage());
          }
        },

        // builder: rebuilds UI whenever state changes (e.g. isLoading toggled)
        builder: (ctx, state) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled, // only validate on submit
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Email input field
                AppTextField(
                  label: l10n.auth_emailLabel,   // ✅ "Email Address" / "البريد الإلكتروني"
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(), // tapping "Done" on keyboard submits
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return l10n.forgotPassword_fieldRequired; // ✅
                    if (!val.contains('@')) return l10n.validation_invalidEmail; // ✅
                    return null; // null = valid
                  },
                ),
                const SizedBox(height: 16),

                // Submit button — shows spinner when isLoading = true
                PrimaryButton(
                  label: l10n.forgotPassword_sendCode, // ✅ "Send code"
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 10),

                // Tip shown below the button
                Text(
                  l10n.forgotPassword_spamTip, // ✅ "Tip: check spam/junk folder too 👀"
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}