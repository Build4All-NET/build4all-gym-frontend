import '../../domain/entities/membership_request_entity.dart';

class MembershipRequestCardModel {
  final int requestId;
  final String memberName;
  final String memberEmail;
  final String planName;
  final String branchName;
  final double totalAmount;
  final String status;
  final String requestedAt;

  MembershipRequestCardModel({
    required this.requestId,
    required this.memberName,
    required this.memberEmail,
    required this.planName,
    required this.branchName,
    required this.totalAmount,
    required this.status,
    required this.requestedAt,
  });

  factory MembershipRequestCardModel.fromJson(Map<String, dynamic> json) {
    return MembershipRequestCardModel(
      requestId:   json['requestId'] as int,
      memberName:  json['memberName'] as String? ?? '',
      memberEmail: json['memberEmail'] as String? ?? '',
      planName:    json['planName'] as String? ?? '',
      branchName:  json['branchName'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status:      json['status'] as String? ?? 'PENDING',
      requestedAt: json['requestedAt'] as String? ?? '',
    );
  }

  MembershipRequestEntity toEntity() => MembershipRequestEntity(
        requestId:   requestId,
        memberName:  memberName,
        memberEmail: memberEmail,
        planName:    planName,
        branchName:  branchName,
        totalAmount: totalAmount,
        status:      status,
        requestedAt: requestedAt,
      );
}
