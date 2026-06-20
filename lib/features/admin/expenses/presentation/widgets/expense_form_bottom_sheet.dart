import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../common/widgets/form_section_kit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/admin_expenses_usecases.dart';
import '../../data/repositories/admin_expenses_repository_impl.dart';
import '../../data/services/admin_expenses_remote_service.dart';
import '../../data/models/create_expense_request_model.dart';
import '../../data/models/update_expense_request_model.dart';

String formatExpenseCategory(String category) {
  if (category.isEmpty) return category;
  return category[0].toUpperCase() + category.substring(1);
}

class ExpenseFormBottomSheet {
  static void show(
    BuildContext context, {
    ExpenseEntity? existingExpense,
    required List<String> availableCategories,
    required VoidCallback onSuccess,
  }) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    // showModalBottomSheet mounts its content on the root Overlay, which is
    // not a descendant of this route's MultiBlocProvider — BranchCubit has to
    // be captured here and re-provided explicitly into the sheet's subtree.
    final branchCubit = context.read<BranchCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: branchCubit,
        child: _ExpenseFormContent(
          existingExpense: existingExpense,
          availableCategories: availableCategories,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ExpenseFormContent extends StatefulWidget {
  final ExpenseEntity? existingExpense;
  final List<String> availableCategories;
  final VoidCallback onSuccess;

  const _ExpenseFormContent({
    this.existingExpense,
    required this.availableCategories,
    required this.onSuccess,
  });

  @override
  State<_ExpenseFormContent> createState() => _ExpenseFormContentState();
}

class _ExpenseFormContentState extends State<_ExpenseFormContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;

  late DateTime _expenseDate;
  String? _selectedCategory;
  bool _isCustomCategory = false;
  late final TextEditingController _customCategoryController;
  int? _selectedBranchId;

  bool _isSubmitting = false;
  String? _errorMessage;

  final _createExpenseUseCase = CreateExpenseUseCase(
    repository: AdminExpensesRepositoryImpl(
      remoteDatasource: AdminExpensesRemoteDatasourceImpl(),
    ),
  );
  final _updateExpenseUseCase = UpdateExpenseUseCase(
    repository: AdminExpensesRepositoryImpl(
      remoteDatasource: AdminExpensesRemoteDatasourceImpl(),
    ),
  );

  bool get _isEditMode => widget.existingExpense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.existingExpense;

    _titleController = TextEditingController(text: expense?.title ?? '');
    _descriptionController = TextEditingController(text: expense?.description ?? '');
    _amountController = TextEditingController(text: expense?.amount.toString() ?? '');
    _expenseDate = expense?.expenseDate ?? DateTime.now();
    _selectedCategory = expense?.category ?? kExpenseCategories.first;
    _selectedBranchId = expense?.branchId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _expenseDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchId == null) {
      setState(() =>
          _errorMessage = AppLocalizations.of(context)!.admin_expenses_selectBranchError);
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (_isEditMode) {
        await _updateExpenseUseCase(
          widget.existingExpense!.expenseId,
          UpdateExpenseRequestModel(
            title: title,
            description: description.isEmpty ? null : description,
            amount: amount,
            expenseDate: _expenseDate,
            category: _selectedCategory!,
            branchId: _selectedBranchId!,
          ),
        );
      } else {
        await _createExpenseUseCase(
          CreateExpenseRequestModel(
            title: title,
            description: description.isEmpty ? null : description,
            amount: amount,
            expenseDate: _expenseDate,
            category: _selectedCategory!,
            branchId: _selectedBranchId!,
          ),
        );
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      Navigator.of(context).pop();
      AppToast.success(
        context,
        _isEditMode
            ? l10n.admin_expenses_updatedSuccess
            : l10n.admin_expenses_addedSuccess,
      );
      widget.onSuccess();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FormSheetHandle(c),
              const SizedBox(height: 16),
              FormSheetHeader(
                title: _isEditMode
                    ? l10n.admin_expenses_editTitle
                    : l10n.admin_expenses_addTitle,
                icon: Icons.receipt_long_outlined,
                c: c,
                onClose: () => Navigator.of(context).pop(),
              ),

              FormSectionHeader(title: l10n.admin_expenses_sectionDetails, icon: Icons.info_outline_rounded, c: c),

              FormFieldLabel(l10n.admin_expenses_titleLabel, c),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(hint: l10n.admin_expenses_titleHint, c: c),
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.admin_expenses_required
                    : null,
              ),
              const SizedBox(height: 12),

              FormFieldLabel(l10n.admin_expenses_descriptionLabel, c),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(hint: l10n.admin_expenses_descriptionHint, c: c),
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldLabel(l10n.admin_expenses_amountLabel, c),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: c.label),
                          decoration: formInputDecoration(
                            hint: '0.00',
                            c: c,
                            prefixIcon: Icons.attach_money_rounded,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.admin_expenses_required;
                            }
                            final parsed = double.tryParse(v.trim());
                            if (parsed == null || parsed <= 0) {
                              return l10n.admin_expenses_invalidAmount;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldLabel(l10n.admin_expenses_dateLabel, c),
                        FormPickerField(
                          icon: Icons.calendar_today_outlined,
                          label: DateFormat('dd MMM yyyy').format(_expenseDate),
                          hasValue: true,
                          onTap: _pickDate,
                          c: c,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              FormFieldLabel(l10n.admin_expenses_categoryLabel, c),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: formInputDecoration(hint: l10n.admin_expenses_selectCategory, c: c),
                items: kExpenseCategories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(formatExpenseCategory(cat))))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? l10n.admin_expenses_required : null,
              ),
              const SizedBox(height: 12),

              FormFieldLabel(l10n.admin_expenses_branchLabel, c),
              BlocBuilder<BranchCubit, BranchState>(
                builder: (context, state) {
                  if (state is BranchLoaded) {
                    final branches = state.branches;
                    final hasSelected = _selectedBranchId != null &&
                        branches.any((b) => b.id == _selectedBranchId);
                    return DropdownButtonFormField<int>(
                      value: hasSelected ? _selectedBranchId : null,
                      decoration: formInputDecoration(hint: l10n.admin_expenses_selectBranch, c: c),
                      items: branches
                          .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBranchId = v),
                      validator: (v) => v == null ? l10n.admin_expenses_required : null,
                    );
                  }
                  if (state is BranchError) {
                    return Text(state.message, style: TextStyle(color: c.danger, fontSize: 12));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
                    ),
                  );
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.danger.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_errorMessage!, style: TextStyle(color: c.danger)),
                ),
              ],

              const SizedBox(height: 24),

              FormPrimaryButton(
                label: _isEditMode
                    ? l10n.admin_expenses_saveChanges
                    : l10n.admin_expenses_addTitle,
                background: c.primary,
                foreground: c.onPrimary,
                loading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
