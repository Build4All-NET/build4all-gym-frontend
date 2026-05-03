// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/widgets/add_edit_staff_bottom_sheet.dart
//
// Dual-mode: ADD (existingStaff == null) and EDIT (existingStaff != null).
//
// FORM FIELDS:
//   Full Name, Email, Phone — required text inputs.
//   Role — dropdown: Reception | Admin | Assistant.
//   Branch — dropdown: currently a placeholder list; wire to a branch provider
//            when the branch list API is available.
//   Password — shown in ADD mode only; empty = backend auto-generates.
//
// ON SAVE:
//   ADD:  builds CreateStaffRequestModel (password null if field empty),
//         dispatches StaffCreateRequested, closes sheet.
//   EDIT: builds UpdateStaffRequestModel (only changed non-null fields),
//         dispatches StaffUpdateRequested, closes sheet.
//
// VALIDATION:
//   Uses Flutter's Form + GlobalKey<FormState>. Required fields use
//   validator callbacks. Email is validated with a basic regex.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/create_staff_request_model.dart';
import '../../data/models/update_staff_request_model.dart';
import '../../domain/entities/admin_staff_card_entity.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';

class AddEditStaffBottomSheet extends StatefulWidget {
  /// When non-null, the sheet operates in EDIT mode.
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
  int? _selectedBranchId;

  bool get _isEditMode => widget.existingStaff != null;

  // Role options shown in the dropdown.
  // Must match the allowed labels the backend validates.
  static const _roleOptions = ['Reception', 'Admin', 'Assistant'];

  // Placeholder branch list — replace with data from a branches provider/API.
  static const _branchOptions = <Map<String, dynamic>>[
    {'id': 1, 'name': 'Main Branch'},
    {'id': 2, 'name': 'Downtown Branch'},
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.existingStaff;
    _fullNameCtrl = TextEditingController(text: s?.fullName ?? '');
    _emailCtrl    = TextEditingController(text: s?.email ?? '');
    _phoneCtrl    = TextEditingController(text: s?.phone ?? '');
    _passwordCtrl = TextEditingController();
    _selectedRole = s?.roleName;
    // In edit mode we don't pre-select branch from the entity because branchName
    // (String) doesn't map back to a branchId cleanly without the branch list.
    // A real implementation would resolve branchId from the branches provider.
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
      // EDIT mode — build partial update (only changed fields)
      final request = UpdateStaffRequestModel(
        fullName: _fullNameCtrl.text.trim().isEmpty
            ? null
            : _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty
            ? null
            : _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty
            ? null
            : _phoneCtrl.text.trim(),
        roleName: _selectedRole,
        branchId: _selectedBranchId,
      );
      bloc.add(StaffUpdateRequested(widget.existingStaff!.staffId, request));
    } else {
      // ADD mode — build full create request
      final request = CreateStaffRequestModel(
        fullName: _fullNameCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        phone:    _phoneCtrl.text.trim(),
        roleName: _selectedRole!,
        branchId: _selectedBranchId!,
        // null password → backend auto-generates and emails it
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.ltr, // flip to rtl when locale requires
      child: Container(
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                      color: Colors.grey[300],
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
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.manage_accounts,
                        color: Colors.white,
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
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (!_isEditMode)
                            const Text(
                              'Fill in the details to add a new\nreception staff member to your gym',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
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
                  children: const [
                    Icon(Icons.person_outline,
                        size: 16, color: Color(0xFF2563EB)),
                    SizedBox(width: 6),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Full Name ──────────────────────────────────────────────
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _fullNameCtrl,
                  hint: 'Enter full name',
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) && !_isEditMode
                      ? 'Full name is required'
                      : null,
                ),
                const SizedBox(height: 14),

                // ── Email ──────────────────────────────────────────────────
                _buildLabel('Email Address'),
                _buildTextField(
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
                _buildLabel('Phone Number'),
                _buildTextField(
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
                _buildLabel('Role'),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  hint: const Text('Select role'),
                  items: _roleOptions
                      .map((r) =>
                      DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) =>
                  v == null && !_isEditMode ? 'Role is required' : null,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 14),

                // ── Branch dropdown ────────────────────────────────────────
                _buildLabel('Branch Assignment'),
                DropdownButtonFormField<int>(
                  value: _selectedBranchId,
                  hint: const Text('Select branch'),
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
                ),
                const SizedBox(height: 14),

                // ── Password (ADD mode only) ────────────────────────────────
                if (!_isEditMode) ...[
                  _buildLabel('Password'),
                  _buildTextField(
                    controller: _passwordCtrl,
                    hint: 'Auto-generate or enter',
                    obscureText: true,
                    // No validator — password is truly optional.
                    // Empty → backend auto-generates.
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Leave empty to auto-generate a secure password',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 24),

                // ── Action buttons ─────────────────────────────────────────
                Row(
                  children: [
                    // Cancel — white outlined
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Confirm — blue filled
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
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

  // ── Private form helpers ───────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
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
      decoration: _inputDecoration().copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide:
        const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }
}