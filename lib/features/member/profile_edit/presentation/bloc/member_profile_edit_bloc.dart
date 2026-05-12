import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/features/member/profile_edit/domain/usecases/resend_email_change_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/send_profile_password_reset_code_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_build4all_profile_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/update_profile_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_current_password_usecase.dart';
import 'package:build4allgym/features/member/profile_edit/domain/usecases/verify_email_change_usecase.dart';

import 'member_profile_edit_event.dart';
import 'member_profile_edit_state.dart';

/// Bloc responsible for the Build4All part of Edit Profile.
///
/// It does NOT update Gym backend fields directly.
/// Gym-only fields such as dateOfBirth/address stay handled by MemberAccountBloc.
///
/// Responsibilities here:
/// - Update Build4All profile: firstName, lastName, username, email, phoneNumber.
/// - Trigger email verification state when email changes.
/// - Verify email OTP.
/// - Check current password before password change.
/// - Send password reset code.
/// - Update password through Build4All reset/update-password flow.
class MemberProfileEditBloc
    extends Bloc<MemberProfileEditEvent, MemberProfileEditState> {
  final UpdateBuild4AllProfileUseCase updateBuild4AllProfile;
  final VerifyEmailChangeUseCase verifyEmailChange;
  final ResendEmailChangeCodeUseCase resendEmailChangeCode;
  final VerifyCurrentPasswordUseCase verifyCurrentPassword;
  final SendProfilePasswordResetCodeUseCase sendPasswordResetCode;
  final UpdateProfilePasswordUseCase updatePassword;

  MemberProfileEditBloc({
    required this.updateBuild4AllProfile,
    required this.verifyEmailChange,
    required this.resendEmailChangeCode,
    required this.verifyCurrentPassword,
    required this.sendPasswordResetCode,
    required this.updatePassword,
  }) : super(const MemberProfileEditInitial()) {
    on<MemberProfileEditSubmitted>(_onSubmitted);
    on<MemberProfileEditEmailCodeSubmitted>(_onEmailCodeSubmitted);
    on<MemberProfileEditEmailCodeResendRequested>(_onEmailCodeResendRequested);
    on<MemberProfileEditPasswordCodeSubmitted>(_onPasswordCodeSubmitted);
    on<MemberProfileEditPasswordCodeResendRequested>(
      _onPasswordCodeResendRequested,
    );
  }

  /// Handles the main Save button.
  ///
  /// Flow:
  /// 1. Validate/update Build4All profile fields.
  /// 2. If password fields are filled:
  ///    - check current password using Build4All login
  ///    - send reset code
  ///    - ask UI to open OTP dialog
  /// 3. If email changed:
  ///    - Build4All profile update should trigger email OTP
  ///    - ask UI to open OTP dialog
  /// 4. Otherwise emit success.
  Future<void> _onSubmitted(
      MemberProfileEditSubmitted event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    emit(const MemberProfileEditLoading());

    try {
      final oldEmail = event.currentEmail.trim();
      final newEmail = event.email.trim();

      final wantsPasswordChange = event.newPassword.trim().isNotEmpty;

      // Build4All profile update:
      // firstName, lastName, username, email, phoneNumber.
      //
      // If email changed, Build4All should mark it pending and send OTP.
      await updateBuild4AllProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
        email: newEmail,
        phoneNumber: event.phoneNumber,
      );

      // Password change is handled through the reset-code/update-password flow.
      // We first verify the current password using the Build4All login endpoint.
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

      // If the user changed email, Build4All should have sent a verification code.
      // The UI opens the same e-commerce-style OTP dialog.
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

  /// Verifies the password reset code and saves the new password in Build4All.
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

  /// Converts raw exceptions into user-readable messages.
  String _cleanError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Failed to update profile.' : text;
  }
}