import '../entities/book_session_result_entity.dart';
import '../entities/filter_option_item_entity.dart';
import '../entities/session_card_entity.dart';
import '../entities/session_detail_entity.dart';
abstract class SessionsRepository {
  Future<List<SessionCardEntity>> getSessions({
    required DateTime date,
    int? classTypeId,
    int? trainerId,
    String? branchId,
  });

  Future<({
  List<FilterOptionItemEntity> classTypes,
  List<FilterOptionItemEntity> trainers,
  List<FilterOptionItemEntity> branches,
  })> getFilterOptions();

  Future<BookSessionResultEntity> bookSession(int sessionId, {String? paymentMethod});

  Future<void> cancelBooking(int bookingId);
  Future<SessionDetailEntity> getSessionDetail(int sessionId);
}