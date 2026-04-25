import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();
  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardSummary data;
  final String period;
  const AdminDashboardLoaded({required this.data, required this.period});
  @override
  List<Object?> get props => [data, period];
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  final String period;
  const AdminDashboardError({required this.message, required this.period});
  @override
  List<Object?> get props => [message, period];
}