part of 'admin_invoice_bloc.dart';

abstract class AdminInvoiceState {}

class AdminInvoiceInitial extends AdminInvoiceState {}
class AdminInvoiceLoading extends AdminInvoiceState {}

class AdminInvoiceLoaded extends AdminInvoiceState {
  final AdminInvoiceEntity invoice;
  final bool wasPaymentRecorded;
  AdminInvoiceLoaded(this.invoice, {this.wasPaymentRecorded = false});
}

class AdminInvoiceError extends AdminInvoiceState {
  final String message;
  AdminInvoiceError(this.message);
}
