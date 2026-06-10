import '../../domain/entities/my_membership_entity.dart';

class MyMembershipModel {
  final int membershipId;

  /*
   * Needed for membership renewal.
   *
   * Comes from backend as planId.
   */
  final int planId;

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
    required this.planId,
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
      membershipId: (json['membershipId'] as num).toInt(),
      planId: (json['planId'] as num).toInt(),
      planName: json['planName'] as String,
      planType: json['planType'] as String,
      status: json['status'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      remainingDays: (json['remainingDays'] as num).toInt(),
      remainingVisits: json['remainingVisits'] == null
          ? null
          : (json['remainingVisits'] as num).toInt(),
      frozenDaysUsed: (json['frozenDaysUsed'] as num).toInt(),
      autoRenewEnabled: json['autoRenewEnabled'] as bool,
      paymentStatus: json['paymentStatus'] as String,
    );
  }

  MyMembershipEntity toEntity() {
    return MyMembershipEntity(
      membershipId: membershipId,
      planId: planId,
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