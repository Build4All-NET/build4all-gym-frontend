// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/repositories/admin_classes_repository_impl.dart
//
// PURPOSE:
//   Implements the abstract AdminClassesRepository.
//   Sits between the service (HTTP) and the domain (entities).
//   Its two jobs:
//     1. Call the service method
//     2. Convert models → entities (the domain layer only speaks entities)
//
// ERROR HANDLING:
//   Catches exceptions from the service and wraps them in AppException
//   so every caller (use case → BLoC) gets consistent error objects.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/admin_class_card_entity.dart';
import '../../domain/entities/class_form_option_item_entity.dart';
import '../../domain/entities/session_booking_item_entity.dart';
import '../../domain/repositories/admin_classes_repository.dart';
import '../models/cancel_class_request_model.dart';
import '../models/create_class_request_model.dart';
import '../models/update_class_request_model.dart';
import '../services/admin_classes_service.dart';

class AdminClassesRepositoryImpl implements AdminClassesRepository {
  final AdminClassesService _service;

  AdminClassesRepositoryImpl(this._service);

  // ── getClassesByDate ───────────────────────────────────────────────────────
  @override
  Future<List<AdminClassCardEntity>> getClassesByDate(
      String? date, int? branchId) async {
    try {
      final response = await _service.getClassesByDate(date, branchId);

      // Map each AdminClassCardModel → AdminClassCardEntity
      return response.classes.map((m) => AdminClassCardEntity(
        sessionId:       m.sessionId,
        className:       m.className,
        typeName:        m.typeName,
        trainerName:     m.trainerName,
        branchName:      m.branchName,
        roomName:        m.roomName,
        startTime:       m.startTime,
        endTime:         m.endTime,
        durationMinutes: m.durationMinutes,
        capacity:        m.capacity,
        bookedCount:     m.bookedCount,
        status:          m.status,
        nearlyFull:      m.nearlyFull,
      )).toList();
    } catch (e) {
      rethrow; // BLoC catches and emits ClassesError
    }
  }

  // ── getClassFormOptions ────────────────────────────────────────────────────
  @override
  Future<ClassFormOptionsEntity> getClassFormOptions(int? branchId) async {
    try {
      final model = await _service.getClassFormOptions(branchId);

      // Helper to map a list of ClassFormOptionItemModel → ClassFormOptionItemEntity
      List<ClassFormOptionItemEntity> mapItems(items) => items
          .map<ClassFormOptionItemEntity>((m) =>
          ClassFormOptionItemEntity(id: m.id, name: m.name))
          .toList();

      return ClassFormOptionsEntity(
        classTypes: mapItems(model.classTypes),
        trainers:   mapItems(model.trainers),
        branches:   mapItems(model.branches),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ── createClass ────────────────────────────────────────────────────────────
  @override
  Future<int> createClass(CreateClassRequestModel request) async {
    try {
      return await _service.createClass(request);
    } catch (e) {
      rethrow;
    }
  }

  // ── updateClass ────────────────────────────────────────────────────────────
  @override
  Future<void> updateClass(
      int sessionId, UpdateClassRequestModel request) async {
    try {
      await _service.updateClass(sessionId, request);
    } catch (e) {
      rethrow;
    }
  }

  // ── cancelClass ────────────────────────────────────────────────────────────
  @override
  Future<void> cancelClass(
      int sessionId, CancelClassRequestModel request) async {
    try {
      await _service.cancelClass(sessionId, request);
    } catch (e) {
      rethrow;
    }
  }

  // ── reactivateClass ────────────────────────────────────────────────────────
  @override
  Future<void> reactivateClass(int sessionId) async {
    try {
      await _service.reactivateClass(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // ── getSessionBookings ─────────────────────────────────────────────────────
  @override
  Future<List<SessionBookingItemEntity>> getSessionBookings(
      int sessionId) async {
    try {
      final models = await _service.getSessionBookings(sessionId);

      return models.map((m) => SessionBookingItemEntity(
        bookingId:        m.bookingId,
        userId:           m.userId,
        fullName:         m.fullName,
        phone:            m.phone ?? '',
        profileFileId:    m.profileFileId,
        status:           m.status,
        waitlistPosition: m.waitlistPosition,
        paymentStatus:    m.paymentStatus,
        paymentMethod:    m.paymentMethod,
        invoiceId:        m.invoiceId,
        price:            m.price,
        bookedAt:         m.bookedAt,
      )).toList();
    } catch (e) {
      rethrow;
    }
  }

  // ── confirmBookingPayment ──────────────────────────────────────────────────
  @override
  Future<void> confirmBookingPayment(int bookingId, {double? amountPaid}) async {
    try {
      await _service.confirmBookingPayment(bookingId, amountPaid: amountPaid);
    } catch (e) {
      rethrow;
    }
  }

  // ── recordInvoicePayment ────────────────────────────────────────────────────
  @override
  Future<void> recordInvoicePayment(int invoiceId, double amount) async {
    try {
      await _service.recordInvoicePayment(invoiceId, amount);
    } catch (e) {
      rethrow;
    }
  }

  // ── rejectBooking ──────────────────────────────────────────────────────────
  @override
  Future<void> rejectBooking(int bookingId) async {
    try {
      await _service.rejectBooking(bookingId);
    } catch (e) {
      rethrow;
    }
  }

  // ── approveCancellation ────────────────────────────────────────────────────
  @override
  Future<void> approveCancellation(int bookingId) async {
    try {
      await _service.approveCancellation(bookingId);
    } catch (e) {
      rethrow;
    }
  }

  // ── declineCancellation ────────────────────────────────────────────────────
  @override
  Future<void> declineCancellation(int bookingId) async {
    try {
      await _service.declineCancellation(bookingId);
    } catch (e) {
      rethrow;
    }
  }
}