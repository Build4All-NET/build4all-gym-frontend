import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_stats_entity.dart';
import '../../domain/repositories/admin_expenses_repository.dart';
import '../services/admin_expenses_remote_service.dart';
import '../models/create_expense_request_model.dart';
import '../models/update_expense_request_model.dart';

class AdminExpensesRepositoryImpl implements AdminExpensesRepository {
  final AdminExpensesRemoteDatasource remoteDatasource;

  AdminExpensesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ExpenseStatsEntity> getStats() async {
    final model = await remoteDatasource.getStats();
    return model.toEntity();
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(
      {int? branchId, String? category, String? search}) async {
    final models = await remoteDatasource.getExpenses(
        branchId: branchId, category: category, search: search);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() => remoteDatasource.getCategories();

  @override
  Future<void> createExpense(CreateExpenseRequestModel request) =>
      remoteDatasource.createExpense(request);

  @override
  Future<void> updateExpense(int expenseId, UpdateExpenseRequestModel request) =>
      remoteDatasource.updateExpense(expenseId, request);

  @override
  Future<void> deleteExpense(int expenseId) =>
      remoteDatasource.deleteExpense(expenseId);
}
