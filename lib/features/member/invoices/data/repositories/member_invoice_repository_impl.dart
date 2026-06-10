import '../../domain/entities/member_invoice_entity.dart';
import '../../domain/repositories/member_invoice_repository.dart';
import '../services/member_invoice_service.dart';

/// Concrete implementation of MemberInvoiceRepository.
///
/// Role of this class:
/// - Connect domain layer to data layer
/// - Call MemberInvoiceService
/// - Return domain entities to use cases / blocs
///
/// We keep this class thin because all HTTP work is inside the service.
class MemberInvoiceRepositoryImpl implements MemberInvoiceRepository {
  final MemberInvoiceService _service;

  MemberInvoiceRepositoryImpl(this._service);

  /// Get full invoice details.
  ///
  /// Used by the details screen.
  @override
  Future<MemberInvoiceEntity> getInvoice(int invoiceId) {
    return _service.getInvoice(invoiceId);
  }

  /// Get member payment history list.
  ///
  /// Backend already filters invoices by logged-in member.
  @override
  Future<List<MemberInvoiceSummaryEntity>> listInvoices({
    int page = 0,
    int size = 50,
    String? status,
    String? type,
  }) {
    return _service.listInvoices(
      page: page,
      size: size,
      status: status,
      type: type,
    );
  }

  /// Send refund request.
  ///
  /// Backend creates refund request with status = pending.
  /// After this call, UI should reload list to hide the button.
  @override
  Future<void> requestRefund({
    required int invoiceId,
    String? reason,
  }) {
    return _service.requestRefund(
      invoiceId: invoiceId,
      reason: reason,
    );
  }
}