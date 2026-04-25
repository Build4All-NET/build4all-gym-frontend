import '../../domain/entities/revenue.dart';

class RevenueModel {
  final double paymentsCollected;
  final double paymentsGrowth;
  final double monthlyRevenue;
  final double monthlyRevenueVsLastMonth;

  const RevenueModel({required this.paymentsCollected, required this.paymentsGrowth,
    required this.monthlyRevenue, required this.monthlyRevenueVsLastMonth});

  factory RevenueModel.fromJson(Map<String, dynamic> json) => RevenueModel(
    paymentsCollected: (json['paymentsCollected'] ?? 0).toDouble(),
    paymentsGrowth: (json['paymentsGrowth'] ?? 0).toDouble(),
    monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
    monthlyRevenueVsLastMonth: (json['monthlyRevenueVsLastMonth'] ?? 0).toDouble(),
  );

  Revenue toEntity() => Revenue(paymentsCollected: paymentsCollected,
      paymentsGrowth: paymentsGrowth, monthlyRevenue: monthlyRevenue,
      monthlyRevenueVsLastMonth: monthlyRevenueVsLastMonth);
}