class MemberStats {
  final int sessionsCount;
  final double kgLost;
  final int workoutsCount;
  final String? referralCode;

  const MemberStats({
    required this.sessionsCount,
    required this.kgLost,
    required this.workoutsCount,
    this.referralCode,
  });
}