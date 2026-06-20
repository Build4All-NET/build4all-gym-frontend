import 'package:intl/intl.dart';

class CreateExpenseRequestModel {
  final String title;
  final String? description;
  final double amount;
  final DateTime expenseDate;
  final String category;
  final int branchId;
  final int? trainerId;

  const CreateExpenseRequestModel({
    required this.title,
    this.description,
    required this.amount,
    required this.expenseDate,
    required this.category,
    required this.branchId,
    this.trainerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null && description!.isNotEmpty) 'description': description,
      'amount': amount,
      'expenseDate': DateFormat('yyyy-MM-dd').format(expenseDate),
      'category': category,
      'branchId': branchId,
      if (trainerId != null) 'trainerId': trainerId,
    };
  }
}
