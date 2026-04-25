import 'package:equatable/equatable.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();
  @override
  List<Object?> get props => [];
}

class AdminDashboardLoadRequested extends AdminDashboardEvent {
  final String period;
  const AdminDashboardLoadRequested({this.period = 'today'});
  @override
  List<Object?> get props => [period];
}

class AdminDashboardRefreshRequested extends AdminDashboardEvent {
  final String period;
  const AdminDashboardRefreshRequested({this.period = 'today'});
  @override
  List<Object?> get props => [period];
}

class AdminDashboardPeriodChanged extends AdminDashboardEvent {
  final String period; // 'today', 'week', 'month'
  const AdminDashboardPeriodChanged({required this.period});
  @override
  List<Object?> get props => [period];
}