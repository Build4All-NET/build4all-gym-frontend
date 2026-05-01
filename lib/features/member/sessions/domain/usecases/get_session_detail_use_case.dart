import '../entities/session_detail_entity.dart';
import '../repositories/sessions_repository.dart';

class GetSessionDetailUseCase {
  final SessionsRepository _repository;

  GetSessionDetailUseCase(this._repository);

  Future<SessionDetailEntity> call(int sessionId) {
    return _repository.getSessionDetail(sessionId);
  }
}