import '../../domain/entities/employee_checkin_row_entity.dart';

class EmployeeCheckinRowModel {
  final int employeeId;
  final String employeeName;
  final String employeeType;
  final bool isLinked;
  final int? employeeCheckinId;
  final String status;
  final String? method;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;

  const EmployeeCheckinRowModel({
    required this.employeeId,
    required this.employeeName,
    required this.employeeType,
    required this.isLinked,
    this.employeeCheckinId,
    required this.status,
    this.method,
    this.checkinTime,
    this.checkoutTime,
  });

  factory EmployeeCheckinRowModel.fromJson(Map<String, dynamic> json) {
    return EmployeeCheckinRowModel(
      employeeId: (json['employeeId'] as num).toInt(),
      employeeName: json['employeeName'] as String? ?? 'Unknown',
      employeeType: json['employeeType'] as String? ?? 'other',
      isLinked: json['isLinked'] as bool? ?? false,
      employeeCheckinId: (json['employeeCheckinId'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'NOT_CHECKED_IN',
      method: json['method'] as String?,
      checkinTime: json['checkinTime'] != null ? DateTime.parse(json['checkinTime'] as String) : null,
      checkoutTime: json['checkoutTime'] != null ? DateTime.parse(json['checkoutTime'] as String) : null,
    );
  }

  EmployeeCheckinRowEntity toEntity() => EmployeeCheckinRowEntity(
        employeeId: employeeId,
        employeeName: employeeName,
        employeeType: employeeType,
        isLinked: isLinked,
        employeeCheckinId: employeeCheckinId,
        status: status,
        method: method,
        checkinTime: checkinTime,
        checkoutTime: checkoutTime,
      );
}
