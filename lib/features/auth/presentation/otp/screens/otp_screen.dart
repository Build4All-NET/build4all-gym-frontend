import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/signup_response.dart';
import '../../../data/models/verify_signup_request.dart';
import '../../../data/services/auth_service.dart';
import '../../../../../app/app_router.dart';
import '../../../../../theme/theme_cubit.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    if (value == null || value.trim().isEmpty) return 'Code is required';
    if (value.trim().length < 4) return 'Enter a valid code';
    return null;
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = VerifySignupRequest(
        email: widget.email,
        code: _codeController.text.trim(),
      );

      final SignupResponse response = await _authService.verifySignup(request);

      if (response.token != null && response.token!.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.token!);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message.isNotEmpty
                ? response.message
                : 'OTP verified successfully',
          ),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final tokens = themeState.tokens;
    final c = tokens.colors;
    final s = tokens.spacing;
    final t = tokens.typography;
    final b = tokens.button;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: s.xl, vertical: s.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.lock_outline, size: 70, color: c.primary),
                  SizedBox(height: s.lg),
                  Text(
                    'Verify Your Account',
                    textAlign: TextAlign.center,
                    style: t.headlineSmall,
                  ),
                  SizedBox(height: s.sm),
                  Text(
                    'Enter the verification code sent to:\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: t.bodyMedium,
                  ),
                  SizedBox(height: s.xl),

                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Verification Code',
                      hintText: 'Enter OTP code',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                    validator: _validateCode,
                  ),
                  SizedBox(height: s.xl),

                  SizedBox(
                    height: b.height,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Text(
                              'Verify',
                              style: t.titleMedium.copyWith(color: c.onPrimary),
                            ),
                    ),
                  ),
                  SizedBox(height: s.sm),

                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Back',
                      style: t.bodyMedium.copyWith(color: c.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}