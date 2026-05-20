part of 'admin_invoices_list_bloc.dart';

abstract class AdminInvoicesListEvent {}

class LoadInvoicesListEvent extends AdminInvoicesListEvent {
  final String? status;
  LoadInvoicesListEvent({this.status});
}

class FilterInvoicesEvent extends AdminInvoicesListEvent {
  final String? status;
  FilterInvoicesEvent({this.status});
}
