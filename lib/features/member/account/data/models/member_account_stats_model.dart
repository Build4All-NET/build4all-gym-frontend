class MemberAccountStatsModel {
  final int sessionsCount;
  final int exercisesCount;

  const MemberAccountStatsModel({
    required this.sessionsCount,
    required this.exercisesCount,
  });

  factory MemberAccountStatsModel.fromJson(Map<String, dynamic> json) {
    return MemberAccountStatsModel(
      sessionsCount: json['sessionsCount'] as int,
      exercisesCount: json['exercisesCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionsCount': sessionsCount,
      'exercisesCount': exercisesCount,
    };
  }
}