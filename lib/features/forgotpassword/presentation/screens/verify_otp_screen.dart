import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';
import '../widgets/auth_card_shell.dart';
import 'reset_password_screen.dart';

// Screen 2 — User enters the 6-digit OTP + can resend
class VerifyOtpScreen extends StatefulWidget {
  final String identifier; // email or phone passed from Screen 1

  const VerifyOtpScreen({super.key, required this.identifier});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpCtrl =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  static const Color _primary = Color(0xFF1D9E75);

  // Countdown timer — 15 minutes = 900 seconds
  int _secondsLeft = 900;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 900);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
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

  // Returns the full 6-digit OTP string
  String get _otpCode => _otpCtrl.map((c) => c.text).join();

  // Formats 900 seconds as "15:00"
  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _verify() {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter all 6 digits'),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    context.read<ForgotPasswordBloc>().add(ForgotVerifyOtpPressed(
      identifier: widget.identifier,
      otpCode: _otpCode,
    ));
  }

  // Resend = just call forgot-password again with same identifier
  // Your backend already handles this — invalidates old OTP, sends new one
  void _resend() {
    for (final c in _otpCtrl) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();
    context.read<ForgotPasswordBloc>().add(
      ForgotSendCodePressed(identifier: widget.identifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'Enter OTP',
      subtitle: 'We sent a 6-digit code to\n${widget.identifier}',
      icon: Icons.mark_email_read_outlined,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (ctx, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ));
          }

          // When step becomes 2 → OTP verified → go to Screen 3
          if (state.step == 2 && state.resetToken != null) {
            Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: ctx.read<ForgotPasswordBloc>(),
                child: ResetPasswordScreen(
                  resetToken: state.resetToken!, // pass UUID to Screen 3
                ),
              ),
            ));
            ctx.read<ForgotPasswordBloc>().add(const ForgotClearState());
          }
        },
        builder: (ctx, state) {
          return Column(
            children: [

              // Show masked contact from state if available
              if (state.maskedContact != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Check ${state.deliveryMethod == "EMAIL" ? "your email" : "your SMS"}: ${state.maskedContact}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _primary, fontWeight: FontWeight.w600),
                  ),
                ),

              // 6 OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => SizedBox(
                  width: 44,
                  child: TextFormField(
                    controller: _otpCtrl[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _primary, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      // Auto-jump to next box when a digit is typed
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

              // Timer
              Text(
                _secondsLeft > 0 ? 'Code expires in $_timerText' : 'Code expired',
                style: TextStyle(
                  color: _secondsLeft > 0 ? const Color(0xFF5F5E5A) : Colors.red,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Verify Code', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 14),

              // Resend button — calls /auth/forgot-password again!
              TextButton(
                onPressed: state.isLoading ? null : _resend,
                child: const Text(
                  'Didn\'t receive a code? Resend',
                  style: TextStyle(color: _primary),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}