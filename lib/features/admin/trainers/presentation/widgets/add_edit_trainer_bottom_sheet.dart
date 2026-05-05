// lib/features/admin/trainers/presentation/widgets/add_edit_trainer_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../data/models/create_trainer_request_model.dart';
import '../../data/models/trainer_availability_model.dart';
import '../../data/models/update_trainer_request_model.dart';
import '../../domain/entities/AdminTrainerDetailEntity.dart';
import '../../domain/entities/trainer_form_options_entity.dart';

class AddEditTrainerBottomSheet extends StatefulWidget {
  final int?                      trainerId;
  final TrainerFormOptionsEntity  options;
  final AdminTrainerDetailEntity? detail;
  final void Function(CreateTrainerRequestModel) onCreate;
  final void Function(int, UpdateTrainerRequestModel) onUpdate;

  const AddEditTrainerBottomSheet({
    super.key,
    this.trainerId,
    required this.options,
    this.detail,
    required this.onCreate,
    required this.onUpdate,
  });

  static void show(
      BuildContext context, {
        int?                      trainerId,
        required TrainerFormOptionsEntity options,
        AdminTrainerDetailEntity? detail,
        required void Function(CreateTrainerRequestModel) onCreate,
        required void Function(int, UpdateTrainerRequestModel) onUpdate,
      }) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => AddEditTrainerBottomSheet(
        trainerId: trainerId,
        options:   options,
        detail:    detail,
        onCreate:  onCreate,
        onUpdate:  onUpdate,
      ),
    );
  }

  @override
  State<AddEditTrainerBottomSheet> createState() =>
      _AddEditTrainerBottomSheetState();
}

class _AddEditTrainerBottomSheetState
    extends State<AddEditTrainerBottomSheet> {

  final _formKey       = GlobalKey<FormState>();
  final _fullNameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _phoneCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _yearsCtrl     = TextEditingController();
  final _notesCtrl     = TextEditingController();
  final _specialtyCtrl = TextEditingController();

  bool         _obscurePassword = true;
  bool         _isSubmitting    = false;
  List<String> _specialties     = [];
  int?         _selectedBranchId;

  final List<_AvailabilitySlot> _slots = [];

  bool get _isEditMode => widget.trainerId != null;

  @override
  void initState() {
    super.initState();
    _prefillFromDetail();
  }

  void _prefillFromDetail() {
    final d = widget.detail;
    if (d == null) return;

    _fullNameCtrl.text = d.fullName;
    _emailCtrl.text    = d.email    ?? '';
    _phoneCtrl.text    = d.phone    ?? '';
    _yearsCtrl.text    = d.yearsOfExperience?.toString() ?? '';
    _notesCtrl.text    = d.notes    ?? '';
    _specialties       = List<String>.from(d.specialties);
    _selectedBranchId  = d.branchIds.isNotEmpty ? d.branchIds.first : null;

    for (final slot in d.availabilitySchedule) {
      final s = _AvailabilitySlot();
      s.weekday   = slot.weekday;
      s.startTime = _parseTime(slot.startTime);
      s.endTime   = _parseTime(slot.endTime);
      _slots.add(s);
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _yearsCtrl.dispose();
    _notesCtrl.dispose();
    _specialtyCtrl.dispose();
    super.dispose();
  }

  // ── Specialty helpers ─────────────────────────────────────────────────────
  void _addSpecialty(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (_specialties.contains(trimmed)) {
      _specialtyCtrl.clear();
      return;
    }
    setState(() {
      _specialties.add(trimmed);
      _specialtyCtrl.clear();
    });
  }

  void _removeSpecialty(String value) =>
      setState(() => _specialties.remove(value));

  // ── Availability helpers ──────────────────────────────────────────────────
  void _addSlot() => setState(() => _slots.add(_AvailabilitySlot()));

  void _removeSlot(int i) => setState(() => _slots.removeAt(i));

  Future<void> _pickTime(int i, bool isStart) async {
    final slot    = _slots[i];
    final initial = isStart
        ? (slot.startTime ?? const TimeOfDay(hour: 8,  minute: 0))
        : (slot.endTime   ?? const TimeOfDay(hour: 17, minute: 0));
    final picked = await showTimePicker(
        context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) _slots[i].startTime = picked;
      else         _slots[i].endTime   = picked;
    });
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '--:--';
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour:   int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────
  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a branch')));
      return;
    }

    setState(() => _isSubmitting = true);

    final schedule = _slots
        .where((s) =>
    s.weekday != null && s.startTime != null && s.endTime != null)
        .map((s) => TrainerAvailabilityModel(
      weekday:   s.weekday!,
      startTime: _formatTime(s.startTime),
      endTime:   _formatTime(s.endTime),
    ))
        .toList();

    if (_isEditMode) {
      widget.onUpdate(
        widget.trainerId!,
        UpdateTrainerRequestModel(
          fullName:             _fullNameCtrl.text.trim(),
          email:                _emailCtrl.text.trim().isEmpty
              ? null : _emailCtrl.text.trim(),
          phone:                _phoneCtrl.text.trim().isEmpty
              ? null : _phoneCtrl.text.trim(),
          specialties:          _specialties,
          branchIds:            [_selectedBranchId!],
          availabilitySchedule: schedule,
          yearsOfExperience:    int.tryParse(_yearsCtrl.text),
          notes:                _notesCtrl.text.trim().isEmpty
              ? null : _notesCtrl.text.trim(),
        ),
      );
    } else {
      widget.onCreate(
        CreateTrainerRequestModel(
          fullName:             _fullNameCtrl.text.trim(),
          email:                _emailCtrl.text.trim().isEmpty
              ? null : _emailCtrl.text.trim(),
          phone:                _phoneCtrl.text.trim().isEmpty
              ? null : _phoneCtrl.text.trim(),
          password:             _passwordCtrl.text,
          specialties:          _specialties,
          branchIds:            [_selectedBranchId!],
          availabilitySchedule: schedule,
          yearsOfExperience:    int.tryParse(_yearsCtrl.text),
          notes:                _notesCtrl.text.trim().isEmpty
              ? null : _notesCtrl.text.trim(),
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    final safeBranchId = widget.options.branches
        .any((b) => b.id == _selectedBranchId)
        ? _selectedBranchId : null;

    const gap = SizedBox(height: 14);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize:     0.5,
      maxChildSize:     0.97,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color:        c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color:        c.border.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    _isEditMode ? 'Edit Trainer' : 'Add New Trainer',
                    style: TextStyle(
                      fontSize:   18,
                      fontWeight: FontWeight.w700,
                      color:      c.label,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:      Icon(Icons.close, color: c.muted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            Divider(color: c.border.withOpacity(0.3)),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [

                    _label('Full Name *', c),
                    TextFormField(
                      controller: _fullNameCtrl,
                      style:      TextStyle(color: c.label),
                      decoration: _deco('Enter full name', c),
                      validator:  (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    gap,

                    _label('Email', c),
                    TextFormField(
                      controller:   _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style:        TextStyle(color: c.label),
                      decoration:   _deco('trainer@gym.com', c),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    gap,

                    _label('Phone Number', c),
                    TextFormField(
                      controller:   _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style:        TextStyle(color: c.label),
                      decoration:   _deco('+961 XX XXX XXX', c),
                    ),
                    gap,

                    if (!_isEditMode) ...[
                      _label('Password *', c),
                      TextFormField(
                        controller:  _passwordCtrl,
                        obscureText: _obscurePassword,
                        style:       TextStyle(color: c.label),
                        decoration:  _deco('Min 6 characters', c).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: c.muted,
                            ),
                            onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Min 6 characters' : null,
                      ),
                      gap,
                    ],

                    // ── Specialties ──────────────────────────────────────
                    _label('Specialties', c),
                    _SpecialtyInput(
                      c:           c,
                      controller:  _specialtyCtrl,
                      specialties: _specialties,
                      suggestions: widget.options.specialties,
                      onAdd:       _addSpecialty,
                      onRemove:    _removeSpecialty,
                    ),
                    gap,

                    _label('Branch Assignment *', c),
                    DropdownButtonFormField<int>(
                      value:      safeBranchId,
                      decoration: _deco('Select branch', c),
                      items: widget.options.branches
                          .map((b) => DropdownMenuItem(
                          value: b.id, child: Text(b.name)))
                          .toList(),
                      onChanged:  (v) =>
                          setState(() => _selectedBranchId = v),
                      validator:  (v) =>
                      v == null ? 'Please select a branch' : null,
                    ),
                    gap,

                    _label('Years of Experience', c),
                    TextFormField(
                      controller:   _yearsCtrl,
                      keyboardType: TextInputType.number,
                      style:        TextStyle(color: c.label),
                      decoration:   _deco('e.g. 5', c),
                    ),
                    gap,

                    _label('Notes / Bio', c),
                    TextFormField(
                      controller: _notesCtrl,
                      maxLines:   3,
                      style:      TextStyle(color: c.label),
                      decoration: _deco('Optional bio or notes', c),
                    ),

                    const SizedBox(height: 20),

                    // Availability schedule
                    Row(
                      children: [
                        Text(
                          'Availability Schedule',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize:   14,
                            color:      c.label,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          icon:      Icon(Icons.add, size: 16, color: c.primary),
                          label:     Text('Add Slot',
                              style: TextStyle(color: c.primary)),
                          onPressed: _addSlot,
                        ),
                      ],
                    ),

                    if (_slots.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No availability slots yet.',
                          style: TextStyle(fontSize: 12, color: c.muted),
                        ),
                      )
                    else
                      ..._slots.asMap().entries.map((entry) {
                        final i    = entry.key;
                        final slot = entry.value;
                        return _AvailabilitySlotRow(
                          c:          c,
                          slot:       slot,
                          onPickStart: () => _pickTime(i, true),
                          onPickEnd:   () => _pickTime(i, false),
                          onDelete:    () => _removeSlot(i),
                          onWeekday: (v) =>
                              setState(() => _slots[i].weekday = v),
                          startLabel: _formatTime(slot.startTime),
                          endLabel:   _formatTime(slot.endTime),
                        );
                      }),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: c.body,
                              side: BorderSide(color: c.border.withOpacity(0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _onSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.label,
                              foregroundColor: c.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  color: c.onPrimary, strokeWidth: 2),
                            )
                                : Text(
                              _isEditMode ? 'Save Changes' : 'Save Trainer',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, ColorTokens c) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize:   13,
        fontWeight: FontWeight.w600,
        color:      c.body,
      ),
    ),
  );

  InputDecoration _deco(String hint, ColorTokens c) => InputDecoration(
    hintText:       hint,
    hintStyle:      TextStyle(color: c.muted),
    filled:         true,
    fillColor:      c.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:   BorderSide(color: c.border.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:   BorderSide(color: c.border.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:   BorderSide(color: c.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:   BorderSide(color: c.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:   BorderSide(color: c.error, width: 1.5),
    ),
  );
}


// ─────────────────────────────────────────────────────────────────────────────
// _SpecialtyInput
// ─────────────────────────────────────────────────────────────────────────────
class _SpecialtyInput extends StatelessWidget {
  const _SpecialtyInput({
    required this.c,
    required this.controller,
    required this.specialties,
    required this.suggestions,
    required this.onAdd,
    required this.onRemove,
  });

  final ColorTokens           c;
  final TextEditingController controller;
  final List<String>          specialties;
  final List<String>          suggestions;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    final filteredSuggestions = suggestions
        .where((s) => !specialties.contains(s))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return [];
                  return filteredSuggestions.where((s) => s
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (value) => onAdd(value),
                fieldViewBuilder: (ctx, autoCtrl, focusNode, onSubmitted) {
                  return TextField(
                    controller: autoCtrl,
                    focusNode:  focusNode,
                    style:      TextStyle(color: c.label),
                    decoration: InputDecoration(
                      hintText:       'e.g. Yoga, CrossFit…',
                      hintStyle:      TextStyle(color: c.muted),
                      filled:         true,
                      fillColor:      c.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:   BorderSide(color: c.border.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:   BorderSide(color: c.border.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:   BorderSide(color: c.primary, width: 1.5),
                      ),
                    ),
                    onSubmitted: (value) {
                      onAdd(value);
                      autoCtrl.clear();
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            // + button
            GestureDetector(
              onTap: () => onAdd(controller.text),
              child: Container(
                width:  48,
                height: 48,
                decoration: BoxDecoration(
                  color:        c.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add, color: c.onPrimary, size: 22),
              ),
            ),
          ],
        ),

        if (specialties.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing:    6,
            runSpacing: 6,
            children: specialties.map((s) => Chip(
              label: Text(
                s,
                style: TextStyle(
                    fontSize: 12,
                    color:    c.primary),
              ),
              deleteIcon: Icon(Icons.close, size: 14, color: c.primary),
              onDeleted:  () => onRemove(s),
              backgroundColor: c.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: c.primary.withOpacity(0.4)),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList(),
          ),
        ],

        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            specialties.isEmpty
                ? 'Type a specialty and press + or Enter to add'
                : '${specialties.length} specialty added',
            style: TextStyle(fontSize: 11, color: c.muted),
          ),
        ),
      ],
    );
  }
}


// ── Mutable slot state ────────────────────────────────────────────────────────
class _AvailabilitySlot {
  int?       weekday;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}

const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday',
  'Friday', 'Saturday', 'Sunday',
];

// ── Slot row ──────────────────────────────────────────────────────────────────
class _AvailabilitySlotRow extends StatelessWidget {
  const _AvailabilitySlotRow({
    required this.c,
    required this.slot,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onDelete,
    required this.onWeekday,
    required this.startLabel,
    required this.endLabel,
  });

  final ColorTokens        c;
  final _AvailabilitySlot  slot;
  final VoidCallback       onPickStart;
  final VoidCallback       onPickEnd;
  final VoidCallback       onDelete;
  final ValueChanged<int?> onWeekday;
  final String             startLabel;
  final String             endLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:        c.background,
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: c.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value:      slot.weekday,
                hint:       Text('Day',
                    style: TextStyle(fontSize: 12, color: c.muted)),
                isExpanded: true,
                items: List.generate(7, (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_weekdays[i],
                        style: TextStyle(fontSize: 12, color: c.label)))),
                onChanged: onWeekday,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onPickStart,
              child: _timeBox(startLabel, c),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('–', style: TextStyle(color: c.muted)),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onPickEnd,
              child: _timeBox(endLabel, c),
            ),
          ),
          IconButton(
            icon:        Icon(Icons.delete_outline,
                size: 18, color: c.danger),
            onPressed:   onDelete,
            padding:     EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String label, ColorTokens c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    decoration: BoxDecoration(
      color:        c.surface,
      borderRadius: BorderRadius.circular(8),
      border:       Border.all(color: c.border.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style:     TextStyle(fontSize: 12, color: c.label),
      textAlign: TextAlign.center,
    ),
  );
}