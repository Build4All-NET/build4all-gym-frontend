
class AvailabilityEntity {
  final int availabilityId;
  final int trainerId;
  final int branchId;
  final int weekday;    // 1=Monday … 7=Sunday
  final String startTime; // "HH:mm:ss"
  final String endTime;
  final bool recurring;

  const AvailabilityEntity({
    required this.availabilityId,
    required this.trainerId,
    required this.branchId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.recurring,
  });

  // Convert ISO weekday (1–7) to display name
  String get dayName => const {
    1: 'Monday', 2: 'Tuesday', 3: 'Wednesday',
    4: 'Thursday', 5: 'Friday', 6: 'Saturday', 7: 'Sunday',
  }[weekday]!;

  // Trim seconds: "09:00:00" → "09:00"
  String get startDisplay => startTime.substring(0, 5);
  String get endDisplay => endTime.substring(0, 5);
}