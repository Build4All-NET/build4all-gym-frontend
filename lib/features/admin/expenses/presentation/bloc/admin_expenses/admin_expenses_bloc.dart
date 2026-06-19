import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/expense_stats_entity.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/usecases/admin_expenses_usecases.dart';

part 'admin_expenses_event.dart';
part 'admin_expenses_state.dart';

class AdminExpensesBloc extends Bloc<AdminExpensesEvent, AdminExpensesState> {
  final GetExpenseStatsUseCase getStats;
  final GetExpensesUseCase getExpenses;
  final GetExpenseCategoriesUseCase getCategories;
  final DeleteExpenseUseCase deleteExpense;

  AdminExpensesBloc({
    required this.getStats,
    required this.getExpenses,
    required this.getCategories,
    required this.deleteExpense,
  }) : super(AdminExpensesInitial()) {
    on<LoadAdminExpensesEvent>(_onLoad);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<FilterByBranchEvent>(_onFilterByBranch);
    on<SearchExpensesEvent>(_onSearch);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<RefreshExpensesEvent>(_onRefresh);
  }

  // ── Load (initial) ─────────────────────────────────────────────────────────
  Future<void> _onLoad(
    LoadAdminExpensesEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    emit(AdminExpensesLoading());
    try {
      final results = await Future.wait([
        getStats(),
        getExpenses(),
        getCategories(),
      ]);
      emit(AdminExpensesLoaded(
        stats: results[0] as ExpenseStatsEntity,
        expenses: results[1] as List<ExpenseEntity>,
        categories: results[2] as List<String>,
      ));
    } catch (e) {
      emit(AdminExpensesError(message: _extractMessage(e)));
    }
  }

  // ── Filter by category ─────────────────────────────────────────────────────
  // NOTE: built directly (not via copyWith) because copyWith's `??` fallback
  // can't tell "field not provided" from "explicitly clear to null" — that
  // would make clearing a filter back to "All" silently keep the old value.
  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    final current = state;
    if (current is! AdminExpensesLoaded) return;

    try {
      final expenses = await getExpenses(
        branchId: current.activeBranchFilter,
        category: event.category,
        search: current.activeSearch,
      );
      emit(AdminExpensesLoaded(
        stats: current.stats,
        expenses: expenses,
        categories: current.categories,
        activeCategoryFilter: event.category,
        activeBranchFilter: current.activeBranchFilter,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(AdminExpensesError(message: _extractMessage(e)));
    }
  }

  // ── Filter by branch ───────────────────────────────────────────────────────
  Future<void> _onFilterByBranch(
    FilterByBranchEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    final current = state;
    if (current is! AdminExpensesLoaded) return;

    try {
      final expenses = await getExpenses(
        branchId: event.branchId,
        category: current.activeCategoryFilter,
        search: current.activeSearch,
      );
      emit(AdminExpensesLoaded(
        stats: current.stats,
        expenses: expenses,
        categories: current.categories,
        activeCategoryFilter: current.activeCategoryFilter,
        activeBranchFilter: event.branchId,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(AdminExpensesError(message: _extractMessage(e)));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Future<void> _onSearch(
    SearchExpensesEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    final current = state;
    if (current is! AdminExpensesLoaded) return;

    try {
      final query = event.query.isEmpty ? null : event.query;
      final expenses = await getExpenses(
        branchId: current.activeBranchFilter,
        category: current.activeCategoryFilter,
        search: query,
      );
      emit(AdminExpensesLoaded(
        stats: current.stats,
        expenses: expenses,
        categories: current.categories,
        activeCategoryFilter: current.activeCategoryFilter,
        activeBranchFilter: current.activeBranchFilter,
        activeSearch: query,
      ));
    } catch (e) {
      emit(AdminExpensesError(message: _extractMessage(e)));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    final current = state;
    if (current is! AdminExpensesLoaded) return;

    emit(current.copyWith(
      isDeletingExpense: true,
      deletingExpenseId: event.expenseId,
    ));

    try {
      await deleteExpense(event.expenseId);
      add(RefreshExpensesEvent());
    } catch (e) {
      emit(current.copyWith(isDeletingExpense: false, deletingExpenseId: null));
      emit(AdminExpensesError(message: _extractMessage(e)));
      emit(current.copyWith(isDeletingExpense: false, deletingExpenseId: null));
    }
  }

  // ── Refresh (after create/update) ─────────────────────────────────────────
  Future<void> _onRefresh(
    RefreshExpensesEvent event,
    Emitter<AdminExpensesState> emit,
  ) async {
    final current = state;
    final currentCategory =
        current is AdminExpensesLoaded ? current.activeCategoryFilter : null;
    final currentBranch =
        current is AdminExpensesLoaded ? current.activeBranchFilter : null;
    final currentSearch =
        current is AdminExpensesLoaded ? current.activeSearch : null;

    try {
      final results = await Future.wait([
        getStats(),
        getExpenses(
          branchId: currentBranch,
          category: currentCategory,
          search: currentSearch,
        ),
        getCategories(),
      ]);
      emit(AdminExpensesLoaded(
        stats: results[0] as ExpenseStatsEntity,
        expenses: results[1] as List<ExpenseEntity>,
        categories: results[2] as List<String>,
        activeCategoryFilter: currentCategory,
        activeBranchFilter: currentBranch,
        activeSearch: currentSearch,
      ));
    } catch (e) {
      emit(AdminExpensesError(message: _extractMessage(e)));
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.replaceFirst('Exception: ', '');
    return msg;
  }
}
