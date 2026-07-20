class MemberStats {
  final int sessionsCount;
  final int workoutsCount;
  final int upcomingCount;
  final String? referralCode;

  const MemberStats({
    required this.sessionsCount,
    required this.workoutsCount,
    required this.upcomingCount,
    this.referralCode,
  });
}
