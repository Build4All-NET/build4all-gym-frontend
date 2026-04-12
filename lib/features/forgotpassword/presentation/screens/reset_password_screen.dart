import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/app/app_router.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_event.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_state.dart';
import 'package:build4allgym/features/forgotpassword/presentation/widgets/auth_card_shell.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

// SCREEN 3 — New Password
// Purpose: user types and confirms their new password
// Sends resetToken (from Screen 2) + new password to backend
// On success → navigates to LOGIN using AppRouter
class ResetPasswordScreen extends StatefulWidget {
  final String resetToken; // UUID from Step 2

  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // Called when user taps "Save Password"
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Send the UUID (from Step 2) + new password to backend
    context.read<ForgotPasswordBloc>().add(ForgotResetPasswordPressed(
      resetToken: widget.resetToken, // UUID stored from Step 2
      newPassword: _passCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // LOCALIZATION: every user-visible string comes from here.
    // Switching device language to Arabic automatically uses AppLocalizationsAr.
    final l10n = AppLocalizations.of(context)!;

    // THEME: brand primary color
    final primary = Theme.of(context).colorScheme.primary;

    return AuthCardShell(
      // LOCALIZED:  'New Password'
      title: l10n.forgotPassword_newPasswordScreenTitle,
      // LOCALIZED:  'Set a strong password with at\nleast 8 characters.'
      subtitle: l10n.forgotPassword_newPasswordScreenSubtitle,
      icon: Icons.password_outlined,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // Step became 3 → password reset → go back to login!
          // use AppRouter
          if (state.step == 3) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              // LOCALIZED:  hardcoded ' Password reset! Please login with new password.'
              content: Text(l10n.forgotPassword_passwordResetSuccess),
              // THEMED:  hardcoded Color(0xFF1D9E75)
              backgroundColor: primary,
            ));

            // pushNamedAndRemoveUntil = go to login AND remove ALL screens behind
            // So pressing back from login doesn't go back to forgot-pass screens
            Navigator.of(ctx).pushNamedAndRemoveUntil(
              AppRouter.login,
                  (route) => false, // remove everything
            );

            ctx.read<ForgotPasswordBloc>().add(const ForgotClearState());
          }
        },
        builder: (ctx, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [

                // New password field with show/hide toggle
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                    // LOCALIZED:  'New Password'
                    labelText: l10n.forgotPassword_newPassword,
                    // THEMED
                    prefixIcon: Icon(Icons.lock_outline, color: primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () =>
                          setState(() => _showPass = !_showPass),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // THEMED
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final val = v ?? '';
                    // LOCALIZED: 'Password is required'
                    if (val.isEmpty) return l10n.validation_passwordRequired;
                    // rules match the backend @Size and @Pattern
                    // LOCALIZED:  'Minimum 8 characters'
                    if (val.length < 8) return l10n.validation_passwordTooShort;
                    // LOCALIZED:  'Must contain at least one letter'
                    if (!val.contains(RegExp(r'[A-Za-z]')))
                      return l10n.validation_passwordNoLetter;
                    //  LOCALIZED:  'Must contain at least one number'
                    if (!val.contains(RegExp(r'[0-9]')))
                      return l10n.validation_passwordNoNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Confirm password field
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: !_showConfirm,
                  decoration: InputDecoration(
                    //  LOCALIZED: 'Confirm Password'
                    labelText: l10n.forgotPassword_confirmPassword,
                    // THEMED
                    prefixIcon: Icon(Icons.lock_outline, color: primary),
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      //THEMED
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    // LOCALIZED: 'Please confirm your password'
                    if ((v ?? '').isEmpty)
                      return l10n.validation_confirmPasswordRequired;
                    // LOCALIZED:  'Passwords do not match'
                    if (v != _passCtrl.text)
                      return l10n.validation_passwordsMismatch;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Save button
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
                      // LOCALIZED: 'Save Password'
                      l10n.forgotPassword_savePassword,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}