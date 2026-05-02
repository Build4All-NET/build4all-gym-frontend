// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/add_edit_class_bottom_sheet.dart
//
// PURPOSE:
//   Scrollable modal bottom sheet for creating or editing a class session.
//   Title changes based on mode:
//     sessionId == null → "Add New Class" (create mode)
//     sessionId != null → "Edit Class"    (edit mode, pre-fills all fields)
//
// FIELDS:
//   1. Class Name         (required text field)
//   2. Type/Activity      (required dropdown — from ClassFormOptionsLoaded)
//   3. Trainer            (required dropdown)
//   4. Branch             (required dropdown)
//   5. Date               (required — DatePicker on tap)
//   6. Time               (required — TimePicker on tap)
//   7. Duration (minutes) (required numeric field)
//   8. Capacity           (required numeric field)
//   9. Room Name          (optional — ClassSession entity has roomName)
//  10. Notes/Description  (optional multi-line — BRD 8.2.10)
//
// DISPATCHES:
//   ClassFormOptionsRequested → on open (if not already loaded)
//   ClassCreateRequested      → Save tapped in add mode
//   ClassUpdateRequested      → Save tapped in edit mode
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/create_class_request_model.dart';
import '../../data/models/update_class_request_model.dart';
import '../../domain/entities/admin_class_card_entity.dart';
import '../../domain/entities/class_form_option_item_entity.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';

class AddEditClassBottomSheet extends StatefulWidget {
  final int?                  sessionId;   // null = add mode
  final AdminClassCardEntity? existing;    // pre-fill data in edit mode

  const AddEditClassBottomSheet({super.key, this.sessionId, this.existing});

  static void show(BuildContext context,
      {int? sessionId, AdminClassCardEntity? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminClassesBloc>(),
        child: AddEditClassBottomSheet(
            sessionId: sessionId, existing: existing),
      ),
    );
  }

  @override
  State<AddEditClassBottomSheet> createState() =>
      _AddEditClassBottomSheetState();
}

class _AddEditClassBottomSheetState extends State<AddEditClassBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers — one per text field
  late final TextEditingController _classNameCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _roomNameCtrl;
  late final TextEditingController _notesCtrl;

  // Dropdown selections
  ClassFormOptionItemEntity? _selectedType;
  ClassFormOptionItemEntity? _selectedTrainer;
  ClassFormOptionItemEntity? _selectedBranch;

  // Date + time selections
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool get _isEditMode => widget.sessionId != null;

  @override
  void initState() {
    super.initState();

    // Pre-fill from existing entity when in edit mode
    final e = widget.existing;
    _classNameCtrl = TextEditingController(text: e?.className ?? '');
    _durationCtrl  = TextEditingController(
        text: e != null ? e.durationMinutes.toString() : '');
    _capacityCtrl  = TextEditingController(
        text: e != null ? e.capacity.toString() : '');
    _roomNameCtrl  = TextEditingController(text: e?.roomName ?? '');
    _notesCtrl     = TextEditingController();

    // Load form options if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AdminClassesBloc>();
      if (bloc.state is! ClassFormOptionsLoaded) {
        bloc.add(const ClassFormOptionsRequested());
      }
    });
  }

  @override
  void dispose() {
    _classNameCtrl.dispose();
    _durationCtrl.dispose();
    _capacityCtrl.dispose();
    _roomNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')));
      return;
    }
    if (_selectedType == null || _selectedTrainer == null || _selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final timeStr =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final bloc = context.read<AdminClassesBloc>();

    if (_isEditMode) {
      bloc.add(ClassUpdateRequested(
        widget.sessionId!,
        UpdateClassRequestModel(
          className:       _classNameCtrl.text.trim(),
          classTypeId:     _selectedType!.id,
          trainerId:       _selectedTrainer!.id,
          branchId:        _selectedBranch!.id,
          date:            dateStr,
          time:            timeStr,
          durationMinutes: int.parse(_durationCtrl.text.trim()),
          capacity:        int.parse(_capacityCtrl.text.trim()),
          roomName:        _roomNameCtrl.text.trim().isEmpty
              ? null : _roomNameCtrl.text.trim(),
          notes:           _notesCtrl.text.trim().isEmpty
              ? null : _notesCtrl.text.trim(),
        ),
      ));
    } else {
      bloc.add(ClassCreateRequested(
        CreateClassRequestModel(
          className:       _classNameCtrl.text.trim(),
          classTypeId:     _selectedType!.id,
          trainerId:       _selectedTrainer!.id,
          branchId:        _selectedBranch!.id,
          date:            dateStr,
          time:            timeStr,
          durationMinutes: int.parse(_durationCtrl.text.trim()),
          capacity:        int.parse(_capacityCtrl.text.trim()),
          roomName:        _roomNameCtrl.text.trim().isEmpty
              ? null : _roomNameCtrl.text.trim(),
          notes:           _notesCtrl.text.trim().isEmpty
              ? null : _notesCtrl.text.trim(),
        ),
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AdminClassesBloc, AdminClassesState>(
      listener: (context, state) {
        // When form options load, the dropdowns rebuild automatically via BlocBuilder
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20, bottom: bottomInset + 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Sheet handle + title + close ─────────────────────────
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _isEditMode ? 'Edit Class' : 'Add New Class',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Field 1: Class Name ────────────────────────────────
                _FieldLabel('Class Name *'),
                _buildTextField(
                  controller: _classNameCtrl,
                  hint: 'e.g., Morning Yoga Flow',
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // ── Fields 2-4: Dropdowns (load from BLoC state) ──────
                BlocBuilder<AdminClassesBloc, AdminClassesState>(
                  builder: (context, state) {
                    if (state is ClassFormOptionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ClassFormOptionsLoaded) {
                      final options = state.options;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Type / Activity *'),
                          _buildDropdown(
                            items: options.classTypes,
                            value: _selectedType,
                            hint: 'Select type',
                            onChanged: (v) =>
                                setState(() => _selectedType = v),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel('Trainer *'),
                          _buildDropdown(
                            items: options.trainers,
                            value: _selectedTrainer,
                            hint: 'Select trainer',
                            onChanged: (v) =>
                                setState(() => _selectedTrainer = v),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel('Branch *'),
                          _buildDropdown(
                            items: options.branches,
                            value: _selectedBranch,
                            hint: 'Select branch',
                            onChanged: (v) =>
                                setState(() => _selectedBranch = v),
                          ),
                        ],
                      );
                    }
                    // Default: show empty dropdowns (options not yet loaded)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('Type / Activity *'),
                        _buildDropdown(items: [], value: null,
                            hint: 'Select type', onChanged: (_) {}),
                        const SizedBox(height: 16),
                        _FieldLabel('Trainer *'),
                        _buildDropdown(items: [], value: null,
                            hint: 'Select trainer', onChanged: (_) {}),
                        const SizedBox(height: 16),
                        _FieldLabel('Branch *'),
                        _buildDropdown(items: [], value: null,
                            hint: 'Select branch', onChanged: (_) {}),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Field 5: Date ──────────────────────────────────────
                _FieldLabel('Date *'),
                _buildTapField(
                  hint: 'mm/dd/yyyy',
                  icon: Icons.calendar_today_outlined,
                  value: _selectedDate != null
                      ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                      : null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // ── Field 6: Time ──────────────────────────────────────
                _FieldLabel('Time *'),
                _buildTapField(
                  hint: '--:--',
                  icon: Icons.access_time_outlined,
                  value: _selectedTime?.format(context),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),

                // ── Field 7: Duration ──────────────────────────────────
                _FieldLabel('Duration (minutes) *'),
                _buildTextField(
                  controller: _durationCtrl,
                  hint: 'e.g., 60',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null) return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Field 8: Capacity ──────────────────────────────────
                _FieldLabel('Capacity *'),
                _buildTextField(
                  controller: _capacityCtrl,
                  hint: 'Maximum participants',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null) return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Field 9: Room Name (optional) ──────────────────────
                _FieldLabel('Room Name'),
                _buildTextField(
                  controller: _roomNameCtrl,
                  hint: 'e.g., Hall 1, 2nd Floor',
                  validator: null, // optional
                ),
                const SizedBox(height: 16),

                // ── Field 10: Notes (optional, multi-line) ─────────────
                _FieldLabel('Notes / Description'),
                _buildTextField(
                  controller: _notesCtrl,
                  hint: 'e.g., Additional class notes',
                  maxLines: 3,
                  validator: null, // optional
                ),
                const SizedBox(height: 28),

                // ── Buttons: Cancel + Save Class ───────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Color(0xFF616161),
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Class',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
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

  // ── Reusable field builder helpers ─────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A1A2E), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required List<ClassFormOptionItemEntity> items,
    required ClassFormOptionItemEntity? value,
    required String hint,
    required void Function(ClassFormOptionItemEntity?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassFormOptionItemEntity>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item.name),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTapField({
    required String hint,
    required IconData icon,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: value != null
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFBDBDBD),
                  fontSize: 14,
                ),
              ),
            ),
            Icon(icon, size: 18, color: const Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}

// ── Field label helper widget ─────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
}