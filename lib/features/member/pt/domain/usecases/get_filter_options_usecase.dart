import '../../../../../core/error/failures.dart';
import '../entities/trainer_filter_options_entity.dart';
import '../repositories/member_pt_repository.dart';

class GetFilterOptionsUseCase {
  final MemberPtRepository _repository;

  GetFilterOptionsUseCase(this._repository);

  Future<({TrainerFilterOptionsEntity? data, Failure? failure})> call() {
    return _repository.getFilterOptions();
  }
}