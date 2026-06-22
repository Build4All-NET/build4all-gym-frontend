import '../repositories/admin_classes_repository.dart';

class RecordInvoicePaymentUseCase {
  final AdminClassesRepository _repository;

  RecordInvoicePaymentUseCase(this._repository);

  Future<void> call(int invoiceId, double amount) =>
      _repository.recordInvoicePayment(invoiceId, amount);
}
