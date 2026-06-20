part of 'admin_reports_bloc.dart';

abstract class AdminReportsState {
  const AdminReportsState();
}

class AdminReportsInitial extends AdminReportsState {
  const AdminReportsInitial();
}

class AdminReportsLoading extends AdminReportsState {
  const AdminReportsLoading();
}

class AdminReportsLoaded extends AdminReportsState {
  final FinancialReportEntity financial;
  final AttendanceReportEntity attendance;
  final ReportPeriod period;
  final DateTime from;
  final DateTime to;

  const AdminReportsLoaded({
    required this.financial,
    required this.attendance,
    required this.period,
    required this.from,
    required this.to,
  });
}

class AdminReportsError extends AdminReportsState {
  final String message;
  const AdminReportsError(this.message);
}
