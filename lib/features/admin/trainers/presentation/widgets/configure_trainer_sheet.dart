import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/data/models/branch_option_model.dart';
import '../../../../admin/AppBar/data/services/admin_branches_service.dart';
import '../../data/services/admin_trainers_service.dart';
import '../../../../../l10n/app_localizations.dart';

class ConfigureTrainerSheet extends StatefulWidget {
  final int    userId;
  final String trainerName;
  final VoidCallback onConfigured;

  const ConfigureTrainerSheet({
    super.key,
    required this.userId,
    required this.trainerName,
    required this.onConfigured,
  });

  static Future<void> show(
    BuildContext context, {
    required int userId,
    required String trainerName,
    required VoidCallback onConfigured,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfigureTrainerSheet(
        userId:       userId,
        trainerName:  trainerName,
        onConfigured: onConfigured,
      ),
    );
  }

  @override
  State<ConfigureTrainerSheet> createState() => _ConfigureTrainerSheetState();
}

class _ConfigureTrainerSheetState extends State<ConfigureTrainerSheet> {
  final _trainersService  = AdminTrainersService();
  final _branchesService  = AdminBranchesService();
  final _yearsController      = TextEditingController();
  final _notesController      = TextEditingController();
  final _specialtyController  = TextEditingController();

  List<BranchOptionModel> _branches        = [];
  Set<int>                _selectedBranches = {};
  List<String>            _specialties     = [];
  bool                    _loadingBranches = true;
  bool                    _submitting      = false;
  String?                 _error;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  @override
  void dispose() {
    _yearsController.dispose();
    _notesController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    try {
      final branches = await _branchesService.getBranches();
      if (mounted) setState(() { _branches = branches; _loadingBranches = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingBranches = false);
    }
  }

  void _addSpecialty() {
    final val = _specialtyController.text.trim();
    if (val.isEmpty || _specialties.contains(val)) return;
    setState(() => _specialties.add(val));
    _specialtyController.clear();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedBranches.isEmpty) {
      setState(() => _error = l10n.configureTrainer_selectBranchError);
      return;
    }
    setState(() { _submitting = true; _error = null; });

    final years = int.tryParse(_yearsController.text.trim());
    final notes = _notesController.text.trim();

    try {
      await _trainersService.configureTrainer(widget.userId, {
        'branchIds':            _selectedBranches.toList(),
        'specialties':          _specialties,
        'yearsOfExperience':    years,
        'notes':                notes.isEmpty ? null : notes,
        'availabilitySchedule': [],
      });
      if (!mounted) return;
      Navigator.pop(context);
      widget.onConfigured();
      AppToast.success(context, l10n.configureTrainer_setupSuccess(widget.trainerName));
    } catch (e) {
      if (mounted) setState(() { _submitting = false; _error = l10n.configureTrainer_saveFailed; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final mq     = MediaQuery.of(context);
    final l10n   = AppLocalizations.of(context)!;

    return Container(
      height: mq.size.height * 0.9,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: c.border.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: c.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune_rounded, color: c.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.configureTrainer_title,
                          style: TextStyle(
                            color: c.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      Text(widget.trainerName,
                          style: TextStyle(color: c.body, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(_error!,
                  style: TextStyle(color: c.error ?? Colors.red, fontSize: 12)),
            ),

          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, mq.padding.bottom + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Branch selection ─────────────────────────────────────
                  _sectionLabel(l10n.configureTrainer_branchesLabel, c),
                  const SizedBox(height: 8),
                  _loadingBranches
                      ? Center(child: CircularProgressIndicator(color: c.primary))
                      : _branches.isEmpty
                          ? Text(l10n.configureTrainer_noBranchesFound,
                              style: TextStyle(color: c.body, fontSize: 13))
                          : _branchChips(c),
                  const SizedBox(height: 20),

                  // ── Specialties ──────────────────────────────────────────
                  _sectionLabel(l10n.configureTrainer_specialtiesLabel, c),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _specialtyController,
                          hint: l10n.configureTrainer_specialtyHint,
                          c: c,
                          onSubmitted: (_) => _addSpecialty(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _addButton(c, _addSpecialty),
                    ],
                  ),
                  if (_specialties.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _specialties
                          .map((s) => _specialtyChip(s, c))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ── Years of experience ──────────────────────────────────
                  _sectionLabel(l10n.configureTrainer_yearsLabel, c),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _yearsController,
                    hint: l10n.configureTrainer_yearsHint,
                    c: c,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),

                  // ── Notes ────────────────────────────────────────────────
                  _sectionLabel(l10n.configureTrainer_notesLabel, c),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _notesController,
                    hint: l10n.configureTrainer_notesHint,
                    c: c,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),

                  // ── Submit ───────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(l10n.configureTrainer_saveButton,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
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

  Widget _branchChips(dynamic c) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _branches.map((b) {
        final selected = _selectedBranches.contains(b.id);
        return FilterChip(
          label: Text(b.name),
          selected: selected,
          onSelected: (_) => setState(() {
            selected ? _selectedBranches.remove(b.id) : _selectedBranches.add(b.id);
          }),
          selectedColor: c.primary.withOpacity(0.2),
          checkmarkColor: c.primary,
          labelStyle: TextStyle(
            color: selected ? c.primary : c.body,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
          backgroundColor: c.background,
          side: BorderSide(
              color: selected ? c.primary : c.border.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        );
      }).toList(),
    );
  }

  Widget _specialtyChip(String label, dynamic c) {
    return Chip(
      label: Text(label, style: TextStyle(color: c.primary, fontSize: 12)),
      backgroundColor: c.primary.withOpacity(0.1),
      side: BorderSide(color: c.primary.withOpacity(0.3)),
      deleteIconColor: c.onPrimary,
      onDeleted: () => setState(() => _specialties.remove(label)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _sectionLabel(String text, dynamic c) => Text(text,
      style: TextStyle(
          color: c.primary, fontWeight: FontWeight.w600, fontSize: 14));

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required dynamic c,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller:      controller,
      keyboardType:    keyboardType,
      inputFormatters: inputFormatters,
      maxLines:        maxLines,
      onSubmitted:     onSubmitted,
      style:           TextStyle(color: c.primary),
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: TextStyle(color: c.muted),
        filled:    true,
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

  Widget _addButton(dynamic c, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
            color: c.primary, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
