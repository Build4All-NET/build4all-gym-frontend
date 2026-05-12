class MemberBuild4AllProfileModel {
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

  const MemberBuild4AllProfileModel({
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

  factory MemberBuild4AllProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberBuild4AllProfileModel(
      id: _asInt(json['id'] ?? json['userId']),
      firstName: _asString(json['firstName']),
      lastName: _asString(json['lastName']),
      username: _asString(json['username']),
      email: _asString(json['email']),
      phoneNumber: _asString(json['phoneNumber'] ?? json['phone']),
      profileImageUrl: _asString(json['profileImageUrl'] ?? json['avatarUrl']),
      publicProfile: json['publicProfile'] is bool
          ? json['publicProfile'] as bool
          : null,
      status: _asString(json['status']),
      pendingEmail: _asString(json['pendingEmail']),
      emailVerificationRequired: json['emailVerificationRequired'] == true,
    );
  }

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final full = '$first $last'.trim();

    if (full.isNotEmpty) return full;

    final fallbackUsername = username?.trim() ?? '';
    if (fallbackUsername.isNotEmpty) return fallbackUsername;

    return 'Member';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'publicProfile': publicProfile,
      'status': status,
      'pendingEmail': pendingEmail,
      'emailVerificationRequired': emailVerificationRequired,
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String? _asString(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}