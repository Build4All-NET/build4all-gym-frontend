class GymReceptionEntity {
  final int     userId;
  final String  fullName;
  final String  phone;
  final String  email;
  final int?    profileFileId;
  final String  assignedAt;

  const GymReceptionEntity({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profileFileId,
    required this.assignedAt,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }
}
