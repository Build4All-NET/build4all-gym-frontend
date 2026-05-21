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

    on<MemberProfileEditPhoneCodeSubmitted>(_onPhoneCodeSubmitted);
    on<MemberProfileEditPhoneCodeResendRequested>(_onPhoneCodeResendRequested);
  }

  /// Main save flow.
  ///
  /// Correct behavior:
  /// - Other profile fields changed only -> save directly.
  /// - Phone changed -> phone OTP, then save.
  /// - Password changed -> password OTP, then save.
  /// - Phone + password changed -> phone OTP, password OTP, then save.
  /// - Email changed -> save profile first, then email OTP.
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

      final emailChanged = newEmail.toLowerCase() != oldEmail.toLowerCase();
      final phoneChanged = newPhone.isNotEmpty && newPhone != oldPhone;

      final wantsPasswordChange =
          event.newPassword.trim().isNotEmpty && !event.passwordAlreadyUpdated;

      // 1) PHONE OTP FLOW
      //
      // Phone change does NOT require current password.
      // We send an OTP to the new phone number only.
      if (phoneChanged && !event.phoneAlreadyVerified) {
        await sendPhoneVerificationCode(
          phoneNumber: event.phoneNumber.trim(),
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        emit(
          MemberProfileEditPhoneVerificationRequired(
            newPhoneNumber: event.phoneNumber.trim(),
            ownerProjectLinkId: event.ownerProjectLinkId,
          ),
        );
        return;
      }

      // 2) PASSWORD OTP FLOW
      //
      // Password change requires:
      // - current password check
      // - password reset OTP
      // - update password after OTP
      if (wantsPasswordChange) {
        final currentPassword = event.currentPassword.trim();
        final newPassword = event.newPassword.trim();

        if (currentPassword.isEmpty) {
          emit(const MemberProfileEditError('Current password is required.'));
          return;
        }

        if (newPassword.isEmpty) {
          emit(const MemberProfileEditError('New password is required.'));
          return;
        }

        if (newPassword.length < 6) {
          emit(
            const MemberProfileEditError(
              'New password must be at least 6 characters.',
            ),
          );
          return;
        }

        if (newPassword == currentPassword) {
          emit(
            const MemberProfileEditError(
              'New password must be different from current password.',
            ),
          );
          return;
        }

        await verifyCurrentPassword(
          email: oldEmail,
          currentPassword: currentPassword,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        await sendPasswordResetCode(
          email: oldEmail,
          ownerProjectLinkId: event.ownerProjectLinkId,
        );

        emit(
          MemberProfileEditPasswordVerificationRequired(
            email: oldEmail,
            newPassword: newPassword,
            ownerProjectLinkId: event.ownerProjectLinkId,
          ),
        );
        return;
      }

      // 3) PROFILE UPDATE FLOW
      //
      // This runs only after required OTP steps are finished.
      await updateBuild4AllProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
        email: newEmail,
        phoneNumber: event.phoneNumber,
      );

      // 4) EMAIL OTP FLOW
      //
      // Build4All sends/handles email OTP after profile update.
      if (emailChanged) {
        emit(MemberProfileEditEmailVerificationRequired(newEmail: newEmail));
        return;
      }

      emit(const MemberProfileEditSuccess());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

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

  Future<void> _onPhoneCodeSubmitted(
      MemberProfileEditPhoneCodeSubmitted event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    emit(const MemberProfileEditLoading());

    try {
      await verifyPhoneCode(
        phoneNumber: event.phoneNumber,
        code: event.code,
      );

      emit(
        MemberProfileEditPhoneVerified(
          phoneNumber: event.phoneNumber,
        ),
      );
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  Future<void> _onPhoneCodeResendRequested(
      MemberProfileEditPhoneCodeResendRequested event,
      Emitter<MemberProfileEditState> emit,
      ) async {
    try {
      await sendPhoneVerificationCode(
        phoneNumber: event.phoneNumber,
        ownerProjectLinkId: event.ownerProjectLinkId,
      );

      emit(const MemberProfileEditCodeResent());
    } catch (e) {
      emit(MemberProfileEditError(_cleanError(e)));
    }
  }

  /// Normalizes phone values before comparing old/new.
  ///
  /// This prevents false phone changes caused by formatting differences:
  /// - 71312570
  /// - 071312570
  /// - +961 71 312 570
  /// - +96171312570
  String _normalizePhone(String value) {
    var v = value.trim();

    // Remove spaces, dashes, brackets, etc. Keep digits and +.
    v = v.replaceAll(RegExp(r'[^0-9+]'), '');

    // Lebanese local format: 71312570 -> +96171312570
    if (!v.startsWith('+') && v.length == 8) {
      return '+961$v';
    }

    // Lebanese local format with leading 0: 071312570 -> +96171312570
    if (!v.startsWith('+') && v.length == 9 && v.startsWith('0')) {
      return '+961${v.substring(1)}';
    }

    // International without +: 96171312570 -> +96171312570
    if (!v.startsWith('+') && v.startsWith('961')) {
      return '+$v';
    }

    return v;
  }

  String _cleanError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Failed to update profile.' : text;
  }
}