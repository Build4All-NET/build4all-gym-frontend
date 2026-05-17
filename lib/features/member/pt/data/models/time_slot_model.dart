import '../../domain/entities/time_slot_entity.dart';

class TimeSlotModel {
  final int? id;
  final String startTime;
  final String endTime;
  final bool available;

  // Number of confirmed members already booked in this slot.
  final int bookedCount;

  // Maximum members allowed in this slot.
  final int maxMembers;

  const TimeSlotModel({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.available,
    this.bookedCount = 0,
    this.maxMembers = 1,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      // Backend TimeSlotDto.id
      id: (json['id'] as num?)?.toInt(),

      // Backend LocalDateTime usually comes as:
      // "2026-05-08T09:00:00"
      startTime: json['startTime'] as String? ??
          json['start_time'] as String? ??
          '',

      endTime: json['endTime'] as String? ??
          json['end_time'] as String? ??
          '',

      // Java boolean isAvailable usually serializes as "available".
      available: json['available'] as bool? ??
          json['isAvailable'] as bool? ??
          true,

      // New backend value:
      // how many accepted/confirmed members already booked this slot.
      bookedCount: (json['bookedCount'] as num?)?.toInt() ?? 0,

      // New backend value:
      // maximum members allowed in this slot.
      // Default is 1 for old backend responses.
      maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 1,
    );
  }

  TimeSlotEntity toEntity() {
    return TimeSlotEntity(
      id: id,
      startTime: startTime,
      endTime: endTime,
      available: available,
      bookedCount: bookedCount,
      maxMembers: maxMembers,
    );
  }
}