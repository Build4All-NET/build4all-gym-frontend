import '../../domain/entities/employee_checkin_action_entity.dart';

class EmployeeCheckinActionModel {
  final int employeeCheckinId;
  final int employeeId;
  final String employeeName;
  final String action;
  final String status;
  final DateTime checkinTime;
  final DateTime? checkoutTime;

  const EmployeeCheckinActionModel({
    required this.employeeCheckinId,
    required this.employeeId,
    required this.employeeName,
    required this.action,
    required this.status,
    required this.checkinTime,
    this.checkoutTime,
  });

  factory EmployeeCheckinActionModel.fromJson(Map<String, dynamic> json) {
    return EmployeeCheckinActionModel(
      employeeCheckinId: (json['employeeCheckinId'] as num).toInt(),
      employeeId: (json['employeeId'] as num).toInt(),
      employeeName: json['employeeName'] as String? ?? 'Unknown',
      action: json['action'] as String,
      status: json['status'] as String,
      checkinTime: DateTime.parse(json['checkinTime'] as String),
      checkoutTime: json['checkoutTime'] != null ? DateTime.parse(json['checkoutTime'] as String) : null,
    );
  }

  EmployeeCheckinActionEntity toEntity() => EmployeeCheckinActionEntity(
        employeeCheckinId: employeeCheckinId,
        employeeId: employeeId,
        employeeName: employeeName,
        action: action,
        status: status,
        checkinTime: checkinTime,
        checkoutTime: checkoutTime,
      );
}
