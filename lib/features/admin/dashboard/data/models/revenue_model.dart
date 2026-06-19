import '../../domain/entities/revenue.dart';

class RevenueModel {
  final double paymentsCollected;
  final double paymentsGrowth;
  final double monthlyRevenue;
  final double monthlyRevenueVsLastMonth;
  final double membershipDue;
  final double ptDue;
  final double monthlyExpense;

  const RevenueModel({required this.paymentsCollected, required this.paymentsGrowth,
    required this.monthlyRevenue, required this.monthlyRevenueVsLastMonth,
    required this.membershipDue, required this.ptDue, required this.monthlyExpense});

  factory RevenueModel.fromJson(Map<String, dynamic> json) => RevenueModel(
    paymentsCollected: (json['paymentsCollected'] ?? 0).toDouble(),
    paymentsGrowth: (json['paymentsGrowth'] ?? 0).toDouble(),
    monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
    monthlyRevenueVsLastMonth: (json['monthlyRevenueVsLastMonth'] ?? 0).toDouble(),
    membershipDue: (json['membershipDue'] ?? 0).toDouble(),
    ptDue: (json['ptDue'] ?? 0).toDouble(),
    monthlyExpense: (json['monthlyExpense'] ?? 0).toDouble(),
  );

  Revenue toEntity() => Revenue(paymentsCollected: paymentsCollected,
      paymentsGrowth: paymentsGrowth, monthlyRevenue: monthlyRevenue,
      monthlyRevenueVsLastMonth: monthlyRevenueVsLastMonth,
      membershipDue: membershipDue, ptDue: ptDue, monthlyExpense: monthlyExpense);
}