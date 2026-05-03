
// ─────────────────────────────────────────────────────────────────────────────
// trainer_availability_model.dart
// ─────────────────────────────────────────────────────────────────────────────
class TrainerAvailabilityModel {
  final int    weekday;    // 1=Mon … 7=Sun
  final String startTime;  // "06:00"
  final String endTime;    // "14:00"

  const TrainerAvailabilityModel({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  factory TrainerAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      TrainerAvailabilityModel(
        weekday:   json['weekday']   as int,
        startTime: json['startTime'] as String,
        endTime:   json['endTime']   as String,
      );

  Map<String, dynamic> toJson() => {
    'weekday':   weekday,
    'startTime': startTime,
    'endTime':   endTime,
  };
}
