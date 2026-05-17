// FILE: lib/features/gym_profile/presentation/cubit/gym_profile_state.dart
//
// LAYER: Presentation — Cubit States

import '../../domain/entities/gym_profile_entity.dart';

abstract class GymProfileState {}

/// Before fetchProfile() is called.
class GymProfileInitial extends GymProfileState {}

/// Waiting for GET /api/gym/me — show a loading spinner.
class GymProfileLoading extends GymProfileState {}

/// Profile fetched — route based on entity.gymRole.
class GymProfileLoaded extends GymProfileState {
  final GymProfileEntity entity;
  GymProfileLoaded(this.entity);
}

/// Unexpected error — the repo already handles network failures by returning
/// GymProfileEntity.empty, so this state is only emitted for truly unexpected
/// exceptions (e.g. null pointer, parse failure).
class GymProfileError extends GymProfileState {
  final String message;
  GymProfileError(this.message);
}