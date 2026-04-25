import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/admin_dashboard_summary.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../services/admin_dashboard_remote_service.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDatasource remoteDatasource;

  AdminDashboardRepositoryImpl({required this.remoteDatasource});

  @override
  Future<({AdminDashboardSummary? data, Failure? failure})> getDashboardSummary({
    String period = 'today',
  }) async {
    try {
      final model = await remoteDatasource.getDashboardSummary(period: period);
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (data: null, failure: const AuthFailure('Session expired. Please log in again.'));
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }
}