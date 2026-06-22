part of 'admin_invoice_bloc.dart';

abstract class AdminInvoiceEvent {}

class LoadInvoiceEvent extends AdminInvoiceEvent {
  final int invoiceId;
  LoadInvoiceEvent(this.invoiceId);
}

class RecordInvoicePaymentEvent extends AdminInvoiceEvent {
  final int invoiceId;
  final double amount;
  final String? notes;
  RecordInvoicePaymentEvent(this.invoiceId, this.amount, {this.notes});
}
