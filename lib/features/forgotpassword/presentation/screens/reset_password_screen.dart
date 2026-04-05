import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/app/app_router.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_bloc.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_event.dart';
import 'package:build4allgym/features/forgotpassword/presentation/bloc/forgot_password_state.dart';
import 'package:build4allgym/features/forgotpassword/presentation/widgets/auth_card_shell.dart';

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

  static const Color _primary = Color(0xFF1D9E75);

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
    return AuthCardShell(
      title: 'New Password',
      subtitle: 'Set a strong password with at\nleast 8 characters.',
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
            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
              content: Text('✅ Password reset! Please login with new password.'),
              backgroundColor: Color(0xFF1D9E75),
            ));

            // pushNamedAndRemoveUntil = go to login AND remove ALL screens behind
            // So pressing back from login doesn't go back to forget pass screens
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
                    labelText: 'New Password',
                    prefixIcon:
                    const Icon(Icons.lock_outline, color: _primary),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _showPass = !_showPass),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final val = v ?? '';
                    if (val.isEmpty) return 'Password is required';
                    // rules match the backend @Size and @Pattern
                    if (val.length < 8) return 'Minimum 8 characters';
                    if (!val.contains(RegExp(r'[A-Za-z]')))
                      return 'Must contain at least one letter';
                    if (!val.contains(RegExp(r'[0-9]')))
                      return 'Must contain at least one number';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Confirm password field
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: !_showConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon:
                    const Icon(Icons.lock_outline, color: _primary),
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
                      borderSide: const BorderSide(color: _primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    if ((v ?? '').isEmpty) return 'Please confirm your password';
                    if (v != _passCtrl.text) return 'Passwords do not match';
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
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                        : const Text('Save Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
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