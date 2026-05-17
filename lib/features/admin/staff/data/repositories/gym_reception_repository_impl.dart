import '../../domain/entities/gym_reception_entity.dart';
import '../../domain/repositories/gym_reception_repository.dart';
import '../services/gym_reception_service.dart';

class GymReceptionRepositoryImpl implements GymReceptionRepository {
  final GymReceptionService _service;
  const GymReceptionRepositoryImpl(this._service);

  @override
  Future<List<GymReceptionEntity>> getGymReception() async {
    final models = await _service.fetchGymReception();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> removeGymReception(int userId) =>
      _service.removeGymReception(userId);
}
