// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/services/admin_classes_service.dart
//
// PURPOSE:
//   Makes ALL HTTP calls for the admin classes feature.
//   Uses your existing API client (same pattern as other services in the project).
//   Returns raw model objects — no business logic here, just network + parsing.
//
// BASE PATH: /api/admin/classes
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../../../../core/network/'; // your existing API client
import '../models/admin_class_card_model.dart';
import '../models/admin_class_list_response_model.dart';
import '../models/cancel_class_request_model.dart';
import '../models/class_form_options_model.dart';
import '../models/create_class_request_model.dart';
import '../models/session_booking_item_model.dart';
import '../models/update_class_request_model.dart';
import '../../../../../core/config/env.dart';

class AdminClassesService {
  final Env _apiClient; // injected — same client used across the app

  AdminClassesService(this._apiClient);

  // ── GET /api/admin/classes ─────────────────────────────────────────────────
  // Returns class cards for a given date (or today if date omitted).
  // branchId is optional — null means "all branches".
  Future<AdminClassListResponseModel> getClassesByDate(
      String? date, int? branchId) async {
    // Build query params — only add keys that have values
    final params = <String, String>{};
    if (date     != null) params['date']     = date;
    if (branchId != null) params['branchId'] = branchId.toString();

    final response = await _apiClient.get(
      '/api/admin/classes',
      queryParams: params,
    );

    return AdminClassListResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── GET /api/admin/classes/form-options ────────────────────────────────────
  // Returns all dropdown data for the Add/Edit Class form.
  Future<ClassFormOptionsModel> getClassFormOptions(int? branchId) async {
    final params = <String, String>{};
    if (branchId != null) params['branchId'] = branchId.toString();

    final response = await _apiClient.http.get(
      '/api/admin/classes/form-options',
      queryParams: params,
    );

    return ClassFormOptionsModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── POST /api/admin/classes ────────────────────────────────────────────────
  // Creates a new class session. Returns the new sessionId from the response body.
  Future<int> createClass(CreateClassRequestModel request) async {
    final response = await _apiClient.post(
      '/api/admin/classes',
      body: request.toJson(),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    // BE returns { "sessionId": 42 }
    return json['sessionId'] as int;
  }

  // ── PUT /api/admin/classes/{sessionId} ─────────────────────────────────────
  // Partial update — only sends non-null fields.
  Future<void> updateClass(
      int sessionId, UpdateClassRequestModel request) async {
    await _apiClient.put(
      '/api/admin/classes/$sessionId',
      body: request.toJson(),
    );
  }

  // ── PATCH /api/admin/classes/{sessionId}/cancel ────────────────────────────
  // Cancels a class session. cancelReason in body is optional.
  Future<void> cancelClass(
      int sessionId, CancelClassRequestModel request) async {
    await _apiClient.patch(
      '/api/admin/classes/$sessionId/cancel',
      body: request.toJson(),
    );
  }

  // ── GET /api/admin/classes/{sessionId}/bookings ────────────────────────────
  // Returns all BOOKED + WAITLISTED members for a session.
  Future<List<SessionBookingItemModel>> getSessionBookings(
      int sessionId) async {
    final response = await _apiClient.get(
      '/api/admin/classes/$sessionId/bookings',
    );

    final rawList = jsonDecode(response.body) as List<dynamic>;
    return rawList
        .map((e) =>
        SessionBookingItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}