// FILE: lib/features/admin/balance_sheet/presentation/cubit/balance_sheet_cubit.dart
//
// Composition cubit for the Balance Sheet screen — pulls full invoice and
// expense lists from the already-existing use cases and applies a
// client-side date filter (no new backend endpoints needed). Collection is
// the sum of paidAmount (money actually collected), matching the dashboard's
// "Collected" terminology, not the invoice totalAmount.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expenses/domain/entities/expense_entity.dart';
import '../../../expenses/domain/usecases/admin_expenses_usecases.dart';
import '../../../invoices/domain/entities/admin_invoice_entity.dart';
import '../../../invoices/domain/usecases/admin_invoice_usecases.dart';

enum BalanceSheetRange { today, thisWeek, thisMonth, thisYear, allTime, custom }

abstract class BalanceSheetState {}

class BalanceSheetInitial extends BalanceSheetState {}

class BalanceSheetLoading extends BalanceSheetState {}

class BalanceSheetError extends BalanceSheetState {
  final String message;
  BalanceSheetError(this.message);
}

class BalanceSheetLoaded extends BalanceSheetState {
  final List<AdminInvoiceSummaryEntity> allInvoices;
  final List<ExpenseEntity> allExpenses;

  final BalanceSheetRange range;
  final DateTimeRange? customRange;

  final List<AdminInvoiceSummaryEntity> invoices; // filtered
  final List<ExpenseEntity> expenses; // filtered
  final double totalCollection;
  final double totalExpense;

  BalanceSheetLoaded({
    required this.allInvoices,
    required this.allExpenses,
    required this.range,
    required this.customRange,
    required this.invoices,
    required this.expenses,
    required this.totalCollection,
    required this.totalExpense,
  });

  double get netProfit => totalCollection - totalExpense;
}

class _DateBounds {
  final DateTime start; // inclusive
  final DateTime end; // exclusive
  _DateBounds(this.start, this.end);
}

class BalanceSheetCubit extends Cubit<BalanceSheetState> {
  final GetExpensesUseCase _getExpenses;
  final ListInvoicesUseCase _listInvoices;

  BalanceSheetCubit({
    required GetExpensesUseCase getExpenses,
    required ListInvoicesUseCase listInvoices,
  })  : _getExpenses = getExpenses,
        _listInvoices = listInvoices,
        super(BalanceSheetInitial());

  Future<void> load() => _fetchAndEmit(BalanceSheetRange.thisMonth, null);

  // Re-fetches from the network but keeps whatever date filter is active.
  Future<void> refresh() {
    final current = state;
    final range = current is BalanceSheetLoaded ? current.range : BalanceSheetRange.thisMonth;
    final customRange = current is BalanceSheetLoaded ? current.customRange : null;
    return _fetchAndEmit(range, customRange);
  }

  Future<void> _fetchAndEmit(BalanceSheetRange range, DateTimeRange? customRange) async {
    emit(BalanceSheetLoading());
    try {
      final results = await Future.wait([
        _getExpenses(),
        _listInvoices(size: 1000),
      ]);
      final expenses = results[0] as List<ExpenseEntity>;
      final invoices = results[1] as List<AdminInvoiceSummaryEntity>;
      _emitFiltered(
        allInvoices: invoices,
        allExpenses: expenses,
        range: range,
        customRange: customRange,
      );
    } catch (e) {
      emit(BalanceSheetError(_extractMessage(e)));
    }
  }

  void setRange(BalanceSheetRange range, {DateTimeRange? customRange}) {
    final current = state;
    if (current is! BalanceSheetLoaded) return;
    _emitFiltered(
      allInvoices: current.allInvoices,
      allExpenses: current.allExpenses,
      range: range,
      customRange: customRange ?? current.customRange,
    );
  }

  void _emitFiltered({
    required List<AdminInvoiceSummaryEntity> allInvoices,
    required List<ExpenseEntity> allExpenses,
    required BalanceSheetRange range,
    DateTimeRange? customRange,
  }) {
    final bounds = _boundsFor(range, customRange);

    final invoices = allInvoices.where((inv) {
      final d = DateTime.tryParse(inv.invoiceDate);
      if (d == null) return false;
      return !d.isBefore(bounds.start) && d.isBefore(bounds.end);
    }).toList();

    final expenses = allExpenses.where((e) {
      return !e.expenseDate.isBefore(bounds.start) && e.expenseDate.isBefore(bounds.end);
    }).toList();

    final totalCollection = invoices.fold<double>(0, (sum, i) => sum + i.paidAmount);
    final totalExpense = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    emit(BalanceSheetLoaded(
      allInvoices: allInvoices,
      allExpenses: allExpenses,
      range: range,
      customRange: customRange,
      invoices: invoices,
      expenses: expenses,
      totalCollection: totalCollection,
      totalExpense: totalExpense,
    ));
  }

  _DateBounds _boundsFor(BalanceSheetRange range, DateTimeRange? customRange) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    switch (range) {
      case BalanceSheetRange.today:
        return _DateBounds(todayStart, todayStart.add(const Duration(days: 1)));

      case BalanceSheetRange.thisWeek:
        final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1));
        return _DateBounds(weekStart, weekStart.add(const Duration(days: 7)));

      case BalanceSheetRange.thisMonth:
        return _DateBounds(
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1),
        );

      case BalanceSheetRange.thisYear:
        return _DateBounds(DateTime(now.year, 1, 1), DateTime(now.year + 1, 1, 1));

      case BalanceSheetRange.allTime:
        return _DateBounds(DateTime(2000), DateTime(now.year + 1, 1, 1));

      case BalanceSheetRange.custom:
        if (customRange == null) {
          return _DateBounds(DateTime(2000), DateTime(now.year + 1, 1, 1));
        }
        final start = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
        final end = DateTime(customRange.end.year, customRange.end.month, customRange.end.day)
            .add(const Duration(days: 1));
        return _DateBounds(start, end);
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.replaceFirst('Exception: ', '') : msg;
  }
}