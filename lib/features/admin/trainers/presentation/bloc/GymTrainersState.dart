// FILE: lib/features/admin/trainers/presentation/cubit/gym_trainers_state.dart

import '../../domain/entities/GymTrainerEntity.dart';

abstract class GymTrainersState {}

class GymTrainersInitial  extends GymTrainersState {}
class GymTrainersLoading  extends GymTrainersState {}

class GymTrainersLoaded extends GymTrainersState {
  final List<GymTrainerEntity> trainers;
  GymTrainersLoaded(this.trainers);
}

class GymTrainersError extends GymTrainersState {
  final String message;
  GymTrainersError(this.message);
}

// Emitted while a single remove is in progress — keeps the list visible
class GymTrainerRemoving extends GymTrainersState {
  final List<GymTrainerEntity> trainers;
  final int removingUserId;
  GymTrainerRemoving(this.trainers, this.removingUserId);
}

class GymTrainerRemoveError extends GymTrainersState {
  final List<GymTrainerEntity> trainers; // keep showing the list
  final String message;
  GymTrainerRemoveError(this.trainers, this.message);
}