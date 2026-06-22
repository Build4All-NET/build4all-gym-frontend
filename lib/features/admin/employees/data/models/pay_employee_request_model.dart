import 'package:intl/intl.dart';

class PayEmployeeRequestModel {
  /// Null means "use the employee's configured salary" — the backend
  /// resolves the default, the client never guesses it.
  final double? amount;
  final DateTime? paymentDate;
  final String? note;

  const PayEmployeeRequestModel({
    this.amount,
    this.paymentDate,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'paymentDate': DateFormat('yyyy-MM-dd').format(paymentDate!),
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}
