import '../entities/admin_invoice_entity.dart';
import '../repositories/admin_invoice_repository.dart';

class GetInvoiceUseCase {
  final AdminInvoiceRepository _repo;
  GetInvoiceUseCase(this._repo);

  Future<AdminInvoiceEntity> call(int invoiceId) => _repo.getInvoice(invoiceId);
}

class ListInvoicesUseCase {
  final AdminInvoiceRepository _repo;
  ListInvoicesUseCase(this._repo);

  Future<List<AdminInvoiceSummaryEntity>> call({int page = 0, int size = 50, String? status, String? type}) =>
      _repo.listInvoices(page: page, size: size, status: status, type: type);
}
