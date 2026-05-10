class MemberBuild4AllProfileEntity {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool? publicProfile;
  final String? status;
  final String? pendingEmail;
  final bool emailVerificationRequired;

  const MemberBuild4AllProfileEntity({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.publicProfile,
    this.status,
    this.pendingEmail,
    this.emailVerificationRequired = false,
  });

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final full = '$first $last'.trim();

    if (full.isNotEmpty) return full;

    final fallbackUsername = username?.trim() ?? '';
    if (fallbackUsername.isNotEmpty) return fallbackUsername;

    return 'Member';
  }
}