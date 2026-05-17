class TimeSlotEntity {
  final int? id;
  final String startTime;
  final String endTime;

  // Backend says if the member can book this slot directly.
  final bool available;

  // Number of confirmed members already booked in this slot.
  final int bookedCount;

  // Maximum number of members allowed in this slot.
  final int maxMembers;

  const TimeSlotEntity({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.available,
    this.bookedCount = 0,
    this.maxMembers = 1,
  });

  // True when the slot reached the trainer capacity.
  //
  // Example:
  // bookedCount = 3
  // maxMembers = 3
  // full = true
  bool get full => maxMembers > 0 && bookedCount >= maxMembers;

  // Used by the UI to show capacity.
  //
  // Example:
  // 0/3
  // 1/3
  // 2/3
  // 3/3
  String get capacityLabel => '$bookedCount/$maxMembers';

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