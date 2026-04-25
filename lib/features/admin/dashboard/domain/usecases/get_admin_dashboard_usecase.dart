import '../../../../../core/error/failures.dart';
import '../entities/admin_dashboard_summary.dart';
import '../repositories/admin_dashboard_repository.dart';

class GetAdminDashboardUseCase {
  final AdminDashboardRepository repository;

  GetAdminDashboardUseCase({required this.repository});

  Future<({AdminDashboardSummary? data, Failure? failure})> call({
    String period = 'today',
  }) {
    return repository.getDashboardSummary(period: period);
  }
}