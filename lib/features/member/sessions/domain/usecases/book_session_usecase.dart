import '../entities/book_session_result_entity.dart';
import '../repositories/sessions_repository.dart';

class BookSessionUseCase {
  final SessionsRepository repository;

  BookSessionUseCase(this.repository);

  Future<BookSessionResultEntity> call(int sessionId, {String? paymentMethod}) {
    return repository.bookSession(sessionId, paymentMethod: paymentMethod);
  }
}