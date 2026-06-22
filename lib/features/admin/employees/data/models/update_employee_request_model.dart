import 'package:intl/intl.dart';

class UpdateEmployeeRequestModel {
  final String? fullName;
  final String? phone;
  final String? email;
  final String? employeeType;
  final int? branchId;
  final double? salaryAmount;
  final String? payFrequency;
  final DateTime? hireDate;
  final String? status;
  final String? notes;

  const UpdateEmployeeRequestModel({
    this.fullName,
    this.phone,
    this.email,
    this.employeeType,
    this.branchId,
    this.salaryAmount,
    this.payFrequency,
    this.hireDate,
    this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (employeeType != null) 'employeeType': employeeType,
      if (branchId != null) 'branchId': branchId,
      if (salaryAmount != null) 'salaryAmount': salaryAmount,
      if (payFrequency != null) 'payFrequency': payFrequency,
      if (hireDate != null) 'hireDate': DateFormat('yyyy-MM-dd').format(hireDate!),
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}
