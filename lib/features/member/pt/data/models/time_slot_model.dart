import '../../domain/entities/time_slot_entity.dart';

class TimeSlotModel {
  final int? id;
  final String startTime;
  final String endTime;
  final bool available;

  const TimeSlotModel({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.available,
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
    );
  }

  TimeSlotEntity toEntity() {
    return TimeSlotEntity(
      id: id,
      startTime: startTime,
      endTime: endTime,
      available: available,
    );
  }
}