part of 'admin_expenses_bloc.dart';

abstract class AdminExpensesState {}

class AdminExpensesInitial extends AdminExpensesState {}

class AdminExpensesLoading extends AdminExpensesState {}

class AdminExpensesLoaded extends AdminExpensesState {
  final ExpenseStatsEntity stats;
  final List<ExpenseEntity> expenses;
  final List<String> categories; // built-in + any custom category the owner created
  final String? activeCategoryFilter;
  final int? activeBranchFilter;
  final String? activeSearch;
  final bool isDeletingExpense;
  final int? deletingExpenseId; // shows spinner on specific card
  final bool isConfirmingTrainerPaid;
  final int? confirmingExpenseId; // shows spinner on specific card

  AdminExpensesLoaded({
    required this.stats,
    required this.expenses,
    required this.categories,
    this.activeCategoryFilter,
    this.activeBranchFilter,
    this.activeSearch,
    this.isDeletingExpense = false,
    this.deletingExpenseId,
    this.isConfirmingTrainerPaid = false,
    this.confirmingExpenseId,
  });

  AdminExpensesLoaded copyWith({
    ExpenseStatsEntity? stats,
    List<ExpenseEntity>? expenses,
    List<String>? categories,
    String? activeCategoryFilter,
    int? activeBranchFilter,
    String? activeSearch,
    bool? isDeletingExpense,
    int? deletingExpenseId,
    bool? isConfirmingTrainerPaid,
    int? confirmingExpenseId,
  }) {
    return AdminExpensesLoaded(
      stats: stats ?? this.stats,
      expenses: expenses ?? this.expenses,
      categories: categories ?? this.categories,
      activeCategoryFilter: activeCategoryFilter ?? this.activeCategoryFilter,
      activeBranchFilter: activeBranchFilter ?? this.activeBranchFilter,
      activeSearch: activeSearch ?? this.activeSearch,
      isDeletingExpense: isDeletingExpense ?? this.isDeletingExpense,
      deletingExpenseId: deletingExpenseId ?? this.deletingExpenseId,
      isConfirmingTrainerPaid: isConfirmingTrainerPaid ?? this.isConfirmingTrainerPaid,
      confirmingExpenseId: confirmingExpenseId ?? this.confirmingExpenseId,
    );
  }
}

class AdminExpensesError extends AdminExpensesState {
  final String message;
  AdminExpensesError({required this.message});
}
