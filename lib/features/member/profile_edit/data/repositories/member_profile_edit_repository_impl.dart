import 'package:build4allgym/features/member/profile_edit/domain/repositories/member_profile_edit_repository.dart';

import '../services/member_profile_edit_service.dart';

class MemberProfileEditRepositoryImpl implements MemberProfileEditRepository {
  final MemberProfileEditService _service;

  MemberProfileEditRepositoryImpl(this._service);

  @override
  Future<void> updateBuild4AllProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) {
    return _service.updateBuild4AllProfile(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> verifyEmailChange({
    required String code,
  }) {
    return _service.verifyEmailChange(code: code);
  }

  @override
  Future<void> resendEmailChangeCode() {
    return _service.resendEmailChangeCode();
  }

  // PASSWORD STEP 1:
  // Check current password before sending password OTP.
  @override
  Future<void> verifyCurrentPassword({
    required String email,
    required String currentPassword,
    required int ownerProjectLinkId,
  }) {
    return _service.verifyCurrentPassword(
      email: email,
      currentPassword: currentPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }

  // PASSWORD STEP 2:
  // Send password OTP/reset code.
  @override
  Future<void> sendPasswordResetCode({
    required String email,
    required int ownerProjectLinkId,
  }) {
    return _service.sendPasswordResetCode(
      email: email,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }

  // PASSWORD STEP 3:
  // Update password after OTP verification.
  @override
  Future<void> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  }) {
    return _service.updatePassword(
      email: email,
      code: code,
      newPassword: newPassword,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }

  // PHONE STEP 1:
  // Send OTP to the new phone number.

  @override
  Future<void> sendPhoneChangeVerificationCode({
    required String phoneNumber,
    required int ownerProjectLinkId,
  }) {
    return _service.sendPhoneChangeVerificationCode(
      phoneNumber: phoneNumber,
      ownerProjectLinkId: ownerProjectLinkId,
    );
  }

  // PHONE STEP 2:
  // Verify OTP sent to the new phone number.
  @override
  Future<void> verifyPhoneChangeCode({
    required String phoneNumber,
    required String code,
  }) {
    return _service.verifyPhoneChangeCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }

  String readError(Object error, String fallback) {
    return _service.readError(error, fallback);
  }
}