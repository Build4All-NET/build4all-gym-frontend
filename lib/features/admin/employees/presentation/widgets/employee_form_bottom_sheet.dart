// FILE: lib/features/admin/employees/presentation/widgets/employee_form_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../common/widgets/form_section_kit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/eligible_staff_entity.dart';
import '../../domain/usecases/admin_employees_usecases.dart';
import '../../data/repositories/admin_employees_repository_impl.dart';
import '../../data/services/admin_employees_remote_service.dart';
import '../../data/models/create_employee_request_model.dart';
import '../../data/models/update_employee_request_model.dart';

const List<String> kEmployeePayFrequencies = ['MONTHLY', 'WEEKLY', 'DAILY'];

String formatEmployeeType(String type) {
  if (type.isEmpty) return type;
  return type[0].toUpperCase() + type.substring(1);
}

class EmployeeFormBottomSheet {
  static void show(
    BuildContext context, {
    EmployeeEntity? existingEmployee,
    required List<String> availableTypes,
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
        child: _EmployeeFormContent(
          existingEmployee: existingEmployee,
          availableTypes: availableTypes,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}

class _EmployeeFormContent extends StatefulWidget {
  final EmployeeEntity? existingEmployee;
  final List<String> availableTypes;
  final VoidCallback onSuccess;

  const _EmployeeFormContent({
    this.existingEmployee,
    required this.availableTypes,
    required this.onSuccess,
  });

  @override
  State<_EmployeeFormContent> createState() => _EmployeeFormContentState();
}

class _EmployeeFormContentState extends State<_EmployeeFormContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _salaryController;
  late final TextEditingController _notesController;
  late final TextEditingController _customTypeController;

  // ── Identity source: existing staff vs brand-new standalone employee ─────
  bool _useExistingStaff = false;
  int? _selectedStaffUserId;
  List<EligibleStaffEntity> _eligibleStaff = [];
  bool _eligibleStaffLoading = false;
  bool _eligibleStaffLoaded = false;

  String? _selectedType;
  bool _isCustomType = false;

  String _payFrequency = 'MONTHLY';
  int? _selectedBranchId;
  DateTime? _hireDate;
  String _status = 'active';

  bool _isSubmitting = false;
  String? _errorMessage;

  final _employeesRepository = AdminEmployeesRepositoryImpl(
    remoteDatasource: AdminEmployeesRemoteDatasourceImpl(),
  );

  late final _createUseCase = CreateEmployeeUseCase(repository: _employeesRepository);
  late final _updateUseCase = UpdateEmployeeUseCase(repository: _employeesRepository);
  late final _eligibleStaffUseCase = GetEligibleStaffUseCase(repository: _employeesRepository);

  bool get _isEditMode => widget.existingEmployee != null;
  bool get _isLinkedEmployee => widget.existingEmployee?.isLinked ?? false;

  @override
  void initState() {
    super.initState();

    final employee = widget.existingEmployee;

    _fullNameController = TextEditingController(text: employee?.fullName ?? '');
    _phoneController = TextEditingController(text: employee?.phone ?? '');
    _emailController = TextEditingController(text: employee?.email ?? '');
    _salaryController = TextEditingController(text: employee?.salaryAmount.toString() ?? '');
    _notesController = TextEditingController(text: employee?.notes ?? '');
    _customTypeController = TextEditingController();

    _selectedBranchId = employee?.branchId;
    _payFrequency = employee?.payFrequency ?? 'MONTHLY';
    _hireDate = employee?.hireDate;
    _status = employee?.status ?? 'active';

    final knownType = employee != null && widget.availableTypes.contains(employee.employeeType);
    if (employee != null && !knownType) {
      _isCustomType = true;
      _customTypeController.text = formatEmployeeType(employee.employeeType);
    } else {
      _selectedType = employee?.employeeType ??
          (widget.availableTypes.isNotEmpty ? widget.availableTypes.first : null);
    }

    if (!_isEditMode) {
      _loadEligibleStaff();
    }
  }

  Future<void> _loadEligibleStaff() async {
    setState(() => _eligibleStaffLoading = true);
    try {
      final staff = await _eligibleStaffUseCase();
      if (!mounted) return;
      setState(() {
        _eligibleStaff = staff;
        _eligibleStaffLoading = false;
        _eligibleStaffLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _eligibleStaffLoading = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _notesController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickHireDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _hireDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    if (_selectedBranchId == null) {
      setState(() => _errorMessage = l10n.admin_employees_pleaseSelectBranch);
      return;
    }

    if (!_isEditMode && _useExistingStaff && _selectedStaffUserId == null) {
      setState(() => _errorMessage = l10n.admin_employees_pleaseSelectStaffMember);
      return;
    }

    final effectiveType = _isCustomType
        ? _customTypeController.text.trim().toLowerCase()
        : _selectedType;
    if (!(!_isEditMode && _useExistingStaff) &&
        (effectiveType == null || effectiveType.isEmpty)) {
      setState(() => _errorMessage = l10n.admin_employees_pleaseEnterEmployeeType);
      return;
    }

    final salary = double.tryParse(_salaryController.text.trim()) ?? 0;
    final notes = _notesController.text.trim();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (_isEditMode) {
        await _updateUseCase(
          widget.existingEmployee!.employeeId,
          UpdateEmployeeRequestModel(
            fullName: _isLinkedEmployee ? null : _fullNameController.text.trim(),
            phone: _isLinkedEmployee ? null : _phoneController.text.trim(),
            email: _isLinkedEmployee ? null : _emailController.text.trim(),
            employeeType: _isLinkedEmployee ? null : effectiveType,
            branchId: _selectedBranchId,
            salaryAmount: salary,
            payFrequency: _payFrequency,
            hireDate: _hireDate,
            status: _status,
            notes: notes,
          ),
        );
      } else if (_useExistingStaff) {
        await _createUseCase(
          CreateEmployeeRequestModel(
            linkedUserId: _selectedStaffUserId,
            employeeType: 'other', // ignored by backend when linkedUserId is set
            branchId: _selectedBranchId!,
            salaryAmount: salary,
            payFrequency: _payFrequency,
            hireDate: _hireDate,
            notes: notes.isEmpty ? null : notes,
          ),
        );
      } else {
        await _createUseCase(
          CreateEmployeeRequestModel(
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            employeeType: effectiveType!,
            branchId: _selectedBranchId!,
            salaryAmount: salary,
            payFrequency: _payFrequency,
            hireDate: _hireDate,
            notes: notes.isEmpty ? null : notes,
          ),
        );
      }

      if (!mounted) return;

      Navigator.of(context).pop();

      AppToast.success(
        context,
        _isEditMode ? l10n.admin_employees_updatedSuccessfully : l10n.admin_employees_addedSuccessfully,
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
      padding: EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
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
                title: _isEditMode ? l10n.admin_employees_editEmployee : l10n.admin_employees_addEmployee,
                icon: Icons.badge_outlined,
                c: c,
                onClose: () => Navigator.of(context).pop(),
              ),

              if (!_isEditMode) ...[
                FormSectionHeader(title: l10n.admin_employees_whoIsThis, icon: Icons.person_search_outlined, c: c),
                Row(
                  children: [
                    Expanded(
                      child: FormToggleChip(
                        label: l10n.admin_employees_newEmployee,
                        selected: !_useExistingStaff,
                        c: c,
                        onTap: () => setState(() => _useExistingStaff = false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FormToggleChip(
                        label: l10n.admin_employees_existingStaff,
                        selected: _useExistingStaff,
                        c: c,
                        onTap: () => setState(() => _useExistingStaff = true),
                      ),
                    ),
                  ],
                ),
                if (_useExistingStaff) ...[
                  const SizedBox(height: 12),
                  FormFieldLabel(l10n.admin_employees_trainerReceptionLabel, c),
                  _eligibleStaffLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : (_eligibleStaffLoaded && _eligibleStaff.isEmpty)
                          ? Text(
                              l10n.admin_employees_allStaffHavePayroll,
                              style: TextStyle(fontSize: 12.5, color: c.muted),
                            )
                          : DropdownButtonFormField<int>(
                              value: _eligibleStaff.any((s) => s.userId == _selectedStaffUserId)
                                  ? _selectedStaffUserId
                                  : null,
                              decoration: formInputDecoration(hint: l10n.admin_employees_selectStaffMember, c: c),
                              items: _eligibleStaff
                                  .map((s) => DropdownMenuItem(
                                        value: s.userId,
                                        child: Text('${s.fullName}  ·  ${formatEmployeeType(s.gymRole.toLowerCase())}'),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedStaffUserId = v),
                              validator: (v) => _useExistingStaff && v == null ? l10n.admin_employees_required : null,
                            ),
                ],
              ],

              if (_isEditMode && _isLinkedEmployee) ...[
                const SizedBox(height: 16),
                FormGroupCard(
                  c: c,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.verified_user_outlined, size: 16, color: c.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.admin_employees_identityManagedNote(
                            widget.existingEmployee!.fullName ?? l10n.admin_employees_thisPerson,
                            formatEmployeeType(widget.existingEmployee!.employeeType),
                          ),
                          style: TextStyle(fontSize: 12.5, color: c.body),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (!_useExistingStaff && !_isLinkedEmployee) ...[
                FormSectionHeader(title: 'Employee Details', icon: Icons.info_outline_rounded, c: c),
                FormFieldLabel('Full Name *', c),
                TextFormField(
                  controller: _fullNameController,
                  style: TextStyle(color: c.label),
                  decoration: formInputDecoration(hint: 'e.g. John Doe', c: c),
                  validator: (v) {
                    if (!_useExistingStaff && (v == null || v.trim().isEmpty)) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel('Phone', c),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: c.label),
                            decoration: formInputDecoration(hint: 'Optional', c: c),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel('Email', c),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: c.label),
                            decoration: formInputDecoration(hint: 'Optional', c: c),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FormFieldLabel('Employee Type *', c),
                if (_isCustomType) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _customTypeController,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: c.label),
                          decoration: formInputDecoration(hint: 'e.g. Cleaner', c: c),
                          validator: (v) => _isCustomType && (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() {
                          _isCustomType = false;
                          _customTypeController.clear();
                          _selectedType = widget.availableTypes.isNotEmpty
                              ? widget.availableTypes.first
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
                    value: _selectedType,
                    decoration: formInputDecoration(hint: 'Select employee type', c: c),
                    items: [
                      ...widget.availableTypes.map((t) =>
                          DropdownMenuItem(value: t, child: Text(formatEmployeeType(t)))),
                      DropdownMenuItem(
                        value: '__new__',
                        child: Row(
                          children: [
                            Icon(Icons.add_rounded, size: 16, color: c.primary),
                            const SizedBox(width: 6),
                            Text(l10n.admin_plans_addNewType,
                                style: TextStyle(
                                    color: c.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == '__new__') {
                        setState(() {
                          _isCustomType = true;
                          _selectedType = null;
                        });
                      } else {
                        setState(() => _selectedType = v);
                      }
                    },
                    validator: (v) =>
                        !_isCustomType && !_useExistingStaff && v == null ? 'Required' : null,
                  ),
                ],
              ],

              FormSectionHeader(title: 'Pay', icon: Icons.payments_outlined, c: c),
              FormFieldLabel('Salary Amount *', c),
              TextFormField(
                controller: _salaryController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(hint: '0.00', c: c, prefixIcon: Icons.attach_money_rounded),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed <= 0) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormFieldLabel('Pay Frequency *', c),
              Row(
                children: kEmployeePayFrequencies.map((freq) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: freq == kEmployeePayFrequencies.last ? 0 : 8),
                      child: FormToggleChip(
                        label: formatEmployeeType(freq),
                        selected: _payFrequency == freq,
                        c: c,
                        onTap: () => setState(() => _payFrequency = freq),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
                      decoration: formInputDecoration(hint: 'Select branch', c: c),
                      items: branches
                          .map((b) => DropdownMenuItem<int>(value: b.id, child: Text(b.name)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBranchId = v),
                      validator: (v) => v == null ? 'Required' : null,
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
              const SizedBox(height: 12),
              FormFieldLabel('Hire Date', c),
              FormPickerField(
                icon: Icons.calendar_today_outlined,
                label: _hireDate == null ? 'Optional' : DateFormat('dd MMM yyyy').format(_hireDate!),
                hasValue: _hireDate != null,
                onTap: _pickHireDate,
                onClear: _hireDate == null ? null : () => setState(() => _hireDate = null),
                c: c,
              ),

              if (_isEditMode) ...[
                const SizedBox(height: 12),
                FormFieldLabel('Status', c),
                Row(
                  children: [
                    Expanded(
                      child: FormToggleChip(
                        label: 'Active',
                        selected: _status == 'active',
                        c: c,
                        onTap: () => setState(() => _status = 'active'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FormToggleChip(
                        label: 'Inactive',
                        selected: _status == 'inactive',
                        c: c,
                        onTap: () => setState(() => _status = 'inactive'),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),
              FormFieldLabel('Notes', c),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                style: TextStyle(color: c.label),
                decoration: formInputDecoration(hint: 'Optional notes', c: c),
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
                label: _isEditMode ? 'Save Changes' : 'Add Employee',
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
