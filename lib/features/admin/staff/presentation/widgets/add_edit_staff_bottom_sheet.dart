// lib/features/admin/staff/presentation/widgets/add_edit_staff_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';
import '../../domain/entities/admin_staff_card_entity.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';

class AddEditStaffBottomSheet extends StatefulWidget {
  final AdminStaffCardEntity? existingStaff;

  const AddEditStaffBottomSheet({super.key, this.existingStaff});

  @override
  State<AddEditStaffBottomSheet> createState() =>
      _AddEditStaffBottomSheetState();
}

class _AddEditStaffBottomSheetState extends State<AddEditStaffBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _passwordCtrl;

  String? _selectedRole;
  int?    _selectedBranchId;

  bool get _isEditMode => widget.existingStaff != null;

  static const _roleOptions   = ['Reception', 'Admin', 'Assistant'];
  static const _branchOptions = <Map<String, dynamic>>[
    {'id': 1, 'name': 'Main Branch'},
    {'id': 2, 'name': 'Downtown Branch'},
  ];

  @override
  void initState() {
    super.initState();
    final s        = widget.existingStaff;
    _fullNameCtrl  = TextEditingController(text: s?.fullName ?? '');
    _emailCtrl     = TextEditingController(text: s?.email ?? '');
    _phoneCtrl     = TextEditingController(text: s?.phone ?? '');
    _passwordCtrl  = TextEditingController();
    _selectedRole  = s?.roleName;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<AdminStaffBloc>();

    if (_isEditMode) {
      final request = UpdateStaffRequestModel(
        fullName: _fullNameCtrl.text.trim().isEmpty
            ? null : _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty
            ? null : _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty
            ? null : _phoneCtrl.text.trim(),
        roleName: _selectedRole,
        branchId: _selectedBranchId,
      );
      bloc.add(StaffUpdateRequested(widget.existingStaff!.staffId, request));
    } else {
      final request = CreateStaffRequestModel(
        fullName: _fullNameCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        phone:    _phoneCtrl.text.trim(),
        roleName: _selectedRole!,
        branchId: _selectedBranchId!,
        password: _passwordCtrl.text.trim().isEmpty
            ? null : _passwordCtrl.text.trim(),
      );
      bloc.add(StaffCreateRequested(request));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens     = context.read<ThemeCubit>().state.tokens;
    final c          = tokens.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Drag handle ────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: c.border.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // ── Sheet header ───────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.manage_accounts,
                        color: c.onPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditMode
                                ? 'Edit Staff Member'
                                : 'Add New Staff Member',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: c.label,
                            ),
                          ),
                          if (!_isEditMode)
                            Text(
                              'Fill in the details to add a new\nreception staff member to your gym',
                              style: TextStyle(
                                fontSize: 12,
                                color: c.muted,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Section label ──────────────────────────────────────────
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: c.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: c.label,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Full Name ──────────────────────────────────────────────
                _buildLabel('Full Name', c),
                _buildTextField(
                  c: c,
                  controller: _fullNameCtrl,
                  hint: 'Enter full name',
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) && !_isEditMode
                      ? 'Full name is required'
                      : null,
                ),
                const SizedBox(height: 14),

                // ── Email ──────────────────────────────────────────────────
                _buildLabel('Email Address', c),
                _buildTextField(
                  c: c,
                  controller: _emailCtrl,
                  hint: 'staff@fitzone.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if ((v == null || v.trim().isEmpty) && !_isEditMode) {
                      return 'Email is required';
                    }
                    if (v != null && v.isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w.]+@[\w]+\.[a-zA-Z]+$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'Enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ── Phone ──────────────────────────────────────────────────
                _buildLabel('Phone Number', c),
                _buildTextField(
                  c: c,
                  controller: _phoneCtrl,
                  hint: '+91 98765 43210',
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) && !_isEditMode
                      ? 'Phone number is required'
                      : null,
                ),
                const SizedBox(height: 14),

                // ── Role dropdown ──────────────────────────────────────────
                _buildLabel('Role', c),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  hint: Text('Select role',
                      style: TextStyle(color: c.muted, fontSize: 14)),
                  items: _roleOptions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) =>
                  v == null && !_isEditMode ? 'Role is required' : null,
                  decoration: _inputDecoration(c),
                ),
                const SizedBox(height: 14),

                // ── Branch dropdown ────────────────────────────────────────
                _buildLabel('Branch Assignment', c),
                DropdownButtonFormField<int>(
                  value: _selectedBranchId,
                  hint: Text('Select branch',
                      style: TextStyle(color: c.muted, fontSize: 14)),
                  items: _branchOptions
                      .map((b) => DropdownMenuItem<int>(
                    value: b['id'] as int,
                    child: Text(b['name'] as String),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedBranchId = v),
                  validator: (v) =>
                  v == null && !_isEditMode ? 'Branch is required' : null,
                  decoration: _inputDecoration(c),
                ),
                const SizedBox(height: 14),

                // ── Password (ADD mode only) ───────────────────────────────
                if (!_isEditMode) ...[
                  _buildLabel('Password', c),
                  _buildTextField(
                    c: c,
                    controller: _passwordCtrl,
                    hint: 'Auto-generate or enter',
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Leave empty to auto-generate a secure password',
                      style: TextStyle(fontSize: 11, color: c.muted),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 24),

                // ── Action buttons ─────────────────────────────────────────
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.primary,
                          side: BorderSide(color: c.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Confirm
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: c.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isEditMode ? 'Save Changes' : 'Add Staff Member',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ColorTokens c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: c.body,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required ColorTokens c,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(fontSize: 14, color: c.label),
      decoration: _inputDecoration(c).copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration(ColorTokens c) {
    return InputDecoration(
      filled: true,
      fillColor: c.background,
      hintStyle: TextStyle(color: c.muted, fontSize: 14),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.border.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.border.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.error, width: 1.5),
      ),
    );
  }
}