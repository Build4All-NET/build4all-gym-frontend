part of 'admin_expenses_bloc.dart';

abstract class AdminExpensesEvent {}

/// Fired on screen init — loads stats + expenses in parallel
class LoadAdminExpensesEvent extends AdminExpensesEvent {}

/// User picks a category from the filter dropdown (null = "All Categories")
class FilterByCategoryEvent extends AdminExpensesEvent {
  final String? category;
  FilterByCategoryEvent({this.category});
}

/// User picks a branch from the filter dropdown (null = "All Branches")
class FilterByBranchEvent extends AdminExpensesEvent {
  final int? branchId;
  FilterByBranchEvent({this.branchId});
}

/// User types in the search field (debounced in screen)
class SearchExpensesEvent extends AdminExpensesEvent {
  final String query;
  SearchExpensesEvent({required this.query});
}

/// User confirms deleting an expense
class DeleteExpenseEvent extends AdminExpensesEvent {
  final int expenseId;
  DeleteExpenseEvent({required this.expenseId});
}

/// Fired after successful create/update from ExpenseFormBottomSheet — reloads list
class RefreshExpensesEvent extends AdminExpensesEvent {}

/// Owner confirms a commission expense was actually paid out to the trainer
class ConfirmTrainerPaidEvent extends AdminExpensesEvent {
  final int expenseId;
  ConfirmTrainerPaidEvent({required this.expenseId});
}
