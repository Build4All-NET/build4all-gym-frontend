class GymProfileEntity {
  final int    userId;
  final String gymRole;
  final String fullName;
  final List<String> gymRoles;

  const GymProfileEntity({
    required this.userId,
    required this.gymRole,
    required this.fullName,
    this.gymRoles = const [],
  });

  bool get isTrainer   => gymRoles.contains('TRAINER');
  bool get isReception => gymRoles.contains('RECEPTION');
  bool get isMember    => gymRoles.isEmpty;
  bool get hasMultipleRoles => gymRoles.length > 1;

  static const empty = GymProfileEntity(
    userId:   0,
    gymRole:  'MEMBER',
    fullName: '',
    gymRoles: [],
  );

  @override
  String toString() =>
      'GymProfileEntity(userId: $userId, gymRole: $gymRole, gymRoles: $gymRoles, fullName: $fullName)';
}
