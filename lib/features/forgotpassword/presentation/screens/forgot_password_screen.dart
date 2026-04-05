import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';
import '../widgets/auth_card_shell.dart';
import 'verify_otp_screen.dart';

// Screen 1 — User enters their email or phone number
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();

  static const Color _primary = Color(0xFF1D9E75);

  @override
  void dispose() {
    _identifierCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(identifier: _identifierCtrl.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'Forgot Password?',
      subtitle: 'Enter your email or phone number\nand we\'ll send you a code.',
      icon: Icons.lock_reset,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          // Show error toast if something went wrong
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // When step becomes 1 → OTP was sent → go to Screen 2
          if (state.step == 1) {
            Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: ctx.read<ForgotPasswordBloc>(),
                child: VerifyOtpScreen(
                  identifier: _identifierCtrl.text.trim(),
                ),
              ),
            ));
            // Clear state so listener doesn't fire again on back navigation
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearState());
          }
        },
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
                    labelText: 'Email or Phone',
                    hintText: 'john@gmail.com or +96170123456',
                    prefixIcon: const Icon(Icons.person_outline, color: _primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty) return 'This field is required';
                    if (!val.contains('@') && val.length < 8) return 'Enter a valid email or phone';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Send OTP button
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
                        : const Text('Send OTP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Check your email or SMS for the code.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5F5E5A)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}