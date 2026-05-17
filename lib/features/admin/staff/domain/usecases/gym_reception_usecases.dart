import '../entities/gym_reception_entity.dart';
import '../repositories/gym_reception_repository.dart';

class GetGymReceptionUseCase {
  final GymReceptionRepository _repository;
  const GetGymReceptionUseCase(this._repository);
  Future<List<GymReceptionEntity>> call() => _repository.getGymReception();
}

class RemoveGymReceptionUseCase {
  final GymReceptionRepository _repository;
  const RemoveGymReceptionUseCase(this._repository);
  Future<void> call(int userId) => _repository.removeGymReception(userId);
}
