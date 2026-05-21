import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/features/member/profile_edit/domain/usecases/resend_email_change_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/send_profile_password_reset_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/send_profile_phone_verification_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_build4all_profile_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_profile_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_current_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_email_change_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_profile_phone_code_usecase.dart';

import 'member_profile_edit_event.dart';
import 'member_profile_edit_state.dart';

/// Bloc responsible for the Build4All part of Edit Profile.
///
/// Important flow:
/// - Normal profile fields update directly.
/// - Email change still uses email OTP.
/// - Password change still uses current-password check + password OTP.
/// - Phone change uses:
///   1. current password check
///   2. send phone OTP
///   3. verify phone OTP in dialog
///   4. resubmit profile update with phoneAlreadyVerified = true
class MemberProfileEditBloc
    extends Bloc<MemberProfileEditEvent, MemberProfileEditState> {
  final UpdateBuild4AllProfileUseCase updateBuild4AllProfile;
  final VerifyEmailChangeUseCase verifyEmailChange;
  final ResendEmailChangeCodeUseCase resendEmailChangeCode;
  final VerifyCurrentPasswordUseCase verifyCurrentPassword;
  final SendProfilePasswordResetCodeUseCase sendPasswordResetCode;
  final UpdateProfilePasswordUseCase updatePassword;

  final SendProfilePhoneVerificationCodeUseCase sendPhoneVerificationCode;
  final VerifyProfilePhoneCodeUseCase verifyPhoneCode;

  MemberProfileEditBloc({
    required this.updateBuild4AllProfile,
    required this.verifyEmailChange,
    required this.resendEmailChangeCode,
    required this.verifyCurrentPassword,
    required this.sendPasswordResetCode,
    required this.updatePassword,
    required this.sendPhoneVerificationCode,
    required this.verifyPhoneCode,
  }) : super(const MemberProfileEditInitial()) {
    on<MemberProfileEditSubmitted>(_onSubmitted);
    on<MemberProfileEditEmailCodeSubmitted>(_onEmailCodeSubmitted);
    on<MemberProfileEditEmailCodeResendRequested>(_onEmailCodeResendRequested);
    on<MemberProfileEditPasswordCodeSubmitted>(_onPasswordCodeSubmitted);
    on<MemberProfileEditPasswordCodeResendRequested>(
      _onPasswordCodeResendRequested,
    );
  }

  /// Main Save button flow.
  ///
  /// Phone update rule:
  /// If the phone number changed, we do NOT update the profile immediately.
  /// First:
  /// - current password must be entered
  /// - current password must be correct
  /// - phone OTP is sent to the new number
  /// - UI opens OTP dialog
  ///
  /// After OTP is verified, the screen submits again with:
  /// phoneAlreadyVerified = true
  ///
  /// Only then we call updateBuild4AllProfile() and actually save the phone.
  Future<void> _onSubmitted(
      MemberProfileEditSubmitted event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    emit(const MemberProfileEditLoading());

    try {
      final oldEmail = event.currentEmail.trim();
      final newEmail = event.email.trim();

      final oldPhone = _normalizePhone(event.currentPhoneNumber);
      final newPhone = _normalizePhone(event.phoneNumber);
      final phoneChanged = oldPhone != newPhone;

      final wantsPasswordChange = event.newPassword.trim().isNotEmpty;

      // ---------------------------------------------------------------------
      // PHONE CHANGE SECURITY FLOW
      // ---------------------------------------------------------------------
      //
      // If phone changed and OTP was not already verified:
      // 1. Require current password.
      // 2. Verify current password using the same login-based check.
      // 3. Send OTP to the new phone number.
      // 4. Stop here and ask UI to open the OTP dialog.
      //
      // We do this BEFORE updateBuild4AllProfile()
      // because the phone must not be saved before OTP verification.
      // ---------------------------------------------------------------------
      if (phoneChanged && !event.phoneAlreadyVerified) {
        if (newPhone.isEmpty) {
          emit(const MemberProfileEditError('Phone number is required.'));
          return;
        }

        if (event.currentPassword.trim().isEmpty) {
          emit(
            const MemberProfileEditError(
              'Current password is required to change phone number.',
            ),
          );
          return;
        }

        await verifyCurrentPassword(
          email: oldEmail,
          currentPassword: event.currentPassword,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        await sendPhoneVerificationCode(
          phoneNumber: newPhone,
          password: event.currentPassword,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        emit(
          MemberProfileEditPhoneVerificationRequired(
            newPhoneNumber: newPhone,
            ownerProjectLinkId: event.ownerProjectLinkId,
          ),
        );
        return;
      }

      // ---------------------------------------------------------------------
      // PROFILE UPDATE
      // ---------------------------------------------------------------------
      //
      // Runs immediately when phone did not change.
      // Runs after OTP verification when phone changed.
      // ---------------------------------------------------------------------
      await updateBuild4AllProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
        email: newEmail,
        phoneNumber: newPhone,
      );

      // ---------------------------------------------------------------------
      // PASSWORD CHANGE FLOW
      // ---------------------------------------------------------------------
      //
      // Password is still protected by:
      // - current password check
      // - OTP sent to email
      // - OTP dialog
      // ---------------------------------------------------------------------
      if (wantsPasswordChange) {
        if (event.currentPassword.trim().isEmpty) {
          emit(const MemberProfileEditError('Current password is required.'));
          return;
        }

        if (event.newPassword.trim().isEmpty) {
          emit(const MemberProfileEditError('New password is required.'));
          return;
        }

        if (event.newPassword.trim().length < 6) {
          emit(
            const MemberProfileEditError(
              'New password must be at least 6 characters.',
            ),
          );
          return;
        }

        if (event.newPassword.trim() == event.currentPassword.trim()) {
          emit(
            const MemberProfileEditError(
              'New password must be different from current password.',
            ),
          );
          return;
        }

        await verifyCurrentPassword(
          email: oldEmail,
          currentPassword: event.currentPassword,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        await sendPasswordResetCode(
          email: oldEmail,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        emit(
          MemberProfileEditPasswordVerificationRequired(
            email: oldEmail,
            newPassword: event.newPassword.trim(),
            ownerProjectLinkId: event.ownerProjectLinkId,
          ),
        );
        return;
      }

      // ---------------------------------------------------------------------
      // EMAIL CHANGE FLOW
      // ---------------------------------------------------------------------
      //
      // Build4All profile update should trigger email verification.
      // UI opens OTP dialog after this state.
      // ---------------------------------------------------------------------
      if (newEmail.toLowerCase() != oldEmail.toLowerCase()) {
        emit(MemberProfileEditEmailVerificationRequired(newEmail: newEmail));
        return;
      }

      emit(const MemberProfileEditSuccess());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Verifies the email change OTP through Build4All.
  Future<void> _onEmailCodeSubmitted(
      MemberProfileEditEmailCodeSubmitted event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    emit(const MemberProfileEditLoading());

    try {
      await verifyEmailChange(code: event.code);
      emit(const MemberProfileEditEmailVerified());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Resends the email change OTP through Build4All.
  Future<void> _onEmailCodeResendRequested(
      MemberProfileEditEmailCodeResendRequested event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    try {
      await resendEmailChangeCode();
      emit(const MemberProfileEditCodeResent());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Verifies the password reset code and saves the new password.
  Future<void> _onPasswordCodeSubmitted(
      MemberProfileEditPasswordCodeSubmitted event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    emit(const MemberProfileEditLoading());

    try {
      await updatePassword(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
        ownerProjectLinkId: event.ownerProjectLinkId,
      );

      emit(const MemberProfileEditPasswordUpdated());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Resends the password reset code.
  Future<void> _onPasswordCodeResendRequested(
      MemberProfileEditPasswordCodeResendRequested event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    try {
      await sendPasswordResetCode(
        email: event.email,
        ownerProjectLinkId: event.ownerProjectLinkId,
      );

      emit(const MemberProfileEditCodeResent());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Normalizes phone numbers so we compare actual values, not formatting.
  ///
  /// Examples:
  /// - "03 123 456" becomes "+9613123456"
  /// - "03123456" becomes "+9613123456"
  /// - "+961 3 123 456" becomes "+9613123456"
  /// - "00961 3 123 456" becomes "+9613123456"
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

    // Remove duplicated Lebanese leading zero:
    // +96103123456 -> +9613123456
    if (value.startsWith('+9610')) {
      value = '+961${value.substring(5)}';
    }

    // Local Lebanese mobile:
    // 03123456 -> +9613123456
    if (RegExp(r'^0(3|70|71|76|78|79|81)\d{6}$').hasMatch(value)) {
      value = '+961${value.substring(1)}';
    }

    // Local Lebanese mobile without 0:
    // 3123456 / 71123456 -> +961...
    if (!value.startsWith('+')) {
      if (RegExp(r'^(3)\d{6}$').hasMatch(value)) {
        value = '+961$value';
      } else if (RegExp(r'^(70|71|76|78|79|81)\d{6}$').hasMatch(value)) {
        value = '+961$value';
      }
    }

    return value;
  }

  /// Converts raw exceptions into user-readable messages.
  String _cleanError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Failed to update profile.' : text;
  }
}