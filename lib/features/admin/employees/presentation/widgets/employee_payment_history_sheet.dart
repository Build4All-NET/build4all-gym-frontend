import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:build4allgym/core/currency/currency_cubit.dart';
import '../../../../../common/widgets/form_section_kit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/employee_payment_entity.dart';
import '../../domain/usecases/admin_employees_usecases.dart';
import '../../data/repositories/admin_employees_repository_impl.dart';
import '../../data/services/admin_employees_remote_service.dart';

class EmployeePaymentHistorySheet {
  static void show(BuildContext context, {required EmployeeEntity employee}) {
    final c = context.read<ThemeCubit>().state.tokens.colors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PaymentHistoryContent(employee: employee),
    );
  }
}

class _PaymentHistoryContent extends StatefulWidget {
  final EmployeeEntity employee;
  const _PaymentHistoryContent({required this.employee});

  @override
  State<_PaymentHistoryContent> createState() => _PaymentHistoryContentState();
}

class _PaymentHistoryContentState extends State<_PaymentHistoryContent> {
  final _useCase = GetEmployeePaymentsUseCase(
    repository: AdminEmployeesRepositoryImpl(
      remoteDatasource: AdminEmployeesRemoteDatasourceImpl(),
    ),
  );

  bool _loading = true;
  String? _error;
  List<EmployeePaymentEntity> _payments = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final payments = await _useCase(widget.employee.employeeId);
      if (!mounted) return;
      setState(() {
        _payments = payments;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final symbol = context.watch<CurrencyCubit>().state.info.symbol;
    final displayName = (widget.employee.fullName == null || widget.employee.fullName!.isEmpty)
        ? l10n.admin_employees_defaultName
        : widget.employee.fullName!;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FormSheetHandle(c),
            const SizedBox(height: 16),
            FormSheetHeader(
              title: l10n.admin_employees_paymentHistoryTitle,
              subtitle: displayName,
              icon: Icons.history_rounded,
              c: c,
              onClose: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: c.primary))
                  : _error != null
                      ? Center(child: Text(_error!, style: TextStyle(color: c.danger)))
                      : _payments.isEmpty
                          ? Center(
                              child: Text(l10n.admin_employees_noPaymentsYet,
                                  style: TextStyle(color: c.muted)))
                          : ListView.separated(
                              itemCount: _payments.length,
                              separatorBuilder: (_, __) =>
                                  Divider(height: 1, color: c.border.withOpacity(0.15)),
                              itemBuilder: (_, i) {
                                final p = _payments[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('dd MMM yyyy').format(p.paymentDate),
                                              style: TextStyle(
                                                  color: c.label,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                            if (p.note != null && p.note!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(p.note!,
                                                    style:
                                                        TextStyle(color: c.muted, fontSize: 12)),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '$symbol${p.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: c.success,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
