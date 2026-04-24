class MemberStatsModel {
  // Number of booked sessions shown in the UI
  final int sessionsCount;

  // Number of kilograms lost
  // This must be double because values like 8.5 are valid
  final double kgLost;

  // Number of completed workouts
  final int workoutsCount;

  // Optional referral code, may be null if backend does not send it
  final String? referralCode;

  // Creates a typed MemberStatsModel object
  const MemberStatsModel({
    required this.sessionsCount,
    required this.kgLost,
    required this.workoutsCount,
    this.referralCode,
  });

  // Converts backend JSON into a MemberStatsModel object
  factory MemberStatsModel.fromJson(Map<String, dynamic> json) {
    return MemberStatsModel(
      // Safely convert numeric value to int, fallback to 0 if null
      sessionsCount: (json['sessionsCount'] as num?)?.toInt() ?? 0,

      // Safely convert numeric value to double, fallback to 0.0 if null
      // Using num allows both int and double from backend
      kgLost: (json['kgLost'] as num?)?.toDouble() ?? 0.0,

      // Safely convert numeric value to int, fallback to 0 if null
      workoutsCount: (json['workoutsCount'] as num?)?.toInt() ?? 0,

      // Referral code is optional, so keep it nullable
      referralCode: json['referralCode']?.toString(),
    );
  }
}