import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:build4allgym/features/member/account/data/services/member_profile_service.dart';

class MemberMyInfoScreen extends StatefulWidget {
  const MemberMyInfoScreen({super.key});

  @override
  State<MemberMyInfoScreen> createState() => _MemberMyInfoScreenState();
}

class _MemberMyInfoScreenState extends State<MemberMyInfoScreen> {
  final MemberProfileService _service = MemberProfileService();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNameController =
  TextEditingController();
  final TextEditingController _emergencyPhoneController =
  TextEditingController();

  List<Map<String, dynamic>> _branches = [];

  int? _selectedBranchId;
  String? _selectedGender;
  DateTime? _selectedDob;

  // Defaults to GENERAL_FITNESS to match the backend's safe default for
  // members who haven't picked a goal yet — never left null.
  String _selectedFitnessGoal = 'GENERAL_FITNESS';

  bool _loading = true;
  bool _saving = false;
  String? _error;

  static const List<String> _genders = [
    'MALE',
    'FEMALE',
    'OTHER',
    'PREFER_NOT_TO_SAY',
  ];

  // Must match the backend's FitnessGoal enum exactly (see
  // com.build4all_gym.user.domain.FitnessGoal). This is a controlled list,
  // not free text.
  static const List<String> _fitnessGoals = [
    'MUSCLE_GAIN',
    'WEIGHT_LOSS',
    'GENERAL_FITNESS',
    'ENDURANCE',
    'FLEXIBILITY',
    'CONSISTENCY',
    'WELLNESS',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _service.getProfileStatus(),
        _service.getBranches(),
      ]);

      final profile = results[0] as Map<String, dynamic>;
      final branches = results[1] as List<Map<String, dynamic>>;

      _selectedGender = profile['gender'] as String?;

      final rawFitnessGoal = profile['fitnessGoal'] as String?;
      _selectedFitnessGoal = rawFitnessGoal != null &&
              _fitnessGoals.contains(rawFitnessGoal)
          ? rawFitnessGoal
          : 'GENERAL_FITNESS';

      final branchValue = profile['preferredBranchId'];

      int? parsedBranchId;
      if (branchValue is int) {
        parsedBranchId = branchValue;
      } else if (branchValue is num) {
        parsedBranchId = branchValue.toInt();
      } else if (branchValue != null) {
        parsedBranchId = int.tryParse(branchValue.toString());
      }

      // Important: 0 means no branch selected yet.
      // Real branches usually start from 1.
      _selectedBranchId =
      parsedBranchId != null && parsedBranchId > 0 ? parsedBranchId : null;

      final dobValue = profile['dob'] ?? profile['dateOfBirth'];
      if (dobValue is String && dobValue.trim().isNotEmpty) {
        _selectedDob = DateTime.tryParse(dobValue);
      }

      if (profile['heightCm'] != null) {
        _heightController.text = profile['heightCm'].toString();
      }

      if (profile['weightKg'] != null) {
        _weightController.text = profile['weightKg'].toString();
      }

      _addressController.text = (profile['address'] as String?) ?? '';

      _emergencyNameController.text =
          (profile['emergencyContactName'] as String?) ?? '';

      _emergencyPhoneController.text =
          (profile['emergencyContactPhone'] as String?) ?? '';

      if (!mounted) return;

      setState(() {
        _branches = branches;
        _loading = false;
      });
    } catch (e, stack) {
      debugPrint("MY INFO LOAD ERROR: $e");
      debugPrint("STACK: $stack");

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = l10n.myInfoLoadError;
      });
    }
  }

  bool get _canSave {
    return _selectedBranchId != null &&
        _selectedGender != null &&
        _selectedDob != null;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 20),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5),
    );

    if (picked == null) return;

    setState(() {
      _selectedDob = picked;
    });
  }

  Future<void> _saveInfo() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_canSave) {
      setState(() {
        _error = l10n.myInfoRequiredError;
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      debugPrint("ADDRESS SENT: ${_addressController.text.trim()}");
      await _service.saveProfile({

        'dob': _formatDate(_selectedDob!),
        'gender': _selectedGender,
        'preferredBranchId': _selectedBranchId,
        'heightCm': double.tryParse(_heightController.text.trim()),
        'weightKg': double.tryParse(_weightController.text.trim()),
        'address': _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        'emergencyContactName': _emergencyNameController.text.trim().isEmpty
            ? null
            : _emergencyNameController.text.trim(),
        'emergencyContactPhone': _emergencyPhoneController.text.trim().isEmpty
            ? null
            : _emergencyPhoneController.text.trim(),
      });

      try {
        await _service.updateFitnessGoal(_selectedFitnessGoal);
      } catch (e, stack) {
        debugPrint("FITNESS GOAL SAVE ERROR: $e");
        debugPrint("STACK: $stack");

        if (!mounted) return;

        setState(() {
          _saving = false;
          _error = l10n.myInfoFitnessGoalSaveError;
        });
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.myInfoUpdatedSuccessfully),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e, stack) {
      debugPrint("MY INFO SAVE ERROR: $e");
      debugPrint("STACK: $stack");

      if (!mounted) return;

      setState(() {
        _saving = false;
        _error = l10n.myInfoSaveError;
      });
    }
  }

  String _genderLabel(AppLocalizations l10n, String gender) {
    switch (gender) {
      case 'MALE':
        return l10n.myInfoGenderMale;
      case 'FEMALE':
        return l10n.myInfoGenderFemale;
      case 'OTHER':
        return l10n.myInfoGenderOther;
      case 'PREFER_NOT_TO_SAY':
        return l10n.myInfoGenderPreferNotToSay;
      default:
        return gender;
    }
  }

  String _fitnessGoalLabel(AppLocalizations l10n, String goal) {
    switch (goal) {
      case 'MUSCLE_GAIN':
        return l10n.fitnessGoalMuscleGain;
      case 'WEIGHT_LOSS':
        return l10n.fitnessGoalWeightLoss;
      case 'GENERAL_FITNESS':
        return l10n.fitnessGoalGeneralFitness;
      case 'ENDURANCE':
        return l10n.fitnessGoalEndurance;
      case 'FLEXIBILITY':
        return l10n.fitnessGoalFlexibility;
      case 'CONSISTENCY':
        return l10n.fitnessGoalConsistency;
      case 'WELLNESS':
        return l10n.fitnessGoalWellness;
      default:
        return goal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.label),
        title: Text(
          l10n.myInfoTitle,
          style: TextStyle(
            color: colors.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.myInfoSubtitle,
              style: tokens.typography.bodyMedium.copyWith(
                color: colors.muted,
              ),
            ),
            SizedBox(height: tokens.spacing.lg),

            if (_error != null) ...[
              _ErrorBox(message: _error!),
              SizedBox(height: tokens.spacing.md),
            ],

            _Label(text: l10n.myInfoPreferredBranch),
            SizedBox(height: tokens.spacing.sm),
            _branchDropdown(l10n),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoGender),
            SizedBox(height: tokens.spacing.sm),
            _genderChips(l10n),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoFitnessGoal),
            SizedBox(height: tokens.spacing.sm),
            _fitnessGoalChips(l10n),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoDateOfBirth),
            SizedBox(height: tokens.spacing.sm),
            _datePickerField(l10n),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoAddress),
            SizedBox(height: tokens.spacing.sm),
            _TextInput(
              controller: _addressController,
              hint: l10n.myInfoAddressHint,
              keyboardType: TextInputType.streetAddress,
              enabled: !_saving,
            ),
            SizedBox(height: tokens.spacing.lg),

            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.myInfoHeightCm,
                    controller: _heightController,
                    enabled: !_saving,
                  ),
                ),
                SizedBox(width: tokens.spacing.md),
                Expanded(
                  child: _NumberField(
                    label: l10n.myInfoWeightKg,
                    controller: _weightController,
                    enabled: !_saving,
                  ),
                ),
              ],
            ),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoEmergencyContactName),
            SizedBox(height: tokens.spacing.sm),
            _TextInput(
              controller: _emergencyNameController,
              hint: l10n.myInfoFullNameHint,
              keyboardType: TextInputType.name,
              enabled: !_saving,
            ),
            SizedBox(height: tokens.spacing.lg),

            _Label(text: l10n.myInfoEmergencyContactPhone),
            SizedBox(height: tokens.spacing.sm),
            _TextInput(
              controller: _emergencyPhoneController,
              hint: l10n.myInfoPhoneNumberHint,
              keyboardType: TextInputType.phone,
              enabled: !_saving,
            ),
            SizedBox(height: tokens.spacing.xl),

            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_saving || !_canSave) ? null : _saveInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    disabledBackgroundColor: colors.primary.withOpacity(0.4),
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tokens.button.radius),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    l10n.myInfoSaveChanges,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchDropdown(AppLocalizations l10n) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    final Map<int, Map<String, dynamic>> uniqueBranches = {};

    for (final branch in _branches) {
      final rawId = branch['id'];

      int? id;
      if (rawId is int) {
        id = rawId;
      } else if (rawId is num) {
        id = rawId.toInt();
      } else if (rawId != null) {
        id = int.tryParse(rawId.toString());
      }

      if (id != null && id > 0) {
        uniqueBranches[id] = branch;
      }
    }

    final items = uniqueBranches.entries.map((entry) {
      final id = entry.key;
      final branch = entry.value;

      return DropdownMenuItem<int>(
        value: id,
        child: Text(
          branch['name']?.toString() ?? 'Branch $id',
          style: TextStyle(color: colors.label),
        ),
      );
    }).toList();

    final selectedBranchIsValid = _selectedBranchId != null &&
        items.any((item) => item.value == _selectedBranchId);

    return DropdownButtonFormField<int>(
      value: selectedBranchIsValid ? _selectedBranchId : null,
      decoration: _inputDecoration(),
      dropdownColor: colors.surface,
      hint: Text(
        l10n.myInfoSelectBranch,
        style: TextStyle(color: colors.muted),
      ),
      items: items,
      onChanged: _saving
          ? null
          : (value) {
        setState(() {
          _selectedBranchId = value;
        });
      },
    );
  }

  Widget _genderChips(AppLocalizations l10n) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _genders.map((gender) {
        final selected = _selectedGender == gender;

        return ChoiceChip(
          label: Text(_genderLabel(l10n, gender)),
          selected: selected,
          onSelected: _saving
              ? null
              : (_) {
            setState(() {
              _selectedGender = gender;
            });
          },
          selectedColor: colors.primary.withOpacity(0.18),
          backgroundColor: colors.surface,
          side: BorderSide(
            color: selected ? colors.primary : colors.border.withOpacity(0.35),
          ),
          labelStyle: TextStyle(
            color: selected ? colors.primary : colors.label,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }

  Widget _fitnessGoalChips(AppLocalizations l10n) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _fitnessGoals.map((goal) {
        final selected = _selectedFitnessGoal == goal;

        return ChoiceChip(
          label: Text(_fitnessGoalLabel(l10n, goal)),
          selected: selected,
          onSelected: _saving
              ? null
              : (_) {
            setState(() {
              _selectedFitnessGoal = goal;
            });
          },
          selectedColor: colors.primary.withOpacity(0.18),
          backgroundColor: colors.surface,
          side: BorderSide(
            color: selected ? colors.primary : colors.border.withOpacity(0.35),
          ),
          labelStyle: TextStyle(
            color: selected ? colors.primary : colors.label,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }

  Widget _datePickerField(AppLocalizations l10n) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return InkWell(
      onTap: _saving ? null : _pickDateOfBirth,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: colors.primary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              _selectedDob == null
                  ? l10n.myInfoSelectDateOfBirth
                  : _formatDate(_selectedDob!),
              style: TextStyle(
                color: _selectedDob == null ? colors.muted : colors.label,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return InputDecoration(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.border.withOpacity(0.25),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.border.withOpacity(0.25),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.primary,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Text(
      text,
      style: tokens.typography.bodyMedium.copyWith(
        color: tokens.colors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StaticLabel extends StatelessWidget {
  final String text;

  const _StaticLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Text(
      text,
      style: tokens.typography.bodyMedium.copyWith(
        color: tokens.colors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final bool enabled;
  final TextEditingController controller;

  const _NumberField({
    required this.label,
    required this.enabled,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(text: label),
        SizedBox(height: tokens.spacing.sm),
        _TextInput(
          controller: controller,
          hint: '',
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
        ),
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _TextInput({
    required this.controller,
    required this.hint,
    required this.enabled,
    required this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: colors.label),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.muted),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.border.withOpacity(0.25),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.border.withOpacity(0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;

  const _ErrorBox({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.md),
      decoration: BoxDecoration(
        color: colors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.danger.withOpacity(0.25),
        ),
      ),
      child: Text(
        message,
        style: tokens.typography.bodySmall.copyWith(
          color: colors.danger,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}