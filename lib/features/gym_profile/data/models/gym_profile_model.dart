// FILE: lib/features/gym_profile/data/models/gym_profile_model.dart
//
// LAYER: Data — Model
//
// PURPOSE:
//   Knows how to deserialize the JSON response from GET /api/gym/me.
//   Converts itself into the domain entity via toEntity().
//   The domain layer never touches this class directly.
//
// JSON SHAPE (matches backend GymProfileDto):
//   {
//     "userId":   42,
//     "gymRole":  "TRAINER",   ← "TRAINER" | "RECEPTION" | "MEMBER"
//     "fullName": "John Doe"
//   }

import '../../domain/entities/gym_profile_entity.dart';

class GymProfileModel {
  final int    userId;
  final String gymRole;
  final String fullName;

  const GymProfileModel({
    required this.userId,
    required this.gymRole,
    required this.fullName,
  });

  // ── JSON deserialization ───────────────────────────────────────────────────

  factory GymProfileModel.fromJson(Map<String, dynamic> json) =>
      GymProfileModel(
        userId:   (json['userId']   as num?)?.toInt() ?? 0,
        gymRole:  (json['gymRole']  as String?)        ?? 'MEMBER',
        fullName: (json['fullName'] as String?)        ?? '',
      );

  // ── Model → Entity ─────────────────────────────────────────────────────────
  // Called by GymProfileRepositoryImpl before returning to the use case.

  GymProfileEntity toEntity() => GymProfileEntity(
    userId:   userId,
    gymRole:  gymRole,
    fullName: fullName,
  );
}