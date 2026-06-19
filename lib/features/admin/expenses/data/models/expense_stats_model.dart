import '../../domain/entities/expense_stats_entity.dart';

class ExpenseStatsModel {
  final double totalThisMonth;
  final double totalAllTime;
  final int countThisMonth;

  const ExpenseStatsModel({
    required this.totalThisMonth,
    required this.totalAllTime,
    required this.countThisMonth,
  });

  factory ExpenseStatsModel.fromJson(Map<String, dynamic> json) {
    return ExpenseStatsModel(
      totalThisMonth: (json['totalThisMonth'] as num).toDouble(),
      totalAllTime: (json['totalAllTime'] as num).toDouble(),
      countThisMonth: (json['countThisMonth'] as num).toInt(),
    );
  }

  ExpenseStatsEntity toEntity() => ExpenseStatsEntity(
        totalThisMonth: totalThisMonth,
        totalAllTime: totalAllTime,
        countThisMonth: countThisMonth,
      );
}
