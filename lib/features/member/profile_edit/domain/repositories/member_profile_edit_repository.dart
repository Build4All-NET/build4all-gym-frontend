abstract class MemberProfileEditRepository {
  Future<void> updateBuild4AllProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  });

  Future<void> verifyEmailChange({
    required String code,
  });

  Future<void> resendEmailChangeCode();

  Future<void> verifyCurrentPassword({
    required String email,
    required String currentPassword,
    required int ownerProjectLinkId,
  });

  Future<void> sendPasswordResetCode({
    required String email,
    required int ownerProjectLinkId,
  });

  Future<void> updatePassword({
    required String email,
    required String code,
    required String newPassword,
    required int ownerProjectLinkId,
  });

  Future<void> sendPhoneChangeVerificationCode({
    required String phoneNumber,
    required String password,
    required int ownerProjectLinkId,
  });
  Future<void> verifyPhoneChangeCode({
    required String phoneNumber,
    required String code,
  });
}