class ScheduleItem {
  final String type;
  final String title;
  final String trainerName;
  final String startTime;
  final int durationMinutes;
  final String? roomName;
  final String status;

  const ScheduleItem({
    required this.type,
    required this.title,
    required this.trainerName,
    required this.startTime,
    required this.durationMinutes,
    this.roomName,
    required this.status,
  });
}