import 'package:intl/intl.dart';

class UpdateExpenseRequestModel {
  final String title;
  final String? description;
  final double amount;
  final DateTime expenseDate;
  final String category;
  final int branchId;
  // Always sent (even as null) so the owner can switch a salary expense
  // between "this trainer" and "Other" on edit — the backend applies this
  // field unconditionally, unlike the rest of this request.
  final int? trainerId;

  const UpdateExpenseRequestModel({
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
      'description': description,
      'amount': amount,
      'expenseDate': DateFormat('yyyy-MM-dd').format(expenseDate),
      'category': category,
      'branchId': branchId,
      'trainerId': trainerId,
    };
  }
}
