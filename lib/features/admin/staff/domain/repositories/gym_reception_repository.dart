import '../entities/gym_reception_entity.dart';

abstract class GymReceptionRepository {
  Future<List<GymReceptionEntity>> getGymReception();
  Future<void> removeGymReception(int userId);
}
