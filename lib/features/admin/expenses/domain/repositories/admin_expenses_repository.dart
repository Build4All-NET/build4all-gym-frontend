import '../entities/expense_entity.dart';
import '../entities/expense_stats_entity.dart';
import '../../data/models/create_expense_request_model.dart';
import '../../data/models/update_expense_request_model.dart';

abstract class AdminExpensesRepository {
  Future<ExpenseStatsEntity> getStats();
  Future<List<ExpenseEntity>> getExpenses({int? branchId, String? category, String? search});
  Future<List<String>> getCategories();
  Future<void> createExpense(CreateExpenseRequestModel request);
  Future<void> updateExpense(int expenseId, UpdateExpenseRequestModel request);
  Future<void> deleteExpense(int expenseId);
}
