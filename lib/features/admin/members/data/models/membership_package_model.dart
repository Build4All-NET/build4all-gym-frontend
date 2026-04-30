// =============================================================================
// FILE: membership_package_model.dart
// PATH: lib/features/admin/members/data/models/membership_package_model.dart
// LAYER: Data Layer → Models
// TASK: GA-267
// =============================================================================

class MembershipPackageModel {
  final String?  planName;
  final double   totalAmount;
  final double   discountAmount;
  final String?  purchaseDate;   // ISO-8601 date string
  final double   paidAmount;
  final double   dueAmount;
  final int      remainingDays;

  const MembershipPackageModel({
    this.planName,
    required this.totalAmount,
    required this.discountAmount,
    this.purchaseDate,
    required this.paidAmount,
    required this.dueAmount,
    required this.remainingDays,
  });

  factory MembershipPackageModel.fromJson(Map<String, dynamic> json) {
    return MembershipPackageModel(
      planName:      json['planName']      as String?,
      totalAmount:   (json['totalAmount']   as num?)?.toDouble() ?? 0.0,
      discountAmount:(json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      purchaseDate:  json['purchaseDate']  as String?,
      paidAmount:    (json['paidAmount']    as num?)?.toDouble() ?? 0.0,
      dueAmount:     (json['dueAmount']     as num?)?.toDouble() ?? 0.0,
      remainingDays: json['remainingDays'] as int?   ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'planName':       planName,
    'totalAmount':    totalAmount,
    'discountAmount': discountAmount,
    'purchaseDate':   purchaseDate,
    'paidAmount':     paidAmount,
    'dueAmount':      dueAmount,
    'remainingDays':  remainingDays,
  };
}