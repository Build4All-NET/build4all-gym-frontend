// lib/features/admin/staff/presentation/widgets/add_edit_staff_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';
import '../../domain/entities/admin_staff_card_entity.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';

class AddEditStaffDialog extends StatefulWidget {
  final AdminStaffCardEntity? existingStaff;

  const AddEditStaffDialog({super.key, this.existingStaff});

  @override
  State<AddEditStaffDialog> createState() => _AddEditStaffDialogState();
}

class _AddEditStaffDialogState extends State<AddEditStaffDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _passwordCtrl;

  String? _selectedRole;
  int?    _selectedBranchId;

  bool get _isEditMode => widget.existingStaff != null;

  // TODO: Replace with dynamic data from your roles API/BLoC
  static const _roleOptions = ['Reception', 'Admin', 'Assistant'];

  // TODO: Replace with dynamic data from your branches API/BLoC
  static const _branchOptions = <Map<String, dynamic>>[
    {'id': 1, 'name': 'Mumbai Central'},
    {'id': 2, 'name': 'Andheri West'},
  ];

  @override
  void initState() {
    super.initState();
    final s       = widget.existingStaff;
    _fullNameCtrl = TextEditingController(text: s?.fullName ?? '');
    _emailCtrl    = TextEditingController(text: s?.email ?? '');
    _phoneCtrl    = TextEditingController(text: s?.phone ?? '');
    _passwordCtrl = TextEditingController();
    _selectedRole = s?.roleName;
    // TODO: resolve _selectedBranchId from branches provider using s?.branchName
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
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    return Dialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header row: title + X close ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditMode ? 'Edit Staff Member' : 'Add New Staff',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: c.label,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 22, color: c.muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Full Name ─────────────────────────────────────────────────
              _buildLabel('Full Name *', c),
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

              // ── Email ─────────────────────────────────────────────────────
              _buildLabel('Email *', c),
              _buildTextField(
                c: c,
                controller: _emailCtrl,
                hint: 'Enter email',
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

              // ── Phone Number ──────────────────────────────────────────────
              _buildLabel('Phone Number *', c),
              _buildTextField(
                c: c,
                controller: _phoneCtrl,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                (v == null || v.trim().isEmpty) && !_isEditMode
                    ? 'Phone number is required'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Role dropdown ─────────────────────────────────────────────
              _buildLabel('Role *', c),
              // TODO: Replace _roleOptions with dynamic list from your roles provider
              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: Text(
                  'Select role',
                  style: TextStyle(color: c.muted, fontSize: 14),
                ),
                items: _roleOptions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRole = v),
                validator: (v) =>
                v == null && !_isEditMode ? 'Role is required' : null,
                decoration: _inputDecoration(c),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
              ),
              const SizedBox(height: 14),

              // ── Branch Assignment dropdown ─────────────────────────────────
              _buildLabel('Branch Assignment *', c),
              // TODO: Replace _branchOptions with dynamic list from your branches provider/BLoC
              DropdownButtonFormField<int>(
                value: _selectedBranchId,
                hint: Text(
                  'Select branch',
                  style: TextStyle(color: c.muted, fontSize: 14),
                ),
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
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
              ),
              const SizedBox(height: 14),

              // ── Password (ADD mode only) ──────────────────────────────────
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

              // ── Buttons: Cancel + Save Staff ──────────────────────────────
              Row(
                children: [
                  // Cancel — outlined
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.label,
                        side: BorderSide(color: c.border.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Save Staff — dark filled (uses label token for dark contrast)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.label,
                        foregroundColor: c.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _isEditMode ? 'Save Changes' : 'Save Staff',
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
          fontWeight: FontWeight.w600,
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
      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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