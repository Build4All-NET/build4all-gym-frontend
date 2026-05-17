// FILE: lib/features/gym_profile/data/repositories/gym_profile_repository_impl.dart
//
// LAYER: Data — Repository Implementation
//
// PURPOSE:
//   Implements the abstract GymProfileRepository from the domain layer.
//   Responsibilities:
//     1. Call the service (HTTP layer)
//     2. Convert GymProfileModel → GymProfileEntity via toEntity()
//     3. Catch any HTTP/network exceptions and handle gracefully:
//        - On failure, returns GymProfileEntity.empty (MEMBER role)
//        so the user is never blocked from entering the app.
//
// WHY CONVERT MODEL → ENTITY HERE?
//   The domain layer must not know about JSON or HTTP.
//   All conversion happens in this impl, keeping the domain clean.

import '../../domain/entities/gym_profile_entity.dart';
import '../../domain/repositories/gym_profile_repository.dart';
import '../services/gym_profile_service.dart';

class GymProfileRepositoryImpl implements GymProfileRepository {
  final GymProfileService _service;

  const GymProfileRepositoryImpl(this._service);

  @override
  Future<GymProfileEntity> getGymProfile() async {
    try {
      final model = await _service.fetchGymProfile();
      return model.toEntity();
    } catch (_) {
      // Network error, 401, 500, etc. → safe default to MEMBER.
      // The user still enters the app — worst case they see the member shell.
      return GymProfileEntity.empty;
    }
  }
}