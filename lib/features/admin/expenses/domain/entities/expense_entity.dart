class ExpenseEntity {
  final int expenseId;
  final String title;
  final String? description;
  final double amount;
  final DateTime expenseDate;
  final String category;
  final int branchId;
  final String branchName;
  final DateTime createdAt;

  const ExpenseEntity({
    required this.expenseId,
    required this.title,
    this.description,
    required this.amount,
    required this.expenseDate,
    required this.category,
    required this.branchId,
    required this.branchName,
    required this.createdAt,
  });
}
