import '../../domain/entities/pt_booking_response_entity.dart';

/// API response model for PT booking creation.
///
/// This file is responsible for:
/// - reading backend JSON
/// - handling missing/null fields safely
/// - converting to domain entity
class PtBookingResponseModel {
  final int ptSessionId;
  final int trainerId;
  final int userId;
  final int? branchId;
  final String startTime;
  final String endTime;
  final String status;
  final String? notes;
  final String? createdAt;
  final String? trainerName;
  final String? trainerPhotoUrl;

  const PtBookingResponseModel({
    required this.ptSessionId,
    required this.trainerId,
    required this.userId,
    this.branchId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes,
    this.createdAt,
    this.trainerName,
    this.trainerPhotoUrl,
  });

  /// Creates a model from backend JSON.
  ///
  /// The `(json['x'] as num?)?.toInt() ?? 0` pattern prevents crashes if:
  /// - the field is missing
  /// - the field is null
  /// - the backend sends int/double number type
  factory PtBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return PtBookingResponseModel(
      ptSessionId: (json['ptSessionId'] as num?)?.toInt() ?? 0,
      trainerId: (json['trainerId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      branchId: (json['branchId'] as num?)?.toInt(),
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String?,
      trainerName: json['trainerName'] as String?,
      trainerPhotoUrl: json['trainerPhotoUrl'] as String?,
    );
  }

  /// Converts data-layer model into domain-layer entity.
  PtBookingResponseEntity toEntity() {
    return PtBookingResponseEntity(
      ptSessionId: ptSessionId,
      trainerId: trainerId,
      userId: userId,
      branchId: branchId,
      startTime: startTime,
      endTime: endTime,
      status: status,
      notes: notes,
      createdAt: createdAt,
      trainerName: trainerName,
      trainerPhotoUrl: trainerPhotoUrl,
    );
  }
}