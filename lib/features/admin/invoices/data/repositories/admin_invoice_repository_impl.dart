import '../../domain/entities/admin_invoice_entity.dart';
import '../../domain/repositories/admin_invoice_repository.dart';
import '../models/admin_invoice_model.dart';
import '../services/admin_invoice_service.dart';

class AdminInvoiceRepositoryImpl implements AdminInvoiceRepository {
  final AdminInvoiceService _service;
  AdminInvoiceRepositoryImpl(this._service);

  @override
  Future<AdminInvoiceEntity> getInvoice(int invoiceId) async {
    final model = await _service.getInvoice(invoiceId);
    return model.toEntity();
  }

  @override
  Future<List<AdminInvoiceSummaryEntity>> listInvoices({
    int    page   = 0,
    int    size   = 50,
    String? status,
  }) async {
    final models = await _service.listInvoices(page: page, size: size, status: status);
    return models.map<AdminInvoiceSummaryEntity>((AdminInvoiceSummaryModel m) => m.toEntity()).toList();
  }
}
