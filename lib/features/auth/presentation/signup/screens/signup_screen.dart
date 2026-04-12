import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_bloc.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_event.dart';
import 'package:build4allgym/features/auth/presentation/signup/bloc/register_state.dart';
import 'package:build4allgym/features/auth/domain/usecases/send_verification_code.dart';
import 'package:build4allgym/features/auth/data/repository/auth_repository_impl.dart';
import 'package:build4allgym/features/auth/data/services/auth_api_service.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'otp_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        // ✅ Create dependencies manually
        final tokenStore = const AuthTokenStore();
        final apiService = AuthApiService(
          client: http.Client(),
          tokenStore: tokenStore,
        );
        final repository = AuthRepositoryImpl(apiService);
        final sendVerificationCode = SendVerificationCode(repository);

        return RegisterBloc(sendVerificationCode: sendVerificationCode);
      },
      child: const _SignupScreenContent(),
    );
  }
}

class _SignupScreenContent extends StatefulWidget {
  const _SignupScreenContent();

  @override
  State<_SignupScreenContent> createState() => _SignupScreenContentState();
}

class _SignupScreenContentState extends State<_SignupScreenContent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Validators ─────────────────────────────────────────────────────────────

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Enter a valid full name';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length < 7) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ─── Submit ─────────────────────────────────────────────────────────────────

  void _signup() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    context.read<RegisterBloc>().add(
      RegisterSendCodeSubmitted(
        method: RegisterMethod.email,
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final s = tokens.spacing;
    final t = tokens.typography;
    final b = tokens.button;
    final l = AppLocalizations.of(context)!;

    final inputFillColor = c.surface;
    final inputBorderColor = c.border.withOpacity(0.3);
    final hintColor = c.muted;
    final labelColor = c.label.withOpacity(0.7);

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (ctx, state) {
        if (state.codeSent && state.contact != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Verification code sent to ${state.contact}'),
              backgroundColor: c.success,
            ),
          );

          // ✅ Pass the SAME bloc instance to OTP screen
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: ctx.read<RegisterBloc>(),
                child: OtpScreen(
                  contact: state.contact!,
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                  password: passwordController.text,
                ),
              ),
            ),
          );
        }

        if (state.errorCode != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(_resolveError(state.errorCode, l)),
              backgroundColor: c.error,
            ),
          );
        }

        if (state.resumeCompleteProfile && state.resumePendingId != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: const Text('Account already verified. Please complete your profile.'),
              backgroundColor: c.success,
            ),
          );
          // TODO: Navigate to complete profile
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up', style: TextStyle(color: c.label)),
          centerTitle: true,
          backgroundColor: c.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: c.label),
        ),
        backgroundColor: c.background,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: s.xl, vertical: s.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (ctx, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.person_add_alt_1, size: 70, color: c.primary),
                      SizedBox(height: s.lg),
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: t.headlineSmall.copyWith(color: c.label),
                      ),
                      SizedBox(height: s.xs),
                      Text(
                        'Join us and start your fitness journey',
                        textAlign: TextAlign.center,
                        style: t.bodyMedium.copyWith(color: c.body),
                      ),
                      SizedBox(height: s.xl),

                      // Full Name
                      Text('Full Name', style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: s.xs),
                      TextFormField(
                        controller: fullNameController,
                        style: TextStyle(color: c.label, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: hintColor, fontSize: 14),
                          filled: true,
                          fillColor: inputFillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.error)),
                          prefixIcon: Icon(Icons.person_outline, color: hintColor, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: _validateFullName,
                      ),
                      SizedBox(height: s.md),

                      // Email
                      Text('Email', style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: s.xs),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: c.label, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: hintColor, fontSize: 14),
                          filled: true,
                          fillColor: inputFillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.error)),
                          prefixIcon: Icon(Icons.email_outlined, color: hintColor, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: s.md),

                      // Phone (Optional)
                      Text('Phone Number (Optional)', style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: s.xs),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: c.label, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(color: hintColor, fontSize: 14),
                          filled: true,
                          fillColor: inputFillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.error)),
                          prefixIcon: Icon(Icons.phone_outlined, color: hintColor, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: _validatePhone,
                      ),
                      SizedBox(height: s.md),

                      // Password
                      Text('Password', style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: s.xs),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: c.label, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: hintColor, fontSize: 14),
                          filled: true,
                          fillColor: inputFillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.error)),
                          prefixIcon: Icon(Icons.lock_outline, color: hintColor, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: hintColor, size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: _validatePassword,
                      ),
                      SizedBox(height: s.md),

                      // Confirm Password
                      Text('Confirm Password', style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: s.xs),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: TextStyle(color: c.label, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          hintStyle: TextStyle(color: hintColor, fontSize: 14),
                          filled: true,
                          fillColor: inputFillColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: inputBorderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.primary, width: 1.5)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(b.radius), borderSide: BorderSide(color: c.error)),
                          prefixIcon: Icon(Icons.lock_outline, color: hintColor, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: hintColor, size: 20),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      SizedBox(height: s.xl),

                      // Sign Up Button
                      SizedBox(
                        height: b.height,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: c.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(b.radius)),
                            disabledBackgroundColor: c.muted.withOpacity(0.3),
                          ),
                          child: state.isLoading
                              ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: c.onPrimary))
                              : Text('Sign Up', style: TextStyle(fontSize: b.textSize, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(height: s.md),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?', style: TextStyle(color: c.body, fontSize: 14)),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: state.isLoading ? null : () => Navigator.pop(context),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: Text('Login', style: TextStyle(color: c.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveError(String? code, AppLocalizations l) {
    switch (code) {
      case 'EMAIL_ALREADY_EXISTS': return 'Email already exists';
      case 'PHONE_ALREADY_EXISTS': return 'Phone number already exists';
      case 'WEAK_PASSWORD': return 'Password is too weak';
      case 'INVALID_EMAIL_FORMAT': return 'Invalid email format';
      case 'NETWORK_ERROR':
      case 'NO_INTERNET': return 'No internet connection';
      case 'TIMEOUT': return 'Request timed out';
      case 'SERVER_ERROR': return 'Server error. Please try again.';
      default: return 'Something went wrong. Please try again.';
    }
  }
}