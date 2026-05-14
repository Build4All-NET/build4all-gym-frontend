// FILE: lib/features/gym_profile/domain/entities/gym_profile_entity.dart
//
// LAYER: Domain — Entity
//
// PURPOSE:
//   Pure Dart object. Knows nothing about JSON, HTTP, or Flutter UI.
//   This is what the BLoC, use cases, and UI widgets work with.
//
// HOW IT FITS:
//   Backend JSON → GymProfileModel (data) → .toEntity() → GymProfileEntity (domain)
//                                                                ↓
//                                                     GetGymProfileUseCase
//                                                                ↓
//                                                     GymProfileCubit
//                                                                ↓
//                                                     RoleCheckScreen

class GymProfileEntity {
  final int    userId;
  final String gymRole;   // "TRAINER" | "RECEPTION" | "MEMBER"
  final String fullName;

  const GymProfileEntity({
    required this.userId,
    required this.gymRole,
    required this.fullName,
  });

  // ── Role helpers ───────────────────────────────────────────────────────────
  // The screen uses these instead of comparing raw strings.

  bool get isTrainer   => gymRole == 'TRAINER';
  bool get isReception => gymRole == 'RECEPTION';
  bool get isMember    => gymRole == 'MEMBER';

  // ── Safe fallback ──────────────────────────────────────────────────────────
  // Used when the network call fails — we don't block the user, just show member.

  static const empty = GymProfileEntity(
    userId:   0,
    gymRole:  'MEMBER',
    fullName: '',
  );

  @override
  String toString() =>
      'GymProfileEntity(userId: $userId, gymRole: $gymRole, fullName: $fullName)';
}