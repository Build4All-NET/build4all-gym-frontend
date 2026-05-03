// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/widgets/add_edit_staff_dialog.dart
//
// MATCHES FIGMA DESIGN:
//   • Dialog (not bottom sheet) with white background, rounded corners
//   • Header: "Add New Staff" title + X close button
//   • Fields (in order):
//       Full Name *
//       Email *
//       Phone Number *
//       Role * (dropdown: Reception | Admin | Assistant) — dynamic from DB
//       Branch Assignment * (dropdown) — dynamic from DB
//       Password (optional, ADD mode only)
//   • Buttons: [Cancel]  [Save Staff] (black filled)
//
// DYNAMIC DATA:
//   - Role options: wire _roleOptions to your roles API/provider
//   - Branch options: wire _branchOptions to your branches API/BLoC
//   Both are marked with TODO comments for easy wiring.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';
import '../../domain/entities/admin_staff_card_entity.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';

class AddEditStaffDialog extends StatefulWidget {
  /// When non-null, the dialog operates in EDIT mode.
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
  int? _selectedBranchId;

  bool get _isEditMode => widget.existingStaff != null;

  // TODO: Replace with dynamic data from your roles API/BLoC
  // These should come from a RolesProvider or be fetched from the backend
  static const _roleOptions = ['Reception', 'Admin', 'Assistant'];

  // TODO: Replace with dynamic data from your branches API/BLoC
  // In production, inject a BranchesBloc or fetch from your branches provider
  static const _branchOptions = <Map<String, dynamic>>[
    {'id': 1, 'name': 'Mumbai Central'},
    {'id': 2, 'name': 'Andheri West'},
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.existingStaff;
    _fullNameCtrl = TextEditingController(text: s?.fullName ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _passwordCtrl = TextEditingController();
    _selectedRole = s?.roleName;
    // branchId not pre-filled in edit mode — resolve from branches provider
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
            ? null
            : _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        roleName: _selectedRole,
        branchId: _selectedBranchId,
      );
      bloc.add(StaffUpdateRequested(widget.existingStaff!.staffId, request));
    } else {
      final request = CreateStaffRequestModel(
        fullName: _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        roleName: _selectedRole!,
        branchId: _selectedBranchId!,
        password: _passwordCtrl.text.trim().isEmpty
            ? null
            : _passwordCtrl.text.trim(),
      );
      bloc.add(StaffCreateRequested(request));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close,
                          size: 22, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Full Name ─────────────────────────────────────────────────
              _buildLabel('Full Name *'),
              _buildTextField(
                controller: _fullNameCtrl,
                hint: 'Enter full name',
                validator: (v) =>
                (v == null || v.trim().isEmpty) && !_isEditMode
                    ? 'Full name is required'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Email ─────────────────────────────────────────────────────
              _buildLabel('Email *'),
              _buildTextField(
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
              _buildLabel('Phone Number *'),
              _buildTextField(
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
              _buildLabel('Role *'),
              // TODO: Replace _roleOptions with dynamic list from your roles provider
              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text(
                  'Select role',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                items: _roleOptions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRole = v),
                validator: (v) =>
                v == null && !_isEditMode ? 'Role is required' : null,
                decoration: _inputDecoration(),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),

              // ── Branch Assignment dropdown ─────────────────────────────────
              _buildLabel('Branch Assignment *'),
              // TODO: Replace _branchOptions with dynamic list from your branches provider/BLoC
              DropdownButtonFormField<int>(
                value: _selectedBranchId,
                hint: const Text(
                  'Select branch',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
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
                decoration: _inputDecoration(),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),

              // ── Password (ADD mode only) ──────────────────────────────────
              if (!_isEditMode) ...[
                _buildLabel('Password'),
                _buildTextField(
                  controller: _passwordCtrl,
                  hint: 'Auto-generate or enter',
                  obscureText: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Leave empty to auto-generate a secure password',
                    style:
                    TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              const SizedBox(height: 24),

              // ── Buttons: Cancel + Save Staff ──────────────────────────────
              Row(
                children: [
                  // Cancel — white outlined
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E293B),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Save Staff — black filled
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        foregroundColor: Colors.white,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
      decoration: _inputDecoration().copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      hintStyle:
      const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
      ),
    );
  }
}