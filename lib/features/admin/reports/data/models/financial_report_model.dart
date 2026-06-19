import '../../domain/entities/financial_report_entity.dart';
import 'report_point_model.dart';

class FinancialReportModel {
  final double collected;
  final double expense;
  final double net;
  final double membershipDue;
  final double ptDue;
  final List<ReportPointModel> collectedSeries;
  final List<ReportPointModel> expenseByCategory;

  const FinancialReportModel({
    required this.collected,
    required this.expense,
    required this.net,
    required this.membershipDue,
    required this.ptDue,
    required this.collectedSeries,
    required this.expenseByCategory,
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    List<ReportPointModel> points(String key) =>
        ((json[key] as List<dynamic>?) ?? const [])
            .map((e) => ReportPointModel.fromJson(e as Map<String, dynamic>))
            .toList();

    double d(String key) => (json[key] as num?)?.toDouble() ?? 0.0;

    return FinancialReportModel(
      collected: d('collected'),
      expense: d('expense'),
      net: d('net'),
      membershipDue: d('membershipDue'),
      ptDue: d('ptDue'),
      collectedSeries: points('collectedSeries'),
      expenseByCategory: points('expenseByCategory'),
    );
  }

  FinancialReportEntity toEntity() => FinancialReportEntity(
        collected: collected,
        expense: expense,
        net: net,
        membershipDue: membershipDue,
        ptDue: ptDue,
        collectedSeries: collectedSeries.map((e) => e.toEntity()).toList(),
        expenseByCategory: expenseByCategory.map((e) => e.toEntity()).toList(),
      );
}
