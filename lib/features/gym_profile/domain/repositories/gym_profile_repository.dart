// FILE: lib/features/gym_profile/domain/repositories/gym_profile_repository.dart
//
// LAYER: Domain — Repository (abstract contract)
//
// PURPOSE:
//   The domain layer's contract for fetching the gym profile.
//   The use case depends on this abstraction — never on the impl.
//   This is the Dependency Inversion Principle: high-level policy
//   (use case) depends on an abstraction, not a concrete HTTP class.
//
// IMPLEMENTED BY:
//   data/repositories/gym_profile_repository_impl.dart

import '../entities/gym_profile_entity.dart';

abstract class GymProfileRepository {
  /// Returns the effective gym role for the currently logged-in user.
  ///
  /// MEMBER   → no row in gym_user_roles (default)
  /// TRAINER  → promoted by an admin
  /// RECEPTION → promoted by an admin
  Future<GymProfileEntity> getGymProfile();
}