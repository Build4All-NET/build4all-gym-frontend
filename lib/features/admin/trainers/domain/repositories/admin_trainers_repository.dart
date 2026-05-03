// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/trainers/domain/repositories/admin_trainers_repository.dart
// ─────────────────────────────────────────────────────────────────────────────
import '../entities/AdminTrainerDetailEntity.dart';
import '../entities/admin_trainer_card_entity.dart';
import '../entities/trainer_form_options_entity.dart';
import '../../data/models/create_trainer_request_model.dart';
import '../../data/models/update_trainer_request_model.dart';

abstract class AdminTrainersRepository {
  Future<List<AdminTrainerCardEntity>> getTrainers({
    int?    branchId,
    String? search,
    String? specialtyFilter,
  });

  Future<TrainerFormOptionsEntity> getFormOptions();

  Future<int>    createTrainer(CreateTrainerRequestModel request);
  Future<void>   updateTrainer(int trainerId, UpdateTrainerRequestModel request);
  Future<String> blockTrainer(int trainerId);  // returns new status string
  Future<AdminTrainerDetailEntity> getTrainerDetail(int trainerId);
}
