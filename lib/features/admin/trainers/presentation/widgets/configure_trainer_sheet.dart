import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/AppBar/data/models/branch_option_model.dart';
import '../../../../admin/AppBar/presentation/branch_cubit.dart';
import '../../data/services/admin_trainers_service.dart';

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
      builder: (_) => BlocProvider.value(
        value: context.read<BranchCubit>(),
        child: ConfigureTrainerSheet(
          userId:       userId,
          trainerName:  trainerName,
          onConfigured: onConfigured,
        ),
      ),
    );
  }

  @override
  State<ConfigureTrainerSheet> createState() => _ConfigureTrainerSheetState();
}

class _ConfigureTrainerSheetState extends State<ConfigureTrainerSheet> {
  final _service            = AdminTrainersService();
  final _yearsController    = TextEditingController();
  final _notesController    = TextEditingController();
  final _specialtyController = TextEditingController();

  Set<int>     _selectedBranchIds = {};
  List<String> _specialties       = [];
  bool         _submitting        = false;
  String?      _error;

  @override
  void dispose() {
    _yearsController.dispose();
    _notesController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  void _addSpecialty() {
    final val = _specialtyController.text.trim();
    if (val.isEmpty || _specialties.contains(val)) return;
    setState(() => _specialties.add(val));
    _specialtyController.clear();
  }

  Future<void> _submit() async {
    if (_selectedBranchIds.isEmpty) {
      setState(() => _error = 'Select at least one branch.');
      return;
    }
    setState(() { _submitting = true; _error = null; });

    final years = int.tryParse(_yearsController.text.trim());

    try {
      await _service.configureTrainer(widget.userId, {
        'branchIds':            _selectedBranchIds.toList(),
        'specialties':          _specialties,
        'yearsOfExperience':    years,
        'notes':                _notesController.text.trim().isEmpty
                                    ? null
                                    : _notesController.text.trim(),
        'availabilitySchedule': [],
      });
      if (!mounted) return;
      Navigator.pop(context);
      widget.onConfigured();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.trainerName} is fully set up as a trainer.'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (mounted) setState(() { _submitting = false; _error = 'Failed to save. Please try again.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final mq     = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.9,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle ────────────────────────────────────────────────────────
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
                      Text('Set Up Trainer Profile',
                          style: TextStyle(
                            color: c.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      Text(widget.trainerName,
                          style: TextStyle(color: c.onPrimary, fontSize: 12)),
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

          // ── Scrollable body ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, mq.padding.bottom + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Branch selection ─────────────────────────────────────
                  _sectionLabel('Branches *', c),
                  const SizedBox(height: 8),
                  BlocBuilder<BranchCubit, BranchState>(
                    builder: (_, state) {
                      if (state is BranchLoading) {
                        return CircularProgressIndicator(color: c.primary);
                      }
                      if (state is BranchLoaded) {
                        return _branchChips(state.branches, c);
                      }
                      return Text('Could not load branches.',
                          style: TextStyle(color: c.onPrimary, fontSize: 13));
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Specialties ──────────────────────────────────────────
                  _sectionLabel('Specialties', c),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _specialtyController,
                          hint: 'e.g. Fat Loss, Strength…',
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
                      children: _specialties.map((s) => _specialtyChip(s, c)).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ── Years of experience ──────────────────────────────────
                  _sectionLabel('Years of Experience', c),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _yearsController,
                    hint: 'e.g. 5',
                    c: c,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),

                  // ── Notes / Bio ──────────────────────────────────────────
                  _sectionLabel('Bio / Notes (optional)', c),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _notesController,
                    hint: 'Brief bio or admin notes…',
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
                          ? SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Save & Finish',
                              style: TextStyle(
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

  Widget _branchChips(List<BranchOptionModel> branches, dynamic c) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: branches.map((b) {
        final selected = _selectedBranchIds.contains(b.id);
        return FilterChip(
          label: Text(b.name),
          selected: selected,
          onSelected: (_) => setState(() {
            if (selected) {
              _selectedBranchIds.remove(b.id);
            } else {
              _selectedBranchIds.add(b.id);
            }
          }),
          selectedColor: c.primary.withOpacity(0.2),
          checkmarkColor: c.primary,
          labelStyle: TextStyle(
            color: selected ? c.primary : c.onPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
          backgroundColor: c.background,
          side: BorderSide(
            color: selected ? c.primary : c.border.withOpacity(0.3),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _sectionLabel(String text, dynamic c) {
    return Text(text,
        style: TextStyle(
          color: c.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ));
  }

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
      controller:       controller,
      keyboardType:     keyboardType,
      inputFormatters:  inputFormatters,
      maxLines:         maxLines,
      onSubmitted:      onSubmitted,
      style:            TextStyle(color: c.primary),
      decoration: InputDecoration(
        hintText:     hint,
        hintStyle:    TextStyle(color: c.onPrimary),
        filled:       true,
        fillColor:    c.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: c.border.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: c.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: c.primary),
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
          color: c.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}