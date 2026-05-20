part of 'admin_invoices_list_bloc.dart';

abstract class AdminInvoicesListEvent {}

class LoadInvoicesListEvent extends AdminInvoicesListEvent {
  final String? status;
  final String? type;
  LoadInvoicesListEvent({this.status, this.type});
}

class FilterInvoicesEvent extends AdminInvoicesListEvent {
  final String? status;
  final String? type;
  FilterInvoicesEvent({this.status, this.type});
}
