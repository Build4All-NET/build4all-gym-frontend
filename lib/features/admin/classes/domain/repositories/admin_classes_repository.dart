// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/domain/repositories/admin_classes_repository.dart
//
// PURPOSE:
//   The abstract contract (interface) for data access in this feature.
//   The domain layer defines WHAT it needs — it does NOT know HOW it's fetched.
//   AdminClassesRepositoryImpl (data layer) provides the actual implementation.
//   The BLoC depends on this abstract class, not on the implementation,
//   so tests can swap in a fake repository without touching real HTTP calls.
// ─────────────────────────────────────────────────────────────────────────────

import '../../data/models/cancel_class_request_model.dart';
import '../../data/models/create_class_request_model.dart';
import '../../data/models/update_class_request_model.dart';
import '../entities/admin_class_card_entity.dart';
import '../entities/class_form_option_item_entity.dart';
import '../entities/session_booking_item_entity.dart';

abstract class AdminClassesRepository {

  // Returns class cards for a given date — date is "yyyy-MM-dd" or null for today
  Future<List<AdminClassCardEntity>> getClassesByDate(
      String? date, int? branchId);

  // Returns dropdown data for the Add/Edit Class form
  Future<ClassFormOptionsEntity> getClassFormOptions(int? branchId);

  // Creates a new class session — returns the new sessionId
  Future<int> createClass(CreateClassRequestModel request);

  // Updates an existing session (partial — only non-null fields applied)
  Future<void> updateClass(int sessionId, UpdateClassRequestModel request);

  // Cancels a session with an optional reason
  Future<void> cancelClass(int sessionId, CancelClassRequestModel request);

  // Returns all non-cancelled bookings for a session
  Future<List<SessionBookingItemEntity>> getSessionBookings(int sessionId);

  // Confirms a cash payment for a pending booking. amountPaid null = full
  // payment; a lower amount records a partial cash payment.
  Future<void> confirmBookingPayment(int bookingId, {double? amountPaid});

  // Collects more cash toward a partially-paid booking's invoice
  Future<void> recordInvoicePayment(int invoiceId, double amount);

  // Reactivates a cancelled session back to SCHEDULED
  Future<void> reactivateClass(int sessionId);

  // Rejects a PENDING booking (sets it to CANCELLED)
  Future<void> rejectBooking(int bookingId);

  // Approves a CANCEL_REQUESTED booking → CANCELLED
  Future<void> approveCancellation(int bookingId);

  // Declines a CANCEL_REQUESTED booking → reverts to BOOKED
  Future<void> declineCancellation(int bookingId);
}