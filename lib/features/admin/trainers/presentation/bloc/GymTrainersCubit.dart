// FILE: lib/features/admin/trainers/presentation/cubit/gym_trainers_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/GymTrainerEntity.dart';
import '../../domain/usecases/GetGymTrainersUseCase.dart';
import 'GymTrainersState.dart';

class GymTrainersCubit extends Cubit<GymTrainersState> {
  final GetGymTrainersUseCase    _getTrainers;
  final RemoveGymTrainerUseCase  _removeTrainer;

  GymTrainersCubit({
    required GetGymTrainersUseCase getTrainers,
    required RemoveGymTrainerUseCase removeTrainer,
  })  : _getTrainers  = getTrainers,
        _removeTrainer = removeTrainer,
        super(GymTrainersInitial());

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> load() async {
    emit(GymTrainersLoading());
    try {
      final trainers = await _getTrainers();
      emit(GymTrainersLoaded(trainers));
    } catch (e) {
      emit(GymTrainersError(e.toString()));
    }
  }

  // ── Reload (called after MemberPickerForTrainerSheet assigns a new trainer)

  Future<void> reload() => load();

  // ── Remove ────────────────────────────────────────────────────────────────

  Future<void> removeTrainer(int userId) async {
    final currentTrainers = _currentList();
    emit(GymTrainerRemoving(currentTrainers, userId));
    try {
      await _removeTrainer(userId);
      // Remove from local list immediately — no need to re-fetch
      final updated = currentTrainers.where((t) => t.userId != userId).toList();
      emit(GymTrainersLoaded(updated));
    } catch (e) {
      emit(GymTrainerRemoveError(currentTrainers, 'Could not remove trainer. Try again.'));
    }
  }

  List<GymTrainerEntity> _currentList() {
    final s = state;
    if (s is GymTrainersLoaded)      return s.trainers;
    if (s is GymTrainerRemoving)     return s.trainers;
    if (s is GymTrainerRemoveError)  return s.trainers;
    return [];
  }
}