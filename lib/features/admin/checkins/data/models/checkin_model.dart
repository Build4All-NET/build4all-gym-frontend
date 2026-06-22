// =============================================================================
// FILE: checkin_model.dart
// PATH: lib/features/admin/checkins/data/models/checkin_model.dart
// LAYER: Data Layer → Models
//
// PURPOSE:
//   Parses one item from the `checkins` array in the backend response.
//   Maps raw JSON → CheckinModel, then converts to the domain Checkin entity.
//
// BACKEND SHAPE (from CheckinCardDto):
//   {
//     "checkinId":      1,
//     "userId":         42,
//     "fullName":       "Rajesh Kumar",
//     "avatarInitials": "RK",
//     "checkinTime":    "07:50",
//     "status":         "ACTIVE",
//     "phone":          "+91..."
//   }
// =============================================================================

import '../../domain/entities/checkin.dart';

class CheckinModel {
  final int    checkinId;
  final int    userId;
  final String fullName;
  final String avatarInitials;
  final String checkinTime;
  final String status;
  final String phone;
  final String? entryType;

  const CheckinModel({
    required this.checkinId,
    required this.userId,
    required this.fullName,
    required this.avatarInitials,
    required this.checkinTime,
    required this.status,
    required this.phone,
    this.entryType,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      checkinId:      (json['checkinId'] as num).toInt(),
      userId:         (json['userId']    as num).toInt(),
      fullName:       json['fullName']       as String? ?? '',
      avatarInitials: json['avatarInitials'] as String? ?? '?',
      checkinTime:    json['checkinTime']    as String? ?? '',
      status:         json['status']         as String? ?? 'ACTIVE',
      phone:          json['phone']          as String? ?? '',
      entryType:      json['entryType']      as String?,
    );
  }

  /// Converts this model to the pure domain entity the BLoC works with.
  Checkin toEntity() {
    return Checkin(
      checkinId:      checkinId,
      userId:         userId,
      fullName:       fullName,
      avatarInitials: avatarInitials,
      checkinTime:    checkinTime,
      status:         status,
      phone:          phone,
      entryType:      entryType,
    );
  }
}
