import '../../../../../core/error/failures.dart';
import '../entities/admin_dashboard_summary.dart';

abstract class AdminDashboardRepository {
  Future<({AdminDashboardSummary? data, Failure? failure})> getDashboardSummary({
    String period = 'today',
    String revenuePeriod = 'this_month',
    String? revenueStartDate,
    String? revenueEndDate,
  });
}