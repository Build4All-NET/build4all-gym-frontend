import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/financial_report_entity.dart';
import '../../../domain/entities/attendance_report_entity.dart';
import '../../../domain/usecases/admin_reports_usecases.dart';

part 'admin_reports_event.dart';
part 'admin_reports_state.dart';

/// The selectable report periods. Ranges are resolved in [_resolveRange].
enum ReportPeriod { thisMonth, lastMonth, last3Months, custom }

class AdminReportsBloc extends Bloc<AdminReportsEvent, AdminReportsState> {
  final GetFinancialReportUseCase getFinancial;
  final GetAttendanceReportUseCase getAttendance;

  AdminReportsBloc({
    required this.getFinancial,
    required this.getAttendance,
  }) : super(const AdminReportsInitial()) {
    on<LoadReportsEvent>(_onLoad);
    on<ChangeReportPeriodEvent>(_onChangePeriod);
    on<RefreshReportsEvent>(_onRefresh);
  }

  Future<void> _onLoad(LoadReportsEvent event, Emitter<AdminReportsState> emit) async {
    await _fetch(emit, ReportPeriod.thisMonth);
  }

  Future<void> _onChangePeriod(
      ChangeReportPeriodEvent event, Emitter<AdminReportsState> emit) async {
    await _fetch(emit, event.period, customFrom: event.from, customTo: event.to);
  }

  Future<void> _onRefresh(
      RefreshReportsEvent event, Emitter<AdminReportsState> emit) async {
    final current = state;
    if (current is AdminReportsLoaded) {
      await _fetch(emit, current.period,
          customFrom: current.from, customTo: current.to, showLoading: false);
    } else {
      await _fetch(emit, ReportPeriod.thisMonth);
    }
  }

  Future<void> _fetch(
    Emitter<AdminReportsState> emit,
    ReportPeriod period, {
    DateTime? customFrom,
    DateTime? customTo,
    bool showLoading = true,
  }) async {
    final range = _resolveRange(period, customFrom, customTo);
    final from = range.$1;
    final to = range.$2;

    if (showLoading) emit(const AdminReportsLoading());
    try {
      final results = await Future.wait([
        getFinancial(from: from, to: to),
        getAttendance(from: from, to: to),
      ]);
      emit(AdminReportsLoaded(
        financial: results[0] as FinancialReportEntity,
        attendance: results[1] as AttendanceReportEntity,
        period: period,
        from: from,
        to: to,
      ));
    } catch (e) {
      emit(AdminReportsError(_extractMessage(e)));
    }
  }

  /// Maps a [ReportPeriod] to an inclusive [from, to] date range.
  (DateTime, DateTime) _resolveRange(
      ReportPeriod period, DateTime? customFrom, DateTime? customTo) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (period) {
      case ReportPeriod.thisMonth:
        return (DateTime(now.year, now.month, 1), today);
      case ReportPeriod.lastMonth:
        final firstOfThis = DateTime(now.year, now.month, 1);
        final lastMonthEnd = firstOfThis.subtract(const Duration(days: 1));
        final lastMonthStart = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);
        return (lastMonthStart, lastMonthEnd);
      case ReportPeriod.last3Months:
        final start = DateTime(now.year, now.month - 2, 1);
        return (start, today);
      case ReportPeriod.custom:
        final from = customFrom ?? DateTime(now.year, now.month, 1);
        final to = customTo ?? today;
        return from.isAfter(to) ? (to, from) : (from, to);
    }
  }

  String _extractMessage(Object e) =>
      e.toString().replaceFirst('Exception: ', '');
}
