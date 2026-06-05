import '../entities/member_invoice_entity.dart';
import '../repositories/member_invoice_repository.dart';

/// Use case for loading one full invoice.
///
/// UI calls this instead of calling repository directly.
/// Same clean architecture style as admin side.
class GetMemberInvoiceUseCase {
  final MemberInvoiceRepository _repo;

  GetMemberInvoiceUseCase(this._repo);

  Future<MemberInvoiceEntity> call(int invoiceId) {
    return _repo.getInvoice(invoiceId);
  }
}

/// Use case for loading member payment history.
///
/// Returns the lightweight invoice summaries used in the list screen.
class ListMemberInvoicesUseCase {
  final MemberInvoiceRepository _repo;

  ListMemberInvoicesUseCase(this._repo);

  Future<List<MemberInvoiceSummaryEntity>> call({
    int page = 0,
    int size = 50,
    String? status,
    String? type,
  }) {
    return _repo.listInvoices(
      page: page,
      size: size,
      status: status,
      type: type,
    );
  }
}

/// Use case for sending refund request.
///
/// Flow:
/// 1. Member clicks "استرجاع المبلغ"
/// 2. Flutter calls this use case
/// 3. Backend creates refund request with status pending
/// 4. Flutter reloads invoice list
class RequestMemberRefundUseCase {
  final MemberInvoiceRepository _repo;

  RequestMemberRefundUseCase(this._repo);

  Future<void> call({
    required int invoiceId,
    String? reason,
  }) {
    return _repo.requestRefund(
      invoiceId: invoiceId,
      reason: reason,
    );
  }
}