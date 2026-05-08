import '../../../../../core/error/failures.dart';
import '../entities/trainer_detail_entity.dart';
import '../repositories/member_pt_repository.dart';

class GetTrainerDetailUseCase {
  final MemberPtRepository _repository;

  GetTrainerDetailUseCase(this._repository);

  Future<({TrainerDetailEntity? data, Failure? failure})> call(
      int trainerId,
      ) {
    return _repository.getTrainerDetail(trainerId);
  }
}