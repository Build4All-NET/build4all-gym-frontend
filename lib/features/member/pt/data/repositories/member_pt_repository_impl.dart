import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';

import '../../domain/entities/trainer_filter_options_entity.dart';
import '../../domain/entities/toggle_favorite_response_entity.dart';
import '../../domain/entities/trainer_list_response_entity.dart';
import '../../domain/entities/trainer_detail_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/pt_booking_response_entity.dart';
import '../../domain/entities/pt_package_booking_response_entity.dart';

import '../../domain/repositories/member_pt_repository.dart';

import '../models/pt_booking_request_model.dart';
import '../models/pt_package_booking_request_model.dart';

import '../services/member_pt_service.dart';

class MemberPtRepositoryImpl implements MemberPtRepository {
  final MemberPtService _service;

  MemberPtRepositoryImpl({
    required MemberPtService service,
  }) : _service = service;

  // ─────────────────────────────────────────────────────────────
  // Trainers list
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({TrainerListResponseEntity? data, Failure? failure})> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  }) async {
    try {
      final model = await _service.getTrainers(
        specialtyFilter: specialtyFilter,
        favoritesOnly: favoritesOnly,
      );

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Filter options
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({TrainerFilterOptionsEntity? data, Failure? failure})>
  getFilterOptions() async {
    try {
      final model = await _service.getFilterOptions();

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Toggle favorite trainer
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({ToggleFavoriteResponseEntity? data, Failure? failure})>
  toggleFavoriteTrainer(
      int trainerId,
      ) async {
    try {
      final model = await _service.toggleFavoriteTrainer(trainerId);

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Trainer detail
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({TrainerDetailEntity? data, Failure? failure})> getTrainerDetail(
      int trainerId,
      ) async {
    try {
      final model = await _service.getTrainerDetail(trainerId);

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Date-based slots
  //
  // GET /api/trainers/{trainerId}/slots?date=YYYY-MM-DD
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({List<TimeSlotEntity>? data, Failure? failure})> getAvailableSlots({
    required int trainerId,
    required DateTime date,
  }) async {
    try {
      final models = await _service.getAvailableSlots(
        trainerId: trainerId,
        date: date,
      );

      return (
      data: models.map((model) => model.toEntity()).toList(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Weekly slots
  //
  // GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({List<TimeSlotEntity>? data, Failure? failure})>
  getWeeklyAvailableSlots({
    required int trainerId,
    required String day,
  }) async {
    try {
      final models = await _service.getWeeklyAvailableSlots(
        trainerId: trainerId,
        day: day,
      );

      return (
      data: models.map((model) => model.toEntity()).toList(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Create normal PT booking
  //
  // POST /api/pt-sessions
  //
  // This creates a confirmed booking when the slot is available.
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({PtBookingResponseEntity? data, Failure? failure})> createBooking({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    try {
      final model = await _service.createBooking(
        PtBookingRequestModel(
          trainerId: trainerId,
          startTime: startTime,
          endTime: endTime,
          notes: notes,
        ),
      );

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Request PT booking
  //
  // POST /api/pt-sessions/request
  //
  // This is used when the member wants to ask for a full/unavailable time.
  // Backend creates status REQUESTED, not SCHEDULED.
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({PtBookingResponseEntity? data, Failure? failure})> requestBooking({
    required int trainerId,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    try {
      final model = await _service.requestBooking(
        PtBookingRequestModel(
          trainerId: trainerId,
          startTime: startTime,
          endTime: endTime,
          notes: notes,
        ),
      );

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Create PT package booking
  //
  // POST /api/member/pt-package-bookings
  // ─────────────────────────────────────────────────────────────

  @override
  Future<({PtPackageBookingResponseEntity? data, Failure? failure})>
  createPackageBooking({
    required int packageId,
    required List<Map<String, dynamic>> weeklySchedule,
  }) async {
    try {
      final model = await _service.createPackageBooking(
        PtPackageBookingRequestModel(
          packageId: packageId,
          weeklySchedule: weeklySchedule,
        ),
      );

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }
}