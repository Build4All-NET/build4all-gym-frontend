import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_bloc.dart';
import 'package:build4allgym/features/member/account/presentation/bloc/member_account_event.dart';

import 'package:build4allgym/features/member/build4all_profile/domain/entities/member_build4all_profile_entity.dart';
import 'package:build4allgym/features/member/build4all_profile/presentation/bloc/member_build4all_profile_bloc.dart';
import 'package:build4allgym/features/member/build4all_profile/presentation/bloc/member_build4all_profile_event.dart';

import 'package:build4allgym/features/member/profile_edit/data/repositories/member_profile_edit_repository_impl.dart';
import 'package:build4allgym/features/member/profile_edit/data/services/member_profile_edit_service.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/resend_email_change_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/send_profile_password_reset_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/send_profile_phone_verification_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_build4all_profile_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_profile_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_current_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_email_change_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_profile_phone_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/presentation/bloc/member_profile_edit_bloc.dart';
import 'package:build4allgym/features/member/profile_edit/presentation/bloc/member_profile_edit_event.dart';
import 'package:build4allgym/features/member/profile_edit/presentation/bloc/member_profile_edit_state.dart';
import 'package:build4allgym/features/member/profile_edit/presentation/widgets/member_profile_edit_otp_dialog.dart';

bool _isArabic(BuildContext context) {
  return Localizations.localeOf(context)
      .languageCode
      .toLowerCase()
      .startsWith('ar');
}

class MemberEditProfileScreen extends StatelessWidget {
  final MemberAccountEntity account;
  final MemberBuild4AllProfileEntity profile;

  const MemberEditProfileScreen({
    super.key,
    required this.account,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final repository = MemberProfileEditRepositoryImpl(
      MemberProfileEditService(),
    );

    return BlocProvider<MemberProfileEditBloc>(
      create: (_) => MemberProfileEditBloc(
        updateBuild4AllProfile: UpdateBuild4AllProfileUseCase(repository),
        verifyEmailChange: VerifyEmailChangeUseCase(repository),
        resendEmailChangeCode: ResendEmailChangeCodeUseCase(repository),
        verifyCurrentPassword: VerifyCurrentPasswordUseCase(repository),
        sendPasswordResetCode: SendProfilePasswordResetCodeUseCase(repository),
        updatePassword: UpdateProfilePasswordUseCase(repository),
        sendPhoneVerificationCode:
        SendProfilePhoneVerificationCodeUseCase(repository),
        verifyPhoneCode: VerifyProfilePhoneCodeUseCase(repository),
      ),
      child: _MemberEditProfileView(
        profile: profile,
      ),
    );
  }
}

class _MemberEditProfileView extends StatefulWidget {
  final MemberBuild4AllProfileEntity profile;

  const _MemberEditProfileView({
    required this.profile,
  });

  @override
  State<_MemberEditProfileView> createState() => _MemberEditProfileViewState();
}

class _MemberEditProfileViewState extends State<_MemberEditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;

  String _phoneCompleteNumber = '';

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;

  static final RegExp _nameAllowedChars = RegExp(
    r"[A-Za-zÀ-ÖØ-öø-ÿĀ-žḀ-ỿ\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s]",
  );

  static final RegExp _nameFullRegex = RegExp(
    r"^[A-Za-zÀ-ÖØ-öø-ÿĀ-žḀ-ỿ\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s]+$",
  );

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.profile.firstName ?? '',
    );

    _lastNameController = TextEditingController(
      text: widget.profile.lastName ?? '',
    );

    _usernameController = TextEditingController(
      text: widget.profile.username ?? '',
    );

    _emailController = TextEditingController(
      text: widget.profile.email ?? '',
    );

    _phoneCompleteNumber = widget.profile.phoneNumber?.trim() ?? '';

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<MemberProfileEditBloc, MemberProfileEditState>(
      listener: _onProfileEditState,
      builder: (context, state) {
        final loading = state is MemberProfileEditLoading;

        return Scaffold(
          backgroundColor: tokens.colors.background,
          body: SafeArea(
            child: Column(
              children: [
                _EditHeader(
                  title: l10n.editProfileTitle,
                  subtitle: l10n.editProfileSubtitle,
                  onBack: loading ? null : () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(tokens.spacing.lg),
                    child: Container(
                      padding: EdgeInsets.all(tokens.spacing.lg),
                      decoration: BoxDecoration(
                        color: tokens.colors.surface,
                        borderRadius: BorderRadius.circular(tokens.card.radius),
                        border: Border.all(
                          color: tokens.colors.border.withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: tokens.colors.label.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: isArabic
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _EditField(
                                    label: l10n.editProfileFirstName,
                                    controller: _firstNameController,
                                    icon: Icons.person_outline_rounded,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        _nameAllowedChars,
                                      ),
                                    ],
                                    validator: (value) => _validateName(
                                      value,
                                      l10n,
                                    ),
                                  ),
                                ),
                                SizedBox(width: tokens.spacing.md),
                                Expanded(
                                  child: _EditField(
                                    label: l10n.editProfileLastName,
                                    controller: _lastNameController,
                                    icon: Icons.person_outline_rounded,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        _nameAllowedChars,
                                      ),
                                    ],
                                    validator: (value) => _validateName(
                                      value,
                                      l10n,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: tokens.spacing.md),
                            _EditField(
                              label: l10n.editProfileUsername,
                              controller: _usernameController,
                              icon: Icons.alternate_email_rounded,
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) {
                                  return l10n.editProfileUsernameRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: tokens.spacing.md),
                            _EditField(
                              label: l10n.editProfileEmail,
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => _validateEmail(
                                value,
                                l10n,
                              ),
                            ),
                            SizedBox(height: tokens.spacing.md),
                            _PhoneField(
                              label: l10n.editProfilePhone,
                              requiredMessage: l10n.editProfilePhoneRequired,
                              initialPhoneNumber: widget.profile.phoneNumber,
                              onChanged: (completeNumber) {
                                _phoneCompleteNumber = completeNumber.trim();
                              },
                            ),
                            SizedBox(height: tokens.spacing.xl),
                            _SectionTitle(
                              text: l10n.editProfileChangePassword,
                            ),
                            SizedBox(height: tokens.spacing.md),
                            _EditField(
                              label: l10n.editProfileCurrentPassword,
                              controller: _currentPasswordController,
                              icon: Icons.lock_outline_rounded,
                              obscureText: _hideCurrentPassword,
                              suffixIcon: IconButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                  setState(() {
                                    _hideCurrentPassword =
                                    !_hideCurrentPassword;
                                  });
                                },
                                icon: Icon(
                                  _hideCurrentPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            SizedBox(height: tokens.spacing.md),
                            _EditField(
                              label: l10n.editProfileNewPassword,
                              controller: _newPasswordController,
                              icon: Icons.lock_reset_rounded,
                              obscureText: _hideNewPassword,
                              suffixIcon: IconButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                  setState(() {
                                    _hideNewPassword = !_hideNewPassword;
                                  });
                                },
                                icon: Icon(
                                  _hideNewPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              validator: (value) {
                                final newPassword = value?.trim() ?? '';

                                // If the user did not type a new password,
                                // do not validate password change.
                                //
                                // Important:
                                // Current password can be used for phone verification,
                                // so it must NOT force new password to be required.
                                if (newPassword.isEmpty) {
                                  return null;
                                }

                                final currentPassword = _currentPasswordController.text.trim();

                                if (currentPassword.isEmpty) {
                                  return l10n.editProfileCurrentPasswordRequired;
                                }

                                if (newPassword.length < 6) {
                                  return l10n.editProfilePasswordTooShort;
                                }

                                if (newPassword == currentPassword) {
                                  return l10n.editProfilePasswordSameAsCurrent;
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: tokens.spacing.xl),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: tokens.button.height,
                                    child: ElevatedButton(
                                      onPressed: loading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: tokens.colors.primary,
                                        foregroundColor:
                                        tokens.colors.onPrimary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            tokens.button.radius,
                                          ),
                                        ),
                                      ),
                                      child: loading
                                          ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: tokens.colors.onPrimary,
                                        ),
                                      )
                                          : Text(
                                        l10n.editProfileSave,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: tokens.spacing.md),
                                Expanded(
                                  child: SizedBox(
                                    height: tokens.button.height,
                                    child: OutlinedButton(
                                      onPressed: loading
                                          ? null
                                          : () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: tokens.colors.label,
                                        side: BorderSide(
                                          color: tokens.colors.border
                                              .withOpacity(0.4),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            tokens.button.radius,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.editProfileCancel,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onProfileEditState(
      BuildContext context,
      MemberProfileEditState state,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    if (state is MemberProfileEditError) {
      _showSnack(context, state.message, isError: true);
      return;
    }

    if (state is MemberProfileEditSuccess) {
      _refreshAccountAndClose(context);
      return;
    }

    if (state is MemberProfileEditPhoneVerificationRequired) {
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => MemberProfileEditOtpDialog(
          title: 'Verify phone number',
          sentToLabel: l10n.editProfileCodeSentTo,
          destination: state.newPhoneNumber,
          codeLabel: l10n.editProfileVerificationCode,
          resendLabel: l10n.editProfileResend,
          verifyLabel: l10n.editProfileVerify,
          codeRequiredMessage: l10n.editProfileCodeRequired,
          onVerify: (code) async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.verifyPhoneChangeCode(
              phoneNumber: state.newPhoneNumber,
              code: code,
            );
          },
          onResend: () async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.sendPhoneChangeVerificationCode(
              phoneNumber: state.newPhoneNumber,
              password: _currentPasswordController.text,
              ownerProjectLinkId: state.ownerProjectLinkId,
            );
          },
        ),
      );

      if (ok == true && mounted) {
        _submit(phoneAlreadyVerified: true);
      }

      return;
    }

    if (state is MemberProfileEditEmailVerificationRequired) {
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => MemberProfileEditOtpDialog(
          title: l10n.editProfileVerifyNewEmail,
          sentToLabel: l10n.editProfileCodeSentTo,
          destination: state.newEmail,
          codeLabel: l10n.editProfileVerificationCode,
          resendLabel: l10n.editProfileResend,
          verifyLabel: l10n.editProfileVerify,
          codeRequiredMessage: l10n.editProfileCodeRequired,
          onVerify: (code) async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.verifyEmailChange(code: code);
          },
          onResend: () async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.resendEmailChangeCode();
          },
        ),
      );

      if (ok == true && mounted) {
        _refreshAccountAndClose(context);
      }

      return;
    }

    if (state is MemberProfileEditPasswordVerificationRequired) {
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => MemberProfileEditOtpDialog(
          title: l10n.editProfileVerifyPasswordChange,
          sentToLabel: l10n.editProfileCodeSentTo,
          destination: state.email,
          codeLabel: l10n.editProfileVerificationCode,
          resendLabel: l10n.editProfileResend,
          verifyLabel: l10n.editProfileVerify,
          codeRequiredMessage: l10n.editProfileCodeRequired,
          onVerify: (code) async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.updatePassword(
              email: state.email,
              code: code,
              newPassword: state.newPassword,
              ownerProjectLinkId: state.ownerProjectLinkId,
            );
          },
          onResend: () async {
            final repository = MemberProfileEditRepositoryImpl(
              MemberProfileEditService(),
            );

            await repository.sendPasswordResetCode(
              email: state.email,
              ownerProjectLinkId: state.ownerProjectLinkId,
            );
          },
        ),
      );

      if (ok == true && mounted) {
        _refreshAccountAndClose(context);
      }

      return;
    }

    if (state is MemberProfileEditEmailVerified) {
      _showSnack(context, l10n.editProfileEmailVerified);
      return;
    }

    if (state is MemberProfileEditPhoneVerified) {
      _showSnack(context, 'Phone verified successfully');
      return;
    }

    if (state is MemberProfileEditPasswordUpdated) {
      _showSnack(context, l10n.editProfilePasswordUpdated);
      return;
    }

    if (state is MemberProfileEditCodeResent) {
      _showSnack(context, state.message);
      return;
    }
  }

  void _refreshAccountAndClose(BuildContext context) {
    context.read<MemberAccountBloc>().add(const MemberAccountStarted());

    context
        .read<MemberBuild4AllProfileBloc>()
        .add(const MemberBuild4AllProfileRefreshRequested());

    Navigator.pop(context);
  }
  String _normalizePhone(String? raw) {
    var value = (raw ?? '').trim();

    if (value.isEmpty) return '';

    value = value
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('.', '');

    if (value.startsWith('00')) {
      value = '+${value.substring(2)}';
    }

    if (value.startsWith('+9610')) {
      value = '+961${value.substring(5)}';
    }

    if (RegExp(r'^0(3|70|71|76|78|79|81)\d{6}$').hasMatch(value)) {
      value = '+961${value.substring(1)}';
    }

    if (!value.startsWith('+')) {
      if (RegExp(r'^(3|70|71|76|78|79|81)\d{6}$').hasMatch(value)) {
        value = '+961$value';
      }
    }

    return value;
  }
  void _submit({
    bool phoneAlreadyVerified = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final ownerProjectLinkId = int.tryParse(Env.ownerProjectLinkId) ?? 0;

    if (ownerProjectLinkId <= 0) {
      _showSnack(
        context,
        l10n.editProfileInvalidOwnerProject,
        isError: true,
      );
      return;
    }

    if (_phoneCompleteNumber.trim().isEmpty) {
      _showSnack(
        context,
        l10n.editProfilePhoneRequired,
        isError: true,
      );
      return;
    }
    final oldPhone = _normalizePhone(widget.profile.phoneNumber);
    final newPhone = _normalizePhone(_phoneCompleteNumber);

    final phoneChanged = oldPhone != newPhone;
    final currentPasswordFilled =
        _currentPasswordController.text.trim().isNotEmpty;
    final newPasswordFilled =
        _newPasswordController.text.trim().isNotEmpty;

// Current password alone is not a valid action.
// It is only used when changing phone or changing password.
    if (currentPasswordFilled && !newPasswordFilled && !phoneChanged) {
      _showSnack(
        context,
        l10n.editProfileNewPasswordRequired,
        isError: true,
      );
      return;
    }

    context.read<MemberProfileEditBloc>().add(
      MemberProfileEditSubmitted(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneCompleteNumber.trim(),
        dateOfBirth: null,
        address: null,
        currentEmail: widget.profile.email ?? '',
        currentPhoneNumber: widget.profile.phoneNumber ?? '',
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text.trim(),
        ownerProjectLinkId: ownerProjectLinkId,
        phoneAlreadyVerified: phoneAlreadyVerified,
      ),
    );
  }

  String? _validateName(
      String? value,
      AppLocalizations l10n,
      ) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return l10n.editProfileRequired;

    if (!_nameFullRegex.hasMatch(v)) {
      return l10n.editProfileOnlyLetters;
    }

    return null;
  }

  String? _validateEmail(
      String? value,
      AppLocalizations l10n,
      ) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return l10n.editProfileEmailRequired;

    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

    if (!ok) return l10n.editProfileInvalidEmail;

    return null;
  }

  void _showSnack(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? tokens.colors.danger : tokens.colors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const _EditHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        tokens.spacing.lg,
        tokens.spacing.lg,
        tokens.spacing.lg,
        tokens.spacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isArabic ? Alignment.topRight : Alignment.topLeft,
          end: isArabic ? Alignment.bottomLeft : Alignment.bottomRight,
          colors: [
            tokens.colors.primary,
            tokens.colors.success,
          ],
        ),
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(28),
          bottomEnd: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(
              isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
              color: tokens.colors.onPrimary,
              size: 24,
            ),
          ),
          SizedBox(height: tokens.spacing.lg),
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: tokens.typography.headlineSmall.copyWith(
                color: tokens.colors.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: tokens.spacing.xs),
          SizedBox(
            width: double.infinity,
            child: Text(
              subtitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.onPrimary.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: tokens.typography.bodyMedium.copyWith(
            color: tokens.colors.label,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: tokens.typography.bodySmall.copyWith(
            color: tokens.colors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final String label;
  final String requiredMessage;
  final String? initialPhoneNumber;
  final ValueChanged<String> onChanged;

  const _PhoneField({
    required this.label,
    required this.requiredMessage,
    required this.initialPhoneNumber,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);

    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        SizedBox(height: tokens.spacing.xs),
        IntlPhoneField(
          initialCountryCode: _guessInitialCountryCode(initialPhoneNumber),
          initialValue: _stripKnownDialCode(initialPhoneNumber),
          keyboardType: TextInputType.phone,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            filled: true,
            fillColor: tokens.colors.background,
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide(
                color: tokens.colors.primary,
                width: tokens.search.borderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide(
                color: tokens.colors.danger,
                width: tokens.search.borderWidth,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.md,
              vertical: tokens.spacing.md,
            ),
          ),
          validator: (phone) {
            final complete = phone?.completeNumber.trim() ?? '';
            if (complete.isEmpty) return requiredMessage;
            return null;
          },
          onChanged: (phone) {
            onChanged(phone.completeNumber);
          },
        ),
      ],
    );
  }

  static String _guessInitialCountryCode(String? phone) {
    final v = phone?.trim() ?? '';

    if (v.startsWith('+961')) return 'LB';
    if (v.startsWith('+33')) return 'FR';
    if (v.startsWith('+1')) return 'US';
    if (v.startsWith('+44')) return 'GB';
    if (v.startsWith('+971')) return 'AE';

    return 'LB';
  }

  static String? _stripKnownDialCode(String? phone) {
    final v = phone?.trim();
    if (v == null || v.isEmpty) return null;

    if (v.startsWith('+961')) return v.substring(4);
    if (v.startsWith('+33')) return v.substring(3);
    if (v.startsWith('+1')) return v.substring(2);
    if (v.startsWith('+44')) return v.substring(3);
    if (v.startsWith('+971')) return v.substring(4);

    return v;
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;

  const _EditField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isArabic = _isArabic(context);

    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        SizedBox(height: tokens.spacing.xs),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            filled: true,
            fillColor: tokens.colors.background,
            prefixIcon: Icon(
              icon,
              color: tokens.colors.muted,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide(
                color: tokens.colors.primary,
                width: tokens.search.borderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.search.radius),
              borderSide: BorderSide(
                color: tokens.colors.danger,
                width: tokens.search.borderWidth,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.md,
              vertical: tokens.spacing.md,
            ),
          ),
        ),
      ],
    );
  }
}