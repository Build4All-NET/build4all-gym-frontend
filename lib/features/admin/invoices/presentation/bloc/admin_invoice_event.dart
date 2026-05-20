part of 'admin_invoice_bloc.dart';

abstract class AdminInvoiceEvent {}

class LoadInvoiceEvent extends AdminInvoiceEvent {
  final int invoiceId;
  LoadInvoiceEvent(this.invoiceId);
}
