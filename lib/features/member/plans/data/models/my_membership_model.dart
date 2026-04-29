import '../../domain/entities/my_membership_entity.dart';

class MyMembershipModel {
  final int membershipId;
  final String planName;
  final String planType;
  final String status;
  final String startDate;
  final String endDate;
  final int remainingDays;
  final int? remainingVisits;
  final int frozenDaysUsed;
  final bool autoRenewEnabled;
  final String paymentStatus;

  MyMembershipModel({
    required this.membershipId,
    required this.planName,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    this.remainingVisits,
    required this.frozenDaysUsed,
    required this.autoRenewEnabled,
    required this.paymentStatus,
  });

  factory MyMembershipModel.fromJson(Map<String, dynamic> json) {
    return MyMembershipModel(
      membershipId: json['membershipId'] as int,
      planName: json['planName'] as String,
      planType: json['planType'] as String,
      status: json['status'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      remainingDays: json['remainingDays'] as int,
      remainingVisits: json['remainingVisits'] as int?,
      frozenDaysUsed: json['frozenDaysUsed'] as int,
      autoRenewEnabled: json['autoRenewEnabled'] as bool,
      paymentStatus: json['paymentStatus'] as String,
    );
  }

  MyMembershipEntity toEntity() {
    return MyMembershipEntity(
      membershipId: membershipId,
      planName: planName,
      planType: planType,
      status: status,
      startDate: startDate,
      endDate: endDate,
      remainingDays: remainingDays,
      remainingVisits: remainingVisits,
      frozenDaysUsed: frozenDaysUsed,
      autoRenewEnabled: autoRenewEnabled,
      paymentStatus: paymentStatus,
    );
  }
}