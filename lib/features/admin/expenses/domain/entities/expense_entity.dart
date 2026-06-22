class ExpenseEntity {
  final int expenseId;
  final String title;
  final String? description;
  final double amount;
  final DateTime expenseDate;
  final String category;
  final int branchId;
  final String branchName;
  final int? trainerId;
  final String? trainerName;
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
    this.trainerId,
    this.trainerName,
    required this.createdAt,
  });
}
