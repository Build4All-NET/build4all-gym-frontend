// FILE: lib/features/admin/expenses/presentation/widgets/expense_form_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../common/widgets/form_section_kit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/admin_expenses_usecases.dart';
import '../../data/repositories/admin_expenses_repository_impl.dart';
import '../../data/services/admin_expenses_remote_service.dart';
import '../../data/models/create_expense_request_model.dart';
import '../../data/models/update_expense_request_model.dart';

const List<String> kExpenseCategories = [
  'rent',
  'salary',
  'equipment',
  'maintenance',
  'utilities',
  'marketing',
  'supplies',
  'other',
];

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
    _descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    _amountController = TextEditingController(
      text: expense?.amount.toString() ?? '',
    );

    _expenseDate = expense?.expenseDate ?? DateTime.now();
    _selectedBranchId = expense?.branchId;

    // If editing an expense whose category isn't in the known list (shouldn't
    // normally happen since the backend list includes every in-use category,
    // but guards against a stale list), fall back to custom-entry mode.
    final knownCategory = expense != null && widget.availableCategories.contains(expense.category);
    if (expense != null && !knownCategory) {
      _isCustomCategory = true;
      _customCategoryController = TextEditingController(text: formatExpenseCategory(expense.category));
    } else {
      _customCategoryController = TextEditingController();
      _selectedCategory = expense?.category ??
          (widget.availableCategories.isNotEmpty ? widget.availableCategories.first : null);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _customCategoryController.dispose();
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
      setState(() {
        _errorMessage = 'Please select a branch';
      });
      return;
    }
    final effectiveCategory = _isCustomCategory
        ? _customCategoryController.text.trim().toLowerCase()
        : _selectedCategory;
    if (effectiveCategory == null || effectiveCategory.isEmpty) {
      setState(() => _errorMessage = 'Please enter a category');
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
            category: effectiveCategory,
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
            category: effectiveCategory,
            branchId: _selectedBranchId!,
          ),
        );
      }

      if (!mounted) return;

      Navigator.of(context).pop();

      AppToast.success(
        context,
        _isEditMode
            ? 'Expense updated successfully'
            : 'Expense added successfully',
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
                title: _isEditMode ? 'Edit Expense' : 'Add Expense',
                icon: Icons.receipt_long_outlined,
                c: c,
                onClose: () => Navigator.of(context).pop(),
              ),
              FormSectionHeader(
                title: 'Expense Details',
                icon: Icons.info_outline_rounded,
                c: c,
              ),
              FormFieldLabel('Title *', c),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(
                  hint: 'e.g. Electricity bill',
                  c: c,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormFieldLabel('Description', c),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(
                  hint: 'Optional notes',
                  c: c,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldLabel('Amount *', c),
                        TextFormField(
                          controller: _amountController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: TextStyle(color: c.label),
                          decoration: formInputDecoration(
                            hint: '0.00',
                            c: c,
                            prefixIcon: Icons.attach_money_rounded,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }

                            final parsed = double.tryParse(v.trim());

                            if (parsed == null || parsed <= 0) {
                              return 'Invalid amount';
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
                        FormFieldLabel('Date *', c),
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
              FormFieldLabel('Category *', c),
              if (_isCustomCategory) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _customCategoryController,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(color: c.label),
                        decoration: formInputDecoration(hint: 'Enter category (e.g. Marketing)', c: c),
                        validator: (v) => _isCustomCategory && (v == null || v.trim().isEmpty)
                            ? 'Required'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() {
                        _isCustomCategory = false;
                        _customCategoryController.clear();
                        _selectedCategory = widget.availableCategories.isNotEmpty
                            ? widget.availableCategories.first
                            : null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: c.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.border.withOpacity(0.3)),
                        ),
                        child: Icon(Icons.close_rounded, size: 18, color: c.muted),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: formInputDecoration(hint: 'Select category', c: c),
                  items: [
                    ...widget.availableCategories.map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(formatExpenseCategory(cat)))),
                    DropdownMenuItem(
                      value: '__new__',
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, size: 16, color: c.primary),
                          const SizedBox(width: 6),
                          Text('Add new category…',
                              style: TextStyle(
                                  color: c.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == '__new__') {
                      setState(() {
                        _isCustomCategory = true;
                        _selectedCategory = null;
                      });
                    } else {
                      setState(() => _selectedCategory = v);
                    }
                  },
                  validator: (v) => !_isCustomCategory && v == null ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 12),
              FormFieldLabel('Branch *', c),
              BlocBuilder<BranchCubit, BranchState>(
                builder: (context, state) {
                  if (state is BranchLoaded) {
                    final branches = state.branches;

                    final hasSelected = _selectedBranchId != null &&
                        branches.any((b) => b.id == _selectedBranchId);

                    return DropdownButtonFormField<int>(
                      value: hasSelected ? _selectedBranchId : null,
                      decoration: formInputDecoration(
                        hint: 'Select branch',
                        c: c,
                      ),
                      items: branches
                          .map(
                            (b) => DropdownMenuItem<int>(
                              value: b.id,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedBranchId = v);
                      },
                      validator: (v) {
                        if (v == null) {
                          return 'Required';
                        }
                        return null;
                      },
                    );
                  }

                  if (state is BranchError) {
                    return Text(
                      state.message,
                      style: TextStyle(
                        color: c.danger,
                        fontSize: 12,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: c.primary,
                      ),
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
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: c.danger),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FormPrimaryButton(
                label: _isEditMode ? 'Save Changes' : 'Add Expense',
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