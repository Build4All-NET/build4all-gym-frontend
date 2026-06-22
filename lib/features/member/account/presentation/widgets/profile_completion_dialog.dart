import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/l10n/app_localizations.dart';

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
      builder: (_) =>
          ProfileCompletionDialog(existing: existing, onCompleted: onCompleted),
    );
  }

  @override
  State<ProfileCompletionDialog> createState() =>
      _ProfileCompletionDialogState();
}

class _ProfileCompletionDialogState extends State<ProfileCompletionDialog> {
  final _service = MemberProfileService();

  // ── Wizard state ───────────────────────────────────────────────────────────
  int _currentStep = 0;
  static const _stepCount = 4;
  late AppLocalizations l10n;
  List<String> get _stepTitles => [
    l10n.profileCompletionStepBranchTitle,
    l10n.profileCompletionStepAboutTitle,
    l10n.profileCompletionStepBodyTitle,
    l10n.profileCompletionStepEmergencyTitle,
  ];
  List<String> get _stepSubtitles => [
    l10n.profileCompletionStepBranchSubtitle,
    l10n.profileCompletionStepAboutSubtitle,
    l10n.profileCompletionStepBodySubtitle,
    l10n.profileCompletionStepEmergencySubtitle,
  ];
  static const _stepIcons = [
    Icons.storefront_rounded,
    Icons.account_circle_outlined,
    Icons.monitor_weight_outlined,
    Icons.contact_phone_outlined,
  ];

  // ── Form state ─────────────────────────────────────────────────────────────
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  List<Map<String, dynamic>> _branches = [];
  int? _selectedBranchId;
  String? _selectedGender;
  DateTime? _selectedDob;

  bool _loadingBranches = true;
  bool _submitting = false;
  String? _error;

  static const _genders = ['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'];
  Map<String, String> get _genderLabels => {
    'MALE': l10n.profileCompletionGenderMale,
    'FEMALE': l10n.profileCompletionGenderFemale,
    'OTHER': l10n.profileCompletionGenderOther,
    'PREFER_NOT_TO_SAY': l10n.profileCompletionGenderPreferNotToSay,
  };

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing data
    _selectedGender = widget.existing['gender'] as String?;
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
    _emergencyNameController.text =
        (widget.existing['emergencyContactName'] as String?) ?? '';
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
      if (mounted)
        setState(() {
          _branches = list;
          _loadingBranches = false;
        });
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
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: ColorScheme.dark(primary: c.primary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  bool get _isLastStep => _currentStep == _stepCount - 1;

  bool get _canProceedFromCurrentStep {
    switch (_currentStep) {
      case 0:
        return _selectedBranchId != null;
      case 1:
        return _selectedGender != null && _selectedDob != null;
      default:
        return true;
    }
  }

  bool get _canSubmit =>
      _selectedBranchId != null &&
      _selectedGender != null &&
      _selectedDob != null;

  void _goNext() {
    if (!_canProceedFromCurrentStep) {
      setState(
        () => _error = _currentStep == 0
            ? l10n.profileCompletionSelectBranchError
            : l10n.profileCompletionSelectGenderDobError,
      );
      return;
    }
    setState(() => _error = null);
    if (_isLastStep) {
      _submit();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _goBack() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep--;
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _service.saveProfile({
        'dob':
            '${_selectedDob!.year}-'
            '${_selectedDob!.month.toString().padLeft(2, '0')}-'
            '${_selectedDob!.day.toString().padLeft(2, '0')}',
        'gender': _selectedGender,
        'preferredBranchId': _selectedBranchId,
        'heightCm': double.tryParse(_heightController.text.trim()),
        'weightKg': double.tryParse(_weightController.text.trim()),
        'emergencyContactName': _emergencyNameController.text.trim().isEmpty
            ? null
            : _emergencyNameController.text.trim(),
        'emergencyContactPhone': _emergencyPhoneController.text.trim().isEmpty
            ? null
            : _emergencyPhoneController.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = l10n.profileCompletionSaveFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final mq = MediaQuery.of(context);
    l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: c.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.88),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(c),
            if (_error != null) _buildErrorBanner(c),
            Flexible(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildCurrentStep(c),
                  ),
                ),
              ),
            ),
            _buildFooter(c),
          ],
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(dynamic c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.primary.withOpacity(0.14), c.primary.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, color: c.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.profileCompletionTitle,
                style: TextStyle(
                  color: c.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStepIndicator(c),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Row(
              key: ValueKey(_currentStep),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: c.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _stepIcons[_currentStep],
                    color: c.primary,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _stepTitles[_currentStep],
                              style: TextStyle(
                                color: c.label,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          if (_currentStep >= 2)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: c.muted.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                l10n.general_optional,
                                style: TextStyle(
                                  color: c.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _stepSubtitles[_currentStep],
                        style: TextStyle(
                          color: c.label.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(dynamic c) {
    return Row(
      children: List.generate(_stepCount * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIndex = i ~/ 2;
          final filled = lineIndex < _currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: filled ? c.primary : c.border.withOpacity(0.25),
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final completed = stepIndex < _currentStep;
        final active = stepIndex == _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed || active ? c.primary : c.background,
            border: Border.all(
              color: completed || active
                  ? c.primary
                  : c.border.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: completed
              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: active ? Colors.white : c.label.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildErrorBanner(dynamic c) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (c.error ?? Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: (c.error ?? Colors.red).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: c.error ?? Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: c.error ?? Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step pages ──────────────────────────────────────────────────────────
  Widget _buildCurrentStep(dynamic c) {
    switch (_currentStep) {
      case 0:
        return _buildBranchStep(c);
      case 1:
        return _buildAboutStep(c);
      case 2:
        return _buildBodyStep(c);
      default:
        return _buildEmergencyStep(c);
    }
  }

  Widget _buildBranchStep(dynamic c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(l10n.profileCompletionPreferredBranch, c),
          const SizedBox(height: 8),
          _loadingBranches
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: c.primary,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : _branchDropdown(c),
        ],
      ),
    );
  }

  Widget _buildAboutStep(dynamic c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(l10n.profileCompletionGenderLabel, c),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _genders.map((g) {
              final selected = _selectedGender == g;
              return ChoiceChip(
                label: Text(_genderLabels[g]!),
                selected: selected,
                onSelected: (_) => setState(() => _selectedGender = g),
                selectedColor: c.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: selected ? c.primary : c.label,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: c.background,
                side: BorderSide(
                  color: selected ? c.primary : c.border.withOpacity(0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _label(l10n.profileCompletionDobLabel, c),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDob(c),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedDob != null
                      ? c.primary
                      : c.border.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: _selectedDob != null
                        ? c.primary
                        : c.label.withOpacity(0.5),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDob != null
                        ? '${_selectedDob!.year}-'
                              '${_selectedDob!.month.toString().padLeft(2, '0')}-'
                              '${_selectedDob!.day.toString().padLeft(2, '0')}'
                        : l10n.profileCompletionSelectDob,
                    style: TextStyle(
                      color: _selectedDob != null
                          ? c.primary
                          : c.label.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyStep(dynamic c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(l10n.profileCompletionHeightLabel, c),
                    const SizedBox(height: 8),
                    _numField(
                      _heightController,
                      l10n.profileCompletionHeightHint,
                      c,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(l10n.profileCompletionWeightLabel, c),
                    const SizedBox(height: 8),
                    _numField(
                      _weightController,
                      l10n.profileCompletionWeightHint,
                      c,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStep(dynamic c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(l10n.profileCompletionEmergencyNameLabel, c),
          const SizedBox(height: 8),
          _textField(
            _emergencyNameController,
            l10n.profileCompletionFullNameHint,
            c,
          ),
          const SizedBox(height: 16),
          _label(l10n.profileCompletionEmergencyPhoneLabel, c),
          const SizedBox(height: 8),
          _textField(
            _emergencyPhoneController,
            l10n.profileCompletionPhoneNumberHint,
            c,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // ── Footer ──────────────────────────────────────────────────────────────
  Widget _buildFooter(dynamic c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting ? null : _goBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: c.border.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.back,
                  style: TextStyle(color: c.label, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: _submitting ? null : _goNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                disabledBackgroundColor: c.primary.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isLastStep
                          ? l10n.profileCompletionSaveContinueButton
                          : l10n.branchDialog_next,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
      hint: Text(
        l10n.profileCompletionSelectBranchHint,
        style: TextStyle(color: c.label.withOpacity(0.5), fontSize: 14),
      ),
      items: _branches
          .map(
            (b) => DropdownMenuItem<int>(
              value: b['id'] as int,
              child: Text(
                b['name'] as String,
                style: TextStyle(color: c.primary),
              ),
            ),
          )
          .toList(),
      onChanged: (int? v) => setState(() => _selectedBranchId = v),
    );
  }

  Widget _label(String text, dynamic c) => Text(
    text,
    style: TextStyle(
      color: c.primary,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
  );

  Widget _numField(TextEditingController ctrl, String hint, dynamic c) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      style: TextStyle(color: c.primary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.label.withOpacity(0.5), fontSize: 13),
        filled: true,
        fillColor: c.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
        hintStyle: TextStyle(color: c.label.withOpacity(0.5), fontSize: 13),
        filled: true,
        fillColor: c.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
