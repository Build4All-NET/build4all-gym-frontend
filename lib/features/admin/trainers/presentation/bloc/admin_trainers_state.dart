import '../../domain/entities/AdminTrainerDetailEntity.dart';
import '../../domain/entities/admin_trainer_card_entity.dart';
import '../../domain/entities/trainer_form_options_entity.dart';

abstract class AdminTrainersState { const AdminTrainersState(); }

class TrainersInitial extends AdminTrainersState {}

class TrainersLoading extends AdminTrainersState {}

class TrainersLoaded extends AdminTrainersState {
  final List<AdminTrainerCardEntity> trainers;
  final int     total;
  final String? activeSearch;
  final String? activeSpecialty;

  const TrainersLoaded({
    required this.trainers,
    required this.total,
    this.activeSearch,
    this.activeSpecialty,
  });

  TrainersLoaded copyWith({
    List<AdminTrainerCardEntity>? trainers,
    int?     total,
    String?  activeSearch,
    String?  activeSpecialty,
    bool     clearSearch    = false,
    bool     clearSpecialty = false,
  }) =>
      TrainersLoaded(
        trainers:        trainers        ?? this.trainers,
        total:           total           ?? this.total,
        activeSearch:    clearSearch     ? null : (activeSearch    ?? this.activeSearch),
        activeSpecialty: clearSpecialty  ? null : (activeSpecialty ?? this.activeSpecialty),
      );
}

class TrainersError extends AdminTrainersState {
  final String message;
  const TrainersError(this.message);
}

/// Spinner inside Add/Edit bottom sheet while options load
class TrainerFormOptionsLoading extends AdminTrainersState {}

/// Populates dropdowns in the bottom sheet
class TrainerFormOptionsLoaded extends AdminTrainersState {
  final TrainerFormOptionsEntity options;
  const TrainerFormOptionsLoaded(this.options);
}

/// Per-card spinner — only the card with this trainerId shows spinner
class TrainerActionLoading extends AdminTrainersState {
  final int trainerId; // 0 = creating new (no card)
  const TrainerActionLoading(this.trainerId);
}

class TrainerActionSuccess extends AdminTrainersState {
  final int    trainerId;
  final String actionType; // 'created' | 'updated' | 'blocked' | 'unblocked'
  const TrainerActionSuccess(this.trainerId, this.actionType);
}

class TrainerActionError extends AdminTrainersState {
  final int    trainerId;
  final String message;
  const TrainerActionError(this.trainerId, this.message);
}

class TrainerDetailLoading extends AdminTrainersState {}

class TrainerDetailLoaded extends AdminTrainersState {
  final AdminTrainerDetailEntity detail;
  const TrainerDetailLoaded(this.detail);
}

class TrainerDetailError extends AdminTrainersState {
  final String message;
  const TrainerDetailError(this.message);
}