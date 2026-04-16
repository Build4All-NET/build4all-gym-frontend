// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/screens/reset_password_screen.dart
//
// PURPOSE:
//   SCREEN 3 of the forgot-password flow.
//   The user types their new password and confirms it.
//   On success → pops the entire flow back to the login screen.
//
// DATA FLOW:
//   - [email] received from Screen 2 constructor
//   - [code]  received from Screen 2 constructor (the verified OTP)
//   - Both are forwarded to the BLoC event and ultimately to the backend
//
// RELATIONSHIPS:
//   ▶ Fires:      ForgotUpdatePasswordPressed, ForgotClearMessage
//   ▶ Listens to: ForgotPasswordState
//   ▶ Navigates to: Login (via popUntil first route)
//   ▶ Uses:       AuthCardShell, AppTextField, PrimaryButton, AppToast
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


class ForgotPasswordNewPasswordScreen extends StatefulWidget {
  // Received from Screen 2 — backend needs email + code to authorise the update
  final String email;
  final String code;

  const ForgotPasswordNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ForgotPasswordNewPasswordScreen> createState() =>
      _ForgotPasswordNewPasswordScreenState();
}

class _ForgotPasswordNewPasswordScreenState
    extends State<ForgotPasswordNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  // The new password the user wants
  final _passCtrl = TextEditingController();

  // Confirmation field — must match _passCtrl
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // Called when user taps "Save Password"
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Fire Step 3 event → BLoC._onUpdate() → UpdatePassword use case → API
    context.read<ForgotPasswordBloc>().add(
      ForgotUpdatePasswordPressed(
        email: widget.email,
        code: widget.code,     // The OTP code verified in Screen 2
        newPassword: _passCtrl.text,
        ownerProjectLinkId: int.tryParse(Env.ownerProjectLinkId) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthCardShell(
      title: l10n.forgotPassword_newPasswordTitle,       // ✅ "Set a new password"
      subtitle: l10n.forgotPassword_newPasswordSubtitle, // ✅ "Make it strong..."
      icon: Icons.password_outlined,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          // API failed → show error toast
          if (state.error != null) {
            AppToast.error(ctx, ExceptionMapper.toMessage(state.error!));
          }

          // API succeeded → show success toast → pop ALL screens back to login
          if (state.successMessage != null) {
            AppToast.success(ctx, state.successMessage!);

            // popUntil(first route) removes Screen 3, Screen 2, Screen 1
            // and lands the user back at the login screen
            Navigator.of(ctx).popUntil((r) => r.isFirst);

            // Clean up state (flow is complete but keeps BLoC tidy for reuse)
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearMessage());
          }
        },

        builder: (ctx, state) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                // New password — hidden by default, toggle with eye icon
                AppTextField(
                  label: l10n.forgotPassword_newPassword, // ✅ "New password"
                  controller: _passCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next, // moves focus to confirm field
                  validator: (v) {
                    final val = v ?? '';
                    if (val.isEmpty) return l10n.forgotPassword_fieldRequired;  // ✅
                    if (val.length < 6) return l10n.validation_passwordTooShort; // ✅
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Confirm password — cross-field validation against _passCtrl
                AppTextField(
                  label: l10n.forgotPassword_confirmPassword, // ✅ "Confirm password"
                  controller: _confirmCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if ((v ?? '').isEmpty) return l10n.forgotPassword_fieldRequired;   // ✅
                    if (v != _passCtrl.text) return l10n.validation_passwordsMismatch; // ✅
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save button — spinner while API call is in flight
                PrimaryButton(
                  label: l10n.forgotPassword_savePassword, // ✅ "Save password"
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}