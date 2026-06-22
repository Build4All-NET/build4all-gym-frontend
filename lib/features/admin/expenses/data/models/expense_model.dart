import '../../domain/entities/expense_entity.dart';

class ExpenseModel {
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
  final String? sourceType;
  final bool trainerPaid;
  final DateTime createdAt;

  const ExpenseModel({
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: (json['expenseId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expenseDate'] as String),
      category: json['category'] as String,
      branchId: (json['branchId'] as num).toInt(),
      branchName: json['branchName'] as String? ?? '',
      trainerId: (json['trainerId'] as num?)?.toInt(),
      trainerName: json['trainerName'] as String?,
      sourceType: json['sourceType'] as String?,
      trainerPaid: json['trainerPaid'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ExpenseEntity toEntity() => ExpenseEntity(
        expenseId: expenseId,
        title: title,
        description: description,
        amount: amount,
        expenseDate: expenseDate,
        category: category,
        branchId: branchId,
        branchName: branchName,
        trainerId: trainerId,
        trainerName: trainerName,
        sourceType: sourceType,
        trainerPaid: trainerPaid,
        createdAt: createdAt,
      );
}
