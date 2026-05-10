import '../../../../../core/error/failures.dart';
import '../entities/trainer_detail_entity.dart';
import '../entities/trainer_filter_options_entity.dart';
import '../entities/toggle_favorite_response_entity.dart';
import '../entities/trainer_list_response_entity.dart';
import '../entities/time_slot_entity.dart';
import '../entities/pt_booking_response_entity.dart';
import '../entities/pt_package_booking_response_entity.dart';
abstract class MemberPtRepository {
  Future<({TrainerListResponseEntity? data, Failure? failure})> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  });

  Future<({TrainerFilterOptionsEntity? data, Failure? failure})>
  getFilterOptions();

  Future<({ToggleFavoriteResponseEntity? data, Failure? failure})>
  toggleFavoriteTrainer(
      int trainerId,
      );

  Future<({TrainerDetailEntity? data, Failure? failure})> getTrainerDetail(
      int trainerId,
      );

  Future<({List<TimeSlotEntity>? data, Failure? failure})> getAvailableSlots({
    required int trainerId,
    required DateTime date,
  });
  /// Creates a new personal trainer booking.
  ///
  /// Returns:
  /// - data when request succeeds
  /// - failure when request fails
  Future<({PtBookingResponseEntity? data, Failure? failure})> createBooking({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  });
  /// Returns recurring weekly available PT slots for a trainer.
  ///
  /// Used by PT package booking.
  ///
  /// Backend endpoint:
  /// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  ///
  /// Important:
  /// - day is a stable backend code:
  ///   MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
  /// - no date is sent.
  /// - returned slots come from trainer availability.
  Future<({List<TimeSlotEntity>? data, Failure? failure})>
  getWeeklyAvailableSlots({
    required int trainerId,
    required String day,
  });
  /// Creates a PT package booking.
  ///
  /// New package flow:
  /// - no dates
  /// - no global selectedTime
  /// - each selected weekday has its own time
  ///
  /// Example weeklySchedule:
  /// [
  ///   {
  ///     "day": "MONDAY",
  ///     "time": "09:00"
  ///   },
  ///   {
  ///     "day": "THURSDAY",
  ///     "time": "18:00"
  ///   }
  /// ]
  Future<({PtPackageBookingResponseEntity? data, Failure? failure})>
  createPackageBooking({
    required int packageId,
    required List<Map<String, dynamic>> weeklySchedule,
  });
}