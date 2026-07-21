class MemberStatsModel {
  // Number of booked services shown in the UI
  final int sessionsCount;

  // Number of completed workouts
  final int workoutsCount;

  // Number of upcoming (not-yet-completed) booked classes and PT sessions
  final int upcomingCount;

  // Optional referral code, may be null if backend does not send it
  final String? referralCode;

  // Creates a typed MemberStatsModel object
  const MemberStatsModel({
    required this.sessionsCount,
    required this.workoutsCount,
    required this.upcomingCount,
    this.referralCode,
  });

  // Converts backend JSON into a MemberStatsModel object
  factory MemberStatsModel.fromJson(Map<String, dynamic> json) {
    return MemberStatsModel(
      // Safely convert numeric value to int, fallback to 0 if null
      sessionsCount: (json['sessionsCount'] as num?)?.toInt() ?? 0,

      // Safely convert numeric value to int, fallback to 0 if null
      workoutsCount: (json['workoutsCount'] as num?)?.toInt() ?? 0,

      // Safely convert numeric value to int, fallback to 0 if null
      upcomingCount: (json['upcomingCount'] as num?)?.toInt() ?? 0,

      // Referral code is optional, so keep it nullable
      referralCode: json['referralCode']?.toString(),
    );
  }
}
