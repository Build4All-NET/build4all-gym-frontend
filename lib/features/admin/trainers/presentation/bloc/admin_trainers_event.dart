// PATH: lib/features/admin/trainers/presentation/bloc/
// =============================================================================

// ─── admin_trainers_event.dart ────────────────────────────────────────────────

import '../../data/models/create_trainer_request_model.dart';
import '../../data/models/update_trainer_request_model.dart';

abstract class AdminTrainersEvent { const AdminTrainersEvent(); }

/// Initial load when screen opens
class TrainersStarted extends AdminTrainersEvent {
  const TrainersStarted();
}

/// Dispatched from search TextField — debounced 300ms in BLoC
class TrainersSearchChanged extends AdminTrainersEvent {
  final String query;
  const TrainersSearchChanged(this.query);
}

/// Dispatched from specialty dropdown — null means "All"
class TrainersSpecialtyFilterChanged extends AdminTrainersEvent {
  final String? specialty;
  const TrainersSpecialtyFilterChanged(this.specialty);
}

/// Dispatched when Add/Edit sheet opens — loads dropdown data
class TrainerFormOptionsRequested extends AdminTrainersEvent {
  const TrainerFormOptionsRequested();
}

/// Dispatched on Save in Add mode
class TrainerCreateRequested extends AdminTrainersEvent {
  final CreateTrainerRequestModel request;
  const TrainerCreateRequested(this.request);
}

/// Dispatched on Save in Edit mode
class TrainerUpdateRequested extends AdminTrainersEvent {
  final int                       trainerId;
  final UpdateTrainerRequestModel request;
  const TrainerUpdateRequested(this.trainerId, this.request);
}

/// Dispatched after confirmation dialog on Block button
class TrainerBlockRequested extends AdminTrainersEvent {
  final int trainerId;
  const TrainerBlockRequested(this.trainerId);
}

/// Internal — reload list after action
class TrainersReload extends AdminTrainersEvent {
  const TrainersReload();
}

class TrainerDetailRequested extends AdminTrainersEvent {
  final int trainerId;
  const TrainerDetailRequested(this.trainerId);
}