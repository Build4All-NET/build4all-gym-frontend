part of 'admin_invoices_list_bloc.dart';

abstract class AdminInvoicesListState {}

class AdminInvoicesListInitial extends AdminInvoicesListState {}
class AdminInvoicesListLoading  extends AdminInvoicesListState {}

class AdminInvoicesListLoaded extends AdminInvoicesListState {
  final List<AdminInvoiceSummaryEntity> invoices;
  final String? selectedStatus;
  AdminInvoicesListLoaded(this.invoices, {this.selectedStatus});
}

class AdminInvoicesListError extends AdminInvoicesListState {
  final String message;
  AdminInvoicesListError(this.message);
}
