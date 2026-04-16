// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/screens/verify_otp_screen.dart
//
// PURPOSE:
//   SCREEN 2 of the forgot-password flow.
//   The user types the OTP they received and taps "Verify".
//   Also has a "Resend" button that fires the same Step 1 event again.
//   On success → navigates to Screen 3 (ForgotPasswordNewPasswordScreen).
//
// DATA FLOW:
//   - [email] is passed from Screen 1 via constructor (not stored in BLoC state)
//   - The OTP code is passed to Screen 3 via constructor when navigating
//
// RELATIONSHIPS:
//   ▶ Fires:       ForgotVerifyCodePressed, ForgotSendCodePressed (resend),
//                  ForgotClearMessage
//   ▶ Listens to:  ForgotPasswordState
//   ▶ Navigates to: ForgotPasswordNewPasswordScreen
//   ▶ Uses:        AuthCardShell, AppTextField, PrimaryButton, AppToast
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/common/widgets/app_text_field.dart';
import 'package:build4allgym/common/widgets/primary_button.dart';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/exceptions/exception_mapper.dart';

import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';
import '../widgets/auth_card_shell.dart';
import 'reset_password_screen.dart';

class ForgotPasswordVerifyScreen extends StatefulWidget {
  // Received from Screen 1 — backend needs the email again for verification
  final String email;

  const ForgotPasswordVerifyScreen({super.key, required this.email});

  @override
  State<ForgotPasswordVerifyScreen> createState() =>
      _ForgotPasswordVerifyScreenState();
}

class _ForgotPasswordVerifyScreenState
    extends State<ForgotPasswordVerifyScreen> {
  final _formKey = GlobalKey<FormState>();

  // The OTP code the user types — also passed to Screen 3 via constructor
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  // Called when user taps "Verify"
  void _verify() {
    if (!_formKey.currentState!.validate()) return;

    // Fire Step 2 event → BLoC._onVerify() → VerifyResetCode use case → API
    context.read<ForgotPasswordBloc>().add(
      ForgotVerifyCodePressed(
        email: widget.email,
        code: _codeCtrl.text.trim(),
        ownerProjectLinkId: int.tryParse(Env.ownerProjectLinkId) ?? 0,
      ),
    );
  }

  // Called when user taps "Resend code"
  // Fires the SAME Step 1 event as Screen 1 — backend handles resend automatically
  void _resend() {
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(
        email: widget.email,
        ownerProjectLinkId: int.tryParse(Env.ownerProjectLinkId) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthCardShell(
      title: l10n.forgotPassword_verifyTitle, // ✅ "Enter verification code"

      // ✅ Parametrized method — injects email into "We sent a code to {email}"
      subtitle: l10n.forgotPassword_codeSentTo(widget.email),

      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          // API failed → show error toast
          if (state.error != null) {
            AppToast.error(ctx, ExceptionMapper.toMessage(state.error!));
          }

          // API succeeded → show toast and navigate to Screen 3
          if (state.successMessage != null) {
            AppToast.success(ctx, state.successMessage!);

            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  // Pass the same BLoC — Screen 3 shares state
                  value: ctx.read<ForgotPasswordBloc>(),
                  child: ForgotPasswordNewPasswordScreen(
                    email: widget.email,
                    // The verified code is passed forward — backend needs it in Step 3
                    code: _codeCtrl.text.trim(),
                  ),
                ),
              ),
            );

            // Reset state so back-navigation doesn't retrigger this listener
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearMessage());
          }
        },

        builder: (ctx, state) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                // OTP code input — numeric keyboard
                AppTextField(
                  label: l10n.forgotPassword_codeLabel, // ✅ "Code"
                  controller: _codeCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _verify(),
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return l10n.forgotPassword_fieldRequired;     // ✅
                    if (val.length < 4) return l10n.forgotPassword_enterAllDigits; // ✅
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Verify button — spinner while waiting for API response
                PrimaryButton(
                  label: l10n.forgotPassword_verify, // ✅ "Verify"
                  isLoading: state.isLoading,
                  onPressed: _verify,
                ),
                const SizedBox(height: 10),

                // Resend button — disabled while a request is in flight
                TextButton(
                  onPressed: state.isLoading ? null : _resend,
                  child: Text(l10n.forgotPassword_resendCode), // ✅ "Resend code"
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}}