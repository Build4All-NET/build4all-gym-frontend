import '../../domain/entities/member_membership_entity.dart';

class MemberMembershipModel extends MemberMembershipEntity {
  const MemberMembershipModel({
    required super.membershipId,
    required super.planId,
    required super.planName,
    required super.planType,
    required super.status,
    required super.paymentStatus,
    required super.startDate,
    required super.endDate,
    required super.remainingDays,
    required super.remainingVisits,
    required super.durationDays,
    required super.billingCycle,
    required super.price,
    required super.branchName,
    required super.autoRenewEnabled,
  });

  factory MemberMembershipModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberMembershipModel(
      membershipId: _parseRequiredInt(
        json['membershipId'],
        fieldName: 'membershipId',
      ),
      planId: _parseRequiredInt(
        json['planId'],
        fieldName: 'planId',
      ),
      planName: json['planName']?.toString() ?? '',
      planType: json['planType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      remainingDays: _parseInt(json['remainingDays']) ?? 0,
      remainingVisits: _parseInt(json['remainingVisits']),
      durationDays: _parseInt(json['durationDays']),
      billingCycle: json['billingCycle']?.toString(),
      price: _parseDouble(json['price']) ?? 0.0,
      branchName: json['branchName']?.toString(),
      autoRenewEnabled: _parseBool(json['autoRenewEnabled']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    final String dateValue = value.toString().trim();

    if (dateValue.isEmpty) {
      return null;
    }

    return DateTime.tryParse(dateValue);
  }

  static int _parseRequiredInt(
      dynamic value, {
        required String fieldName,
      }) {
    final int? parsedValue = _parseInt(value);

    if (parsedValue == null) {
      throw FormatException(
        'Invalid or missing $fieldName in membership response.',
      );
    }

    return parsedValue;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    return value.toString().toLowerCase() == 'true';
  }
}