import '../../domain/entities/availability_entity.dart';

class AvailabilityModel extends AvailabilityEntity {
  const AvailabilityModel({
    required super.availabilityId,
    required super.trainerId,
    required super.branchId,
    required super.weekday,
    required super.startTime,
    required super.endTime,
    required super.recurring,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      availabilityId: json['availabilityId'] as int,
      trainerId: json['trainerId'] as int,
      branchId: json['branchId'] as int,
      weekday: json['weekday'] as int,
      startTime: json['startTime'] as String, // "09:00:00"
      endTime: json['endTime'] as String,
      recurring: json['recurring'] as bool? ?? true,
    );
  }
}