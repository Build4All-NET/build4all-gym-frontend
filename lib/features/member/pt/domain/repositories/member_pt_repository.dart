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

  // ─────────────────────────────────────────────────────────────
  // Date-based slots
  //
  // Backend endpoint:
  // GET /api/member/pt/trainers/{trainerId}/slots?branchId=&serviceId=&date=
  //
  // Used by old single-session booking.
  // ─────────────────────────────────────────────────────────────

  Future<({List<TimeSlotEntity>? data, Failure? failure})> getAvailableSlots({
    required int trainerId,
    required int branchId,
    required int serviceId,
    required DateTime date,
  });

  // ─────────────────────────────────────────────────────────────
  // Weekly slots
  //
  // Backend endpoint:
  // GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  //
  // Used by PT package booking.
  // ─────────────────────────────────────────────────────────────

  Future<({List<TimeSlotEntity>? data, Failure? failure})>
  getWeeklyAvailableSlots({
    required int trainerId,
    required String day,
    int? packageId,
  });

  // ─────────────────────────────────────────────────────────────
  // Normal PT booking
  //
  // Backend endpoint:
  // POST /api/pt-sessions
  //
  // Creates a confirmed PT session when the selected slot is available.
  // ─────────────────────────────────────────────────────────────

  Future<({PtBookingResponseEntity? data, Failure? failure})> createBooking({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  });

  // ─────────────────────────────────────────────────────────────
  // PT booking request
  //
  // Backend endpoint:
  // POST /api/pt-sessions/request
  //
  // Used when the member wants to request a full/unavailable time.
  // Backend creates a REQUESTED session, not a confirmed booking.
  // ─────────────────────────────────────────────────────────────

  Future<({PtBookingResponseEntity? data, Failure? failure})> requestBooking({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  });

  // ─────────────────────────────────────────────────────────────
  // PT package booking
  //
  // Backend endpoint:
  // POST /api/member/pt-package-bookings
  //
  // Example weeklySchedule:
  // [
  //   {
  //     "day": "MONDAY",
  //     "time": "09:00"
  //   },
  //   {
  //     "day": "THURSDAY",
  //     "time": "18:00"
  //   }
  // ]
  // ─────────────────────────────────────────────────────────────

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})>
  createPackageBooking({
    required int packageId,
    required List<Map<String, dynamic>> weeklySchedule,
    String? paymentMethod,
  });

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})>
  confirmPackagePayment(int bookingId);

  Future<({PtPackageBookingResponseEntity? data, Failure? failure})>
  checkPackagePaymentStatus(int bookingId);
}