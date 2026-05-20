import '../entities/admin_invoice_entity.dart';

abstract class AdminInvoiceRepository {
  Future<AdminInvoiceEntity> getInvoice(int invoiceId);
  Future<List<AdminInvoiceSummaryEntity>> listInvoices({int page = 0, int size = 50, String? status, String? type});
}
