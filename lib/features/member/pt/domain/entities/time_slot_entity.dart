class TimeSlotEntity {
  final int? id;
  final String startTime;
  final String endTime;
  final bool available;

  const TimeSlotEntity({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.available,
  });

  String get label {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);

    if (end.isEmpty) {
      return start;
    }

    return '$start - $end';
  }

  static String _formatTime(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    final parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return value;
    }

    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}