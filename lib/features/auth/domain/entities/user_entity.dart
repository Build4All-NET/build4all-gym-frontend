class UserEntity {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final int ownerProjectLinkId;


  /// status text: "ACTIVE", "INACTIVE", "DELETED", ...
  final String? status;

  const UserEntity({
    required this.id,
    required this.ownerProjectLinkId,
    this.username,
    this.fullname,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.status,
  });

  /// ✅ NEW: copyWith for instant UI updates (AuthUserPatched)
  UserEntity copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    int? ownerProjectLinkId,
    bool? isPublicProfile,
    String? status,
  }) {
    return UserEntity(
      id: id,
      ownerProjectLinkId: ownerProjectLinkId ?? this.ownerProjectLinkId,
      username: username ?? this.username,
      fullname: firstName ?? this.fullname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }


  /// Optional helper: nice display name for UI
  String get displayName {
    final fullFromParts = '${firstName ?? ''} ${lastName ?? ''}'.trim();

    if (fullFromParts.isNotEmpty) return fullFromParts;
    if ((fullname ?? '').trim().isNotEmpty) return fullname!.trim();
    if ((username ?? '').trim().isNotEmpty) return username!.trim();
    if ((email ?? '').trim().isNotEmpty) return email!.trim();
    if ((phoneNumber ?? '').trim().isNotEmpty) return phoneNumber!.trim();

    return 'User #$id';
  }
}
