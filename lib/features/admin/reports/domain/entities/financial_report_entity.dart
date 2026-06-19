import 'report_point_entity.dart';

/// Financial report for a selected date range (Reports → Financial tab).
class FinancialReportEntity {
  final double collected;
  final double expense;
  final double net;
  final double membershipDue;
  final double ptDue;
  final List<ReportPointEntity> collectedSeries;
  final List<ReportPointEntity> expenseByCategory;

  const FinancialReportEntity({
    required this.collected,
    required this.expense,
    required this.net,
    required this.membershipDue,
    required this.ptDue,
    required this.collectedSeries,
    required this.expenseByCategory,
  });
}
