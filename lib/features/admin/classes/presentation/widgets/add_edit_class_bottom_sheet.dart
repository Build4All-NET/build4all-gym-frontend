// PATH: lib/features/admin/classes/presentation/widgets/add_edit_class_bottom_sheet.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../../core/config/env.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../../data/models/create_class_request_model.dart';
import '../../data/models/update_class_request_model.dart';
import '../../domain/entities/admin_class_card_entity.dart';
import '../../domain/entities/class_form_option_item_entity.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';

class AddEditClassBottomSheet extends StatefulWidget {
  final int?                  sessionId;
  final AdminClassCardEntity? existing;

  const AddEditClassBottomSheet({super.key, this.sessionId, this.existing});

  static void show(BuildContext context,
      {int? sessionId, AdminClassCardEntity? existing}) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
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

  late final TextEditingController _classNameCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _roomNameCtrl;
  late final TextEditingController _notesCtrl;

  ClassFormOptionItemEntity? _selectedType;
  ClassFormOptionItemEntity? _selectedTrainer;
  ClassFormOptionItemEntity? _selectedBranch;

  DateTime?  _selectedDate;
  TimeOfDay? _selectedTime;

  // ── Extra types created inline during this session ──────────────────────
  // Merged with options.classTypes for the dropdown
  final List<ClassFormOptionItemEntity> _newTypes = [];

  bool get _isEditMode => widget.sessionId != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _classNameCtrl = TextEditingController(text: e?.className ?? '');
    _durationCtrl  = TextEditingController(
        text: e != null ? e.durationMinutes.toString() : '');
    _capacityCtrl  = TextEditingController(
        text: e != null ? e.capacity.toString() : '');
    _roomNameCtrl  = TextEditingController(text: e?.roomName ?? '');
    _notesCtrl     = TextEditingController();

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

  // ── Create Class Type inline ──────────────────────────────────────────────
  // Opens a dialog where admin types a name + duration + difficulty + price
  // Calls POST /api/admin/classes/types → saves to DB → adds to dropdown
  Future<void> _showCreateTypeDialog() async {
    final nameCtrl     = TextEditingController();
    final durationCtrl = TextEditingController();
    final priceCtrl    = TextEditingController(text: '0');
    String difficulty  = 'BEGINNER';
    final formKey      = GlobalKey<FormState>();

    final result = await showDialog<ClassFormOptionItemEntity>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Class Type',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  const Text('Name *',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: _dialogDeco('e.g. Yoga, CrossFit'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Duration
                  const Text('Duration (minutes) *',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller:   durationCtrl,
                    keyboardType: TextInputType.number,
                    decoration:   _dialogDeco('e.g. 60'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (int.tryParse(v.trim()) == null)
                        return 'Must be a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Difficulty
                  const Text('Difficulty Level',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value:      difficulty,
                    decoration: _dialogDeco(''),
                    items: const [
                      DropdownMenuItem(
                          value: 'BEGINNER',
                          child: Text('Beginner')),
                      DropdownMenuItem(
                          value: 'INTERMEDIATE',
                          child: Text('Intermediate')),
                      DropdownMenuItem(
                          value: 'ADVANCED',
                          child: Text('Advanced')),
                    ],
                    onChanged: (v) =>
                        setDialogState(() => difficulty = v ?? 'BEGINNER'),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  const Text('Price',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller:   priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: _dialogDeco('0.00'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (double.tryParse(v.trim()) == null)
                        return 'Must be a number';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child:     const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E)),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                // Call backend
                final newType = await _createClassTypeOnBackend(
                  name:            nameCtrl.text.trim(),
                  durationMinutes: int.parse(durationCtrl.text.trim()),
                  difficultyLevel: difficulty,
                  price:           double.tryParse(priceCtrl.text.trim()) ?? 0,
                );

                if (newType != null && ctx.mounted) {
                  Navigator.of(ctx).pop(newType);
                } else if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create class type'),
                      backgroundColor: Color(0xFFF44336),
                    ),
                  );
                }
              },
              child: const Text('Create',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    // If type was created — add to local list and auto-select it
    if (result != null && mounted) {
      setState(() {
        _newTypes.add(result);
        _selectedType = result;
      });
    }
  }

  // ── POST /api/admin/classes/types ─────────────────────────────────────────
  Future<ClassFormOptionItemEntity?> _createClassTypeOnBackend({
    required String name,
    required int    durationMinutes,
    required String difficultyLevel,
    required double price,
  }) async {
    try {
      final tokenStore = const AdminTokenStore();
      final token      = await tokenStore.getToken();
      if (token == null) return null;

      final r = await http.post(
        Uri.parse('${Env.apiProjectBaseUrl}/api/admin/classes/types'),
        headers: {
          'Authorization':           'Bearer $token',
          'Content-Type':            'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
        body: jsonEncode({
          'name':            name,
          'durationMinutes': durationMinutes,
          'difficultyLevel': difficultyLevel,
          'price':           price,
        }),
      );

      if (r.statusCode == 201) {
        final json = jsonDecode(r.body) as Map<String, dynamic>;
        return ClassFormOptionItemEntity(
          id:   json['id']   as int,
          name: json['name'] as String,
        );
      }

      // 409 = duplicate name
      if (r.statusCode == 409 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text('$name already exists — select it from the dropdown'),
            backgroundColor: const Color(0xFFFF9800),
          ),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context:     context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate:   DateTime.now().subtract(const Duration(days: 30)),
      lastDate:    DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context:     context,
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
    if (_selectedType == null ||
        _selectedTrainer == null ||
        _selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final timeStr =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime!.minute.toString().padLeft(2, '0')}';

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
      listener: (context, state) {},
      child: Container(
        decoration: const BoxDecoration(
          color:        Colors.white,
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

                // Handle + title
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color:        const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _isEditMode ? 'Edit Class' : 'Add New Class',
                      style: const TextStyle(
                          fontSize:   18,
                          fontWeight: FontWeight.w700,
                          color:      Color(0xFF1A1A2E)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon:      const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Class Name
                _FieldLabel('Class Name *'),
                _buildTextField(
                  controller: _classNameCtrl,
                  hint:       'e.g., Morning Yoga Flow',
                  validator:  (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Dropdowns
                BlocBuilder<AdminClassesBloc, AdminClassesState>(
                  builder: (context, state) {
                    if (state is ClassFormOptionsLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (state is ClassFormOptionsLoaded) {
                      final options = state.options;

                      // Merge loaded types + any newly created ones
                      final allTypes = [
                        ...options.classTypes,
                        ..._newTypes.where((n) => !options.classTypes
                            .any((t) => t.id == n.id)),
                      ];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Type / Activity with + Create button ────────
                          Row(
                            children: [
                              const Expanded(
                                  child: _FieldLabel('Type / Activity *')),
                              // + Create New Type button
                              TextButton.icon(
                                icon:      const Icon(Icons.add, size: 14),
                                label:     const Text('New Type',
                                    style: TextStyle(fontSize: 12)),
                                onPressed: _showCreateTypeDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: const Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                          _buildDropdown(
                            items:     allTypes,
                            value:     _selectedType,
                            hint:      'Select type',
                            onChanged: (v) =>
                                setState(() => _selectedType = v),
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel('Trainer *'),
                          _buildDropdown(
                            items:     options.trainers,
                            value:     _selectedTrainer,
                            hint:      'Select trainer',
                            onChanged: (v) =>
                                setState(() => _selectedTrainer = v),
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel('Branch *'),
                          _buildDropdown(
                            items:     options.branches,
                            value:     _selectedBranch,
                            hint:      'Select branch',
                            onChanged: (v) =>
                                setState(() => _selectedBranch = v),
                          ),
                        ],
                      );
                    }
                    // Not yet loaded
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                                child: _FieldLabel('Type / Activity *')),
                            TextButton.icon(
                              icon:      const Icon(Icons.add, size: 14),
                              label:     const Text('New Type',
                                  style: TextStyle(fontSize: 12)),
                              onPressed: _showCreateTypeDialog,
                              style: TextButton.styleFrom(
                                padding:         EdgeInsets.zero,
                                foregroundColor: const Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
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

                // Date
                _FieldLabel('Date *'),
                _buildTapField(
                  hint:  'mm/dd/yyyy',
                  icon:  Icons.calendar_today_outlined,
                  value: _selectedDate != null
                      ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                      : null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Time
                _FieldLabel('Time *'),
                _buildTapField(
                  hint:  '--:--',
                  icon:  Icons.access_time_outlined,
                  value: _selectedTime?.format(context),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),

                // Duration
                _FieldLabel('Duration (minutes) *'),
                _buildTextField(
                  controller:   _durationCtrl,
                  hint:         'e.g., 60',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Capacity
                _FieldLabel('Capacity *'),
                _buildTextField(
                  controller:   _capacityCtrl,
                  hint:         'Maximum participants',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Room Name
                _FieldLabel('Room Name'),
                _buildTextField(
                  controller: _roomNameCtrl,
                  hint:       'e.g., Hall 1, 2nd Floor',
                  validator:  null,
                ),
                const SizedBox(height: 16),

                // Notes
                _FieldLabel('Notes / Description'),
                _buildTextField(
                  controller: _notesCtrl,
                  hint:       'e.g., Additional class notes',
                  maxLines:   3,
                  validator:  null,
                ),
                const SizedBox(height: 28),

                // Buttons
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
                                color:      Color(0xFF616161),
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
                                color:      Colors.white,
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

  // ── Helpers ───────────────────────────────────────────────────────────────
  InputDecoration _dialogDeco(String hint) => InputDecoration(
    hintText:       hint,
    isDense:        true,
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:   const BorderSide(color: Color(0xFFE0E0E0)),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboardType,
      maxLines:     maxLines,
      validator:    validator,
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
        filled:    true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFF1A1A2E), width: 1.5),
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
    // Guard: if value not in items, reset to null
    final safeValue =
    items.any((i) => i.id == value?.id) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color:        const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassFormOptionItemEntity>(
          value:      safeValue,
          isExpanded: true,
          hint: Text(hint,
              style: const TextStyle(
                  color: Color(0xFFBDBDBD), fontSize: 14)),
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
          color:        const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: const Color(0xFFE0E0E0)),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w600,
            color:      Color(0xFF424242),
          )),
    );
  }
}