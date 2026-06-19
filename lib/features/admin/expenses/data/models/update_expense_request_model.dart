import 'package:intl/intl.dart';

class UpdateExpenseRequestModel {
  final String title;
  final String? description;
  final double amount;
  final DateTime expenseDate;
  final String category;
  final int branchId;

  const UpdateExpenseRequestModel({
    required this.title,
    this.description,
    required this.amount,
    required this.expenseDate,
    required this.category,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'expenseDate': DateFormat('yyyy-MM-dd').format(expenseDate),
      'category': category,
      'branchId': branchId,
    };
  }
}
