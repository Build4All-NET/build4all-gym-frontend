import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/form_section_kit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/employee_entity.dart';
import '../../data/models/pay_employee_request_model.dart';
import '../bloc/admin_employees/admin_employees_bloc.dart';

class PayEmployeeDialog {
  static void show(BuildContext context, {required EmployeeEntity employee}) {
    final bloc = context.read<AdminEmployeesBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: _PayEmployeeDialogContent(employee: employee),
      ),
    );
  }
}

class _PayEmployeeDialogContent extends StatefulWidget {
  final EmployeeEntity employee;
  const _PayEmployeeDialogContent({required this.employee});

  @override
  State<_PayEmployeeDialogContent> createState() => _PayEmployeeDialogContentState();
}

class _PayEmployeeDialogContentState extends State<_PayEmployeeDialogContent> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  DateTime _paymentDate = DateTime.now();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.employee.salaryAmount.toStringAsFixed(2));
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _paymentDate = picked);
    }
  }

  void _confirm() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorMessage = AppLocalizations.of(context)!.admin_employees_invalidAmount);
      return;
    }

    context.read<AdminEmployeesBloc>().add(PayEmployeeEvent(
          employeeId: widget.employee.employeeId,
          request: PayEmployeeRequestModel(
            amount: amount,
            paymentDate: _paymentDate,
            note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          ),
        ));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final displayName = (widget.employee.fullName == null || widget.employee.fullName!.isEmpty)
        ? l10n.admin_employees_defaultName
        : widget.employee.fullName!;

    return AlertDialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(l10n.admin_employees_payDialogTitle(displayName), style: TextStyle(color: c.label, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.fingerprint_outlined, size: 16, color: c.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.admin_employees_workedDaysThisMonth(widget.employee.daysWorkedThisMonth),
                    style: TextStyle(fontSize: 12.5, color: c.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            FormFieldLabel(l10n.admin_employees_amountLabel, c),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: c.label),
              decoration: formInputDecoration(hint: '0.00', c: c, prefixIcon: Icons.attach_money_rounded),
            ),
            const SizedBox(height: 12),
            FormFieldLabel(l10n.admin_employees_paymentDateLabel, c),
            FormPickerField(
              icon: Icons.calendar_today_outlined,
              label: DateFormat('dd MMM yyyy').format(_paymentDate),
              hasValue: true,
              onTap: _pickDate,
              c: c,
            ),
            const SizedBox(height: 12),
            FormFieldLabel(l10n.admin_employees_noteLabel, c),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              style: TextStyle(color: c.label),
              decoration: formInputDecoration(hint: l10n.general_optional, c: c),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(_errorMessage!, style: TextStyle(color: c.danger, fontSize: 12)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.general_cancel, style: TextStyle(color: c.muted)),
        ),
        ElevatedButton(
          onPressed: _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: c.success,
            foregroundColor: c.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(l10n.admin_employees_confirmPayButton),
        ),
      ],
    );
  }
}
