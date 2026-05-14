// FILE: lib/features/gym_profile/domain/usecases/get_gym_profile_usecase.dart
//
// LAYER: Domain — Use Case
//
// PURPOSE:
//   Single-responsibility: delegates to the repository and returns the entity.
//   The cubit calls this — never the repository directly.
//   Keeps the cubit decoupled from HTTP and injection details.
//
// POSITION IN FLOW:
//   GymProfileCubit (fetchProfile event)
//     → [this file] GetGymProfileUseCase.call()
//     → GymProfileRepository.getGymProfile()   ← abstract
//     ← GymProfileRepositoryImpl does HTTP + model.toEntity()
//     ← GymProfileEntity returned to cubit

import '../entities/gym_profile_entity.dart';
import '../repositories/gym_profile_repository.dart';

class GetGymProfileUseCase {
  final GymProfileRepository _repository;

  const GetGymProfileUseCase(this._repository);

  /// Call with `await useCase()` — no parameters needed.
  /// The JWT injected by AuthedHttpClient carries the user identity.
  Future<GymProfileEntity> call() => _repository.getGymProfile();
}