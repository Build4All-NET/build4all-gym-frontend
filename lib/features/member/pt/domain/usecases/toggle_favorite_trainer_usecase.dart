import '../../../../../core/error/failures.dart';
import '../entities/toggle_favorite_response_entity.dart';
import '../repositories/member_pt_repository.dart';

class ToggleFavoriteTrainerUseCase {
  final MemberPtRepository _repository;

  ToggleFavoriteTrainerUseCase(this._repository);

  Future<({ToggleFavoriteResponseEntity? data, Failure? failure})> call(
      int trainerId,
      ) {
    return _repository.toggleFavoriteTrainer(trainerId);
  }
}