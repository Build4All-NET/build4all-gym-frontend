import '../../../../../core/error/failures.dart';
import '../entities/trainer_detail_entity.dart';
import '../entities/trainer_filter_options_entity.dart';
import '../entities/toggle_favorite_response_entity.dart';
import '../entities/trainer_list_response_entity.dart';
import '../entities/time_slot_entity.dart';

abstract class MemberPtRepository {
  Future<({TrainerListResponseEntity? data, Failure? failure})> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  });

  Future<({TrainerFilterOptionsEntity? data, Failure? failure})>
  getFilterOptions();

  Future<({ToggleFavoriteResponseEntity? data, Failure? failure})>
  toggleFavoriteTrainer(
      int trainerId,
      );

  Future<({TrainerDetailEntity? data, Failure? failure})> getTrainerDetail(
      int trainerId,
      );

  Future<({List<TimeSlotEntity>? data, Failure? failure})> getAvailableSlots({
    required int trainerId,
    required DateTime date,
  });
}