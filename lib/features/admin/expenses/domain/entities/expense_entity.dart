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

  /// "PT_SESSION" / "CLASS_BOOKING" when this row was auto-recorded from a
  /// trainer commission; null for manually entered expenses.
  final String? sourceType;

  /// Always true for manually entered expenses. For a commission row, true
  /// once the owner has confirmed the commission was actually paid to the
  /// trainer — until then it doesn't count toward expense totals/reports or
  /// the trainer's Income screen.
  final bool trainerPaid;
  final DateTime createdAt;

  bool get isAutoRecorded => sourceType != null;

  /// A commission row the owner hasn't confirmed paying out yet.
  bool get isPendingTrainerPayout => category == 'commission' && !trainerPaid;

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
    this.sourceType,
    this.trainerPaid = true,
    required this.createdAt,
  });
}
