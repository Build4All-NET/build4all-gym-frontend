import '../entities/expense_entity.dart';
import '../entities/expense_stats_entity.dart';
import '../repositories/admin_expenses_repository.dart';
import '../../data/models/create_expense_request_model.dart';
import '../../data/models/update_expense_request_model.dart';

class GetExpenseStatsUseCase {
  final AdminExpensesRepository repository;
  GetExpenseStatsUseCase({required this.repository});
  Future<ExpenseStatsEntity> call() => repository.getStats();
}

class GetExpensesUseCase {
  final AdminExpensesRepository repository;
  GetExpensesUseCase({required this.repository});
  Future<List<ExpenseEntity>> call({int? branchId, String? category, String? search}) =>
      repository.getExpenses(branchId: branchId, category: category, search: search);
}

class GetExpenseCategoriesUseCase {
  final AdminExpensesRepository repository;
  GetExpenseCategoriesUseCase({required this.repository});
  Future<List<String>> call() => repository.getCategories();
}

class CreateExpenseUseCase {
  final AdminExpensesRepository repository;
  CreateExpenseUseCase({required this.repository});
  Future<void> call(CreateExpenseRequestModel request) =>
      repository.createExpense(request);
}

class UpdateExpenseUseCase {
  final AdminExpensesRepository repository;
  UpdateExpenseUseCase({required this.repository});
  Future<void> call(int expenseId, UpdateExpenseRequestModel request) =>
      repository.updateExpense(expenseId, request);
}

class DeleteExpenseUseCase {
  final AdminExpensesRepository repository;
  DeleteExpenseUseCase({required this.repository});
  Future<void> call(int expenseId) => repository.deleteExpense(expenseId);
}
