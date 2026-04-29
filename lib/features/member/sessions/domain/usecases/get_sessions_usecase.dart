import '../entities/session_card_entity.dart';
import '../repositories/sessions_repository.dart';

class GetSessionsUseCase {
  final SessionsRepository repository;

  GetSessionsUseCase(this.repository);

  Future<List<SessionCardEntity>> call({
    required DateTime date,
    int? classTypeId,
    int? trainerId,
    String? branchId,
  }) {
    return repository.getSessions(
      date: date,
      classTypeId: classTypeId,
      trainerId: trainerId,
      branchId: branchId,
    );
  }
}