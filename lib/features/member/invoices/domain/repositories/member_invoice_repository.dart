import '../entities/member_invoice_entity.dart';

/// Contract for member invoice operations.
///
/// Presentation layer talks to this interface,
/// not directly to API services.
///
/// This keeps the code clean and same as admin structure.
abstract class MemberInvoiceRepository {
  /// Get full invoice details by invoice ID.
  ///
  /// Used when member clicks "عرض التفاصيل".
  Future<MemberInvoiceEntity> getInvoice(int invoiceId);

  /// Get member payment history.
  ///
  /// Backend returns only invoices belonging to the logged-in member.
  ///
  /// Optional filters:
  /// - status: paid / refunded / cancelled / pending / partial
  /// - type: PLAN / CLASS / PT / PT_PACKAGE / DAILY_PASS / OTHER
  Future<List<MemberInvoiceSummaryEntity>> listInvoices({
    int page = 0,
    int size = 50,
    String? status,
    String? type,
  });

  /// Send refund request to admin.
  ///
  /// This does NOT refund directly.
  /// It creates a pending refund request in backend.
  ///
  /// After success:
  /// - backend returns 204
  /// - list should be reloaded
  /// - canRequestRefund becomes false
  /// - refundStatus becomes pending
  Future<void> requestRefund({
    required int invoiceId,
    String? reason,
  });
}