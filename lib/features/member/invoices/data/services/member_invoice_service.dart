import 'package:dio/dio.dart';

import '../models/member_invoice_model.dart';

/// API service for member invoices.
///
/// This class talks directly to backend endpoints:
/// - GET  /api/member/invoices
/// - GET  /api/member/invoices/{invoiceId}
/// - POST /api/member/invoices/{invoiceId}/refund-request
///
/// Keep this layer dumb:
/// - no UI logic
/// - no business decisions
/// - only HTTP calls + JSON mapping
class MemberInvoiceService {
  final Dio _dio;

  MemberInvoiceService(this._dio);

  /// Load member payment history.
  ///
  /// Backend returns a Spring Page object:
  /// {
  ///   "content": [ ... ],
  ///   "totalElements": 10,
  ///   "totalPages": 1,
  ///   ...
  /// }
  ///
  /// We only need "content" for now.
  Future<List<MemberInvoiceSummaryModel>> listInvoices({
    int page = 0,
    int size = 50,
    String? status,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };

    if (status != null && status.trim().isNotEmpty) {
      queryParams['status'] = status.trim();
    }

    if (type != null && type.trim().isNotEmpty) {
      queryParams['type'] = type.trim();
    }

    final response = await _dio.get(
      '/api/member/invoices',
      queryParameters: queryParams,
    );

    final data = response.data;

    // Spring Page format.
    if (data is Map) {
      final content = data['content'];

      if (content is List) {
        return content
            .map(
              (e) => MemberInvoiceSummaryModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
            .toList();
      }
    }

    // Fallback if backend ever returns a raw list.
    if (data is List) {
      return data
          .map(
            (e) => MemberInvoiceSummaryModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList();
    }

    return const [];
  }

  /// Load full invoice details.
  ///
  /// Used when member clicks "عرض التفاصيل".
  Future<MemberInvoiceModel> getInvoice(int invoiceId) async {
    final response = await _dio.get('/api/member/invoices/$invoiceId');

    return MemberInvoiceModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  /// Send refund request to backend.
  ///
  /// This does NOT refund directly.
  /// Backend creates a refund row with:
  /// status = pending
  Future<void> requestRefund({
    required int invoiceId,
    String? reason,
  }) async {
    final body = <String, dynamic>{};

    if (reason != null && reason.trim().isNotEmpty) {
      body['reason'] = reason.trim();
    }

    await _dio.post(
      '/api/member/invoices/$invoiceId/refund-request',
      data: body,
    );
  }
}