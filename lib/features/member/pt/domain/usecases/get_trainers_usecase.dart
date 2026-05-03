import '../../../../../core/error/failures.dart';
import '../entities/trainer_list_response_entity.dart';
import '../repositories/member_pt_repository.dart';

class GetTrainersUseCase {
  final MemberPtRepository _repository;

  GetTrainersUseCase(this._repository);

  Future<({TrainerListResponseEntity? data, Failure? failure})> call({
    String? specialtyFilter,
    bool favoritesOnly = false,
  }) {
    return _repository.getTrainers(
      specialtyFilter: specialtyFilter,
      favoritesOnly: favoritesOnly,
    );
  }
}