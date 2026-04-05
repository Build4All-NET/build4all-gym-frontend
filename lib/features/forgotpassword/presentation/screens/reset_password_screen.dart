import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';
import '../widgets/auth_card_shell.dart';

// Screen 3 — User types and confirms their new password
class ResetPasswordScreen extends StatefulWidget {
  final String resetToken; // UUID from step 2, sent to backend in step 3

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Send resetToken (from step 2) + new password to backend
    context.read<ForgotPasswordBloc>().add(ForgotResetPasswordPressed(
      resetToken: widget.resetToken,
      newPassword: _passCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'New Password',
      subtitle: 'Set a strong password\nwith at least 8 characters.',
      icon: Icons.password_outlined,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // When step becomes 3 → password reset → go all the way back to login!
          if (state.step == 3) {
            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
              content: Text('✅ Password reset successfully! Please login.'),
              backgroundColor: Color(0xFF1D9E75),
            ));
            // popUntil(first) = removes all screens and goes back to login
            Navigator.of(ctx).popUntil((route) => route.isFirst);
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearState());
          }
        },
        builder: (ctx, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [

                // New password field
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: _primary),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final val = v ?? '';
                    if (val.isEmpty) return 'Password is required';
                    // Must be 8+ chars with letter + number (matches your backend @Pattern)
                    if (val.length < 8) return 'Minimum 8 characters';
                    if (!val.contains(RegExp(r'[A-Za-z]'))) return 'Must contain at least one letter';
                    if (!val.contains(RegExp(r'[0-9]'))) return 'Must contain at least one number';
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
                    prefixIcon: const Icon(Icons.lock_outline, color: _primary),
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showConfirm = !_showConfirm),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text('Save Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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