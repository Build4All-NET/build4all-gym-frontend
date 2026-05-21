import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_router.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../data/services/member_profile_service.dart';

class ProfileCompletionDialog extends StatefulWidget {
  /// Pre-filled values returned from GET /profile-status.
  final Map<String, dynamic> existing;
  final VoidCallback onCompleted;

  const ProfileCompletionDialog({
    super.key,
    required this.existing,
    required this.onCompleted,
  });

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> existing,
    required VoidCallback onCompleted,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // must fill before dismissing
      builder: (_) => ProfileCompletionDialog(
        existing: existing,
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  State<ProfileCompletionDialog> createState() =>
      _ProfileCompletionDialogState();
}

class _ProfileCompletionDialogState extends State<ProfileCompletionDialog> {
  final _service = MemberProfileService();

  // ── Form state ─────────────────────────────────────────────────────────────
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _emergencyNameController  = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  List<Map<String, dynamic>> _branches        = [];
  int?                        _selectedBranchId;
  String?                     _selectedGender;
  DateTime?                   _selectedDob;

  bool    _loadingBranches = true;
  bool    _submitting      = false;
  String? _error;

  static const _genders = ['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'];
  static const _genderLabels = {
    'MALE':             'Male',
    'FEMALE':           'Female',
    'OTHER':            'Other',
    'PREFER_NOT_TO_SAY':'Prefer not to say',
  };

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing data
    _selectedGender   = widget.existing['gender'] as String?;
    _selectedBranchId = widget.existing['preferredBranchId'] as int?;
    if (widget.existing['dob'] != null) {
      _selectedDob = DateTime.tryParse(widget.existing['dob'] as String);
    }
    if (widget.existing['heightCm'] != null) {
      _heightController.text = widget.existing['heightCm'].toString();
    }
    if (widget.existing['weightKg'] != null) {
      _weightController.text = widget.existing['weightKg'].toString();
    }
    _emergencyNameController.text  =
        (widget.existing['emergencyContactName']  as String?) ?? '';
    _emergencyPhoneController.text =
        (widget.existing['emergencyContactPhone'] as String?) ?? '';

    _loadBranches();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    try {
      final list = await _service.getBranches();
      if (mounted) setState(() { _branches = list; _loadingBranches = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingBranches = false);
    }
  }

  Future<void> _pickDob(dynamic c) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 20),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(primary: c.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  bool get _canSubmit =>
      _selectedBranchId != null &&
      _selectedGender   != null &&
      _selectedDob      != null;

  Future<void> _submit() async {
    if (!_canSubmit) {
      setState(() => _error = 'Please fill in Branch, Gender and Date of Birth.');
      return;
    }
    setState(() { _submitting = true; _error = null; });

    try {
      await _service.saveProfile({
        'dob':                  '${_selectedDob!.year}-'
                                '${_selectedDob!.month.toString().padLeft(2,'0')}-'
                                '${_selectedDob!.day.toString().padLeft(2,'0')}',
        'gender':               _selectedGender,
        'preferredBranchId':    _selectedBranchId,
        'heightCm':             double.tryParse(_heightController.text.trim()),
        'weightKg':             double.tryParse(_weightController.text.trim()),
        'emergencyContactName':
            _emergencyNameController.text.trim().isEmpty
                ? null : _emergencyNameController.text.trim(),
        'emergencyContactPhone':
            _emergencyPhoneController.text.trim().isEmpty
                ? null : _emergencyPhoneController.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onCompleted();
    } catch (e) {
      if (mounted) setState(() { _submitting = false; _error = 'Failed to save. Please try again.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final mq     = MediaQuery.of(context);

    return Dialog(
      backgroundColor: c.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.88),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          color: c.primary, size: 24),
                      const SizedBox(width: 10),
                      Text('Complete Your Profile',
                          style: TextStyle(
                            color: c.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Help us personalise your experience. '
                    'Fields marked * are required.',
                    style: TextStyle(color: c.error, fontSize: 12),
                  ),
                ],
              ),
            ),

            // ── Scrollable fields ─────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (c.error ?? Colors.red).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_error!,
                            style: TextStyle(
                                color: c.error ?? Colors.red, fontSize: 12)),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // ── Preferred Branch * ──────────────────────────────────
                    _label('Preferred Branch *', c),
                    const SizedBox(height: 8),
                    _loadingBranches
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                  color: c.primary, strokeWidth: 2),
                            ))
                        : _branchDropdown(c),
                    const SizedBox(height: 16),

                    // ── Gender * ────────────────────────────────────────────
                    _label('Gender *', c),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _genders.map((g) {
                        final selected = _selectedGender == g;
                        return ChoiceChip(
                          label: Text(_genderLabels[g]!),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedGender = g),
                          selectedColor: c.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: selected ? c.primary : c.label,
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          backgroundColor: c.background,
                          side: BorderSide(
                              color: selected
                                  ? c.primary
                                  : c.border.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── Date of Birth * ─────────────────────────────────────
                    _label('Date of Birth *', c),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDob(c),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: c.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _selectedDob != null
                                  ? c.primary
                                  : c.border.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                color: c.background, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              _selectedDob != null
                                  ? '${_selectedDob!.year}-'
                                    '${_selectedDob!.month.toString().padLeft(2, '0')}-'
                                    '${_selectedDob!.day.toString().padLeft(2, '0')}'
                                  : 'Select date of birth',
                              style: TextStyle(
                                color: _selectedDob != null
                                    ? c.primary
                                    : c.background,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Height & Weight ─────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Height (cm)', c),
                              const SizedBox(height: 8),
                              _numField(_heightController, 'e.g. 175', c),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Weight (kg)', c),
                              const SizedBox(height: 8),
                              _numField(_weightController, 'e.g. 70', c),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Emergency Contact ───────────────────────────────────
                    _label('Emergency Contact Name', c),
                    const SizedBox(height: 8),
                    _textField(_emergencyNameController, 'Full name', c),
                    const SizedBox(height: 12),
                    _label('Emergency Contact Phone', c),
                    const SizedBox(height: 8),
                    _textField(_emergencyPhoneController, 'Phone number', c,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_submitting || !_canSubmit) ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary,
                    disabledBackgroundColor: c.primary.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save & Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchDropdown(dynamic c) {
    return DropdownButtonFormField<int>(
      value: _selectedBranchId,
      dropdownColor: c.background,
      style: TextStyle(color: c.primary, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: c.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary),
        ),
      ),
      hint: Text('Select branch',
          style: TextStyle(color: c.background, fontSize: 14)),
      items: _branches
          .map((b) => DropdownMenuItem<int>(
                value: b['id'] as int,
                child: Text(b['name'] as String,
                    style: TextStyle(color: c.primary)),
              ))
          .toList(),
      onChanged: (int? v) => setState(() => _selectedBranchId = v),
    );
  }

  Widget _label(String text, dynamic c) => Text(text,
      style: TextStyle(
          color: c.primary, fontWeight: FontWeight.w600, fontSize: 13));

  Widget _numField(
      TextEditingController ctrl, String hint, dynamic c) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
      ],
      style: TextStyle(color: c.primary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.background, fontSize: 13),
        filled: true,
        fillColor: c.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController ctrl,
    String hint,
    dynamic c, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(color: c.primary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.background, fontSize: 13),
        filled: true,
        fillColor: c.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary),
        ),
      ),
    );
  }
}
