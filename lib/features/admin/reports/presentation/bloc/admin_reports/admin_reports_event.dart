part of 'admin_reports_bloc.dart';

abstract class AdminReportsEvent {
  const AdminReportsEvent();
}

/// First load — defaults to the current month.
class LoadReportsEvent extends AdminReportsEvent {
  const LoadReportsEvent();
}

/// Switch the active period. For [ReportPeriod.custom] pass [from] and [to].
class ChangeReportPeriodEvent extends AdminReportsEvent {
  final ReportPeriod period;
  final DateTime? from;
  final DateTime? to;
  const ChangeReportPeriodEvent(this.period, {this.from, this.to});
}

/// Re-fetch keeping the current period (pull-to-refresh).
class RefreshReportsEvent extends AdminReportsEvent {
  const RefreshReportsEvent();
}
