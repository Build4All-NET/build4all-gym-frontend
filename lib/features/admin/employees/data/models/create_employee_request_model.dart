import 'package:intl/intl.dart';

class CreateEmployeeRequestModel {
  final int? linkedUserId;
  final String? fullName;
  final String? phone;
  final String? email;
  final String employeeType;
  final int branchId;
  final double salaryAmount;
  final String payFrequency;
  final DateTime? hireDate;
  final String? notes;

  const CreateEmployeeRequestModel({
    this.linkedUserId,
    this.fullName,
    this.phone,
    this.email,
    required this.employeeType,
    required this.branchId,
    required this.salaryAmount,
    required this.payFrequency,
    this.hireDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (linkedUserId != null) 'linkedUserId': linkedUserId,
      if (fullName != null && fullName!.isNotEmpty) 'fullName': fullName,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (email != null && email!.isNotEmpty) 'email': email,
      'employeeType': employeeType,
      'branchId': branchId,
      'salaryAmount': salaryAmount,
      'payFrequency': payFrequency,
      if (hireDate != null) 'hireDate': DateFormat('yyyy-MM-dd').format(hireDate!),
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}
