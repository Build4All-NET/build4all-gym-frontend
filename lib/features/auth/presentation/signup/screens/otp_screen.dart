import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/data/repository/auth_repository_impl.dart';
import 'package:build4allgym/features/auth/domain/usecases/verify_email_code.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_event.dart';
import 'package:build4allgym/app/app_router.dart';

class OtpScreen extends StatefulWidget {
  final String contact;
  final String email;
  final String? phone;
  final String password;

  const OtpScreen({
    super.key,
    required this.contact,
    required this.email,
    this.phone,
    required this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final int _codeLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _getCode() {
    final buffer = StringBuffer();
    for (final c in _controllers) {
      buffer.write(c.text);
    }
    return buffer.toString();
  }

  void _onBoxChanged(String value, int index) {
    if (value.length == 1 && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _onVerifyPressed() async {
    final code = _getCode().trim();

    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid code'),
          backgroundColor: context.read<ThemeCubit>().state.tokens.colors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final repo = context.read<AuthRepositoryImpl>();

    try {
      final usecase = VerifyEmailCode(repo);
      final result = await usecase(email: widget.email, code: code);

      final pendingId = result.fold(
            (failure) {
          if (!mounted) return -1;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: context.read<ThemeCubit>().state.tokens.colors.error,
            ),
          );
          throw failure;
        },
            (id) => id,
      );

      if (!mounted) return;

      // TODO: Navigate to CompleteProfile screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => CompleteProfileScreen(pendingId: pendingId),
      //   ),
      // );

      // For now, navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification successful! Pending ID: $pendingId'),
          backgroundColor: context.read<ThemeCubit>().state.tokens.colors.success,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
            (route) => false,
      );
    } catch (e) {
      // Error already shown
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final s = tokens.spacing;
    final t = tokens.typography;
    final b = tokens.button;
    final card = tokens.card;

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification', style: TextStyle(color: c.label)),
        centerTitle: true,
        backgroundColor: c.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: c.label),
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: s.xl, vertical: s.lg),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(card.padding),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(card.radius),
                border: card.showBorder
                    ? Border.all(color: c.border.withOpacity(0.15))
                    : null,
                boxShadow: card.showShadow
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: card.elevation * 2,
                    offset: Offset(0, card.elevation * 0.6),
                  ),
                ]
                    : null,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: c.primary.withOpacity(0.1),
                      child: Icon(Icons.lock_outline, color: c.primary, size: 30),
                    ),
                    SizedBox(height: s.md),
                    Text(
                      'Verify Your Account',
                      style: t.headlineSmall.copyWith(
                        color: c.label,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: s.xs),
                    Text(
                      'Enter the verification code sent to:',
                      style: t.bodyMedium.copyWith(color: c.body),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: s.xs / 2),
                    Text(
                      widget.contact,
                      style: t.bodyMedium.copyWith(
                        color: c.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: s.xl),

                    // OTP Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_codeLength, (index) {
                        return SizedBox(
                          width: 44,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            style: t.headlineSmall?.copyWith(
                              color: c.label,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              filled: true,
                              fillColor: c.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: c.border.withOpacity(0.4)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: c.border.withOpacity(0.4)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: c.primary, width: 1.6),
                              ),
                            ),
                            onChanged: (value) => _onBoxChanged(value, index),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: s.xl),

                    // Verify Button
                    SizedBox(
                      height: b.height,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onVerifyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: c.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(b.radius),
                          ),
                          disabledBackgroundColor: c.muted.withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: c.onPrimary,
                          ),
                        )
                            : Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: b.textSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: s.sm),

                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Back',
                        style: TextStyle(color: c.primary, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}