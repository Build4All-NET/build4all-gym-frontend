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
import '../../../../../common/widgets/app_toast.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';

class AddEditClassBottomSheet extends StatefulWidget {
  final int? sessionId;
  final AdminClassCardEntity? existing;
  final DateTime? existingDate;

  const AddEditClassBottomSheet({super.key, this.sessionId, this.existing, this.existingDate});

  static void show(BuildContext context,
      {int? sessionId, AdminClassCardEntity? existing, DateTime? existingDate}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminClassesBloc>(),
        child: AddEditClassBottomSheet(
            sessionId: sessionId, existing: existing, existingDate: existingDate),
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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<ClassFormOptionItemEntity> _newTypes = [];
  bool _optionsInitialized = false;

  bool get _isEditMode => widget.sessionId != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _classNameCtrl = TextEditingController(text: e?.className ?? '');
    _durationCtrl = TextEditingController(
        text: e != null ? e.durationMinutes.toString() : '');
    _capacityCtrl = TextEditingController(
        text: e != null ? e.capacity.toString() : '');
    _roomNameCtrl = TextEditingController(text: e?.roomName ?? '');
    _notesCtrl = TextEditingController();

    if (_isEditMode) {
      _selectedDate = widget.existingDate;
      _selectedTime = _parseTimeOfDay(e?.startTime);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AdminClassesBloc>();
      if (bloc.state is! ClassFormOptionsLoaded) {
        bloc.add(const ClassFormOptionsRequested());
      }
    });
  }

  TimeOfDay? _parseTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      // Handles "7:00 AM", "2:30 PM", "14:30", etc.
      final upper = timeStr.trim().toUpperCase();
      final hasPeriod = upper.endsWith('AM') || upper.endsWith('PM');
      if (hasPeriod) {
        final parts = upper.split(' ');
        final timeParts = parts[0].split(':');
        var hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        if (parts[1] == 'PM' && hour != 12) hour += 12;
        if (parts[1] == 'AM' && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        final timeParts = upper.split(':');
        return TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]));
      }
    } catch (_) {
      return null;
    }
  }

  void _initDropdownsFromOptions(ClassFormOptionsEntity options) {
    if (_optionsInitialized || !_isEditMode) return;
    final e = widget.existing;
    if (e == null) return;

    final allTypes = [
      ...options.classTypes,
      ..._newTypes.where((n) => !options.classTypes.any((t) => t.id == n.id)),
    ];

    ClassFormOptionItemEntity? findByName(
        List<ClassFormOptionItemEntity> items, String? name) {
      if (name == null) return null;
      try {
        return items.firstWhere((i) => i.name == name);
      } catch (_) {
        return null;
      }
    }

    setState(() {
      _optionsInitialized = true;
      _selectedType    = findByName(allTypes, e.typeName);
      _selectedTrainer = findByName(options.trainers, e.trainerName);
      _selectedBranch  = findByName(options.branches, e.branchName);
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

  Future<void> _showCreateTypeDialog() async {
    final cs   = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '0');
    String difficulty = 'BEGINNER';
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<ClassFormOptionItemEntity>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
            l10n.admin_classes_newTypeTitle,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dialogLabel(l10n.admin_classes_typeNameLabel, cs),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: nameCtrl,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _dialogDeco(l10n.admin_classes_typeNameHint, cs),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.admin_classes_required
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogLabel(l10n.admin_classes_typeDurationLabel, cs),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _dialogDeco(l10n.admin_classes_durationHint, cs),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.admin_classes_required;
                      }
                      if (int.tryParse(v.trim()) == null) {
                        return l10n.admin_classes_mustBeNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _dialogLabel(l10n.admin_classes_typeDifficultyLabel, cs),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: difficulty,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _dialogDeco('', cs),
                    items: [
                      DropdownMenuItem(
                          value: 'BEGINNER',
                          child: Text(l10n.admin_classes_diffBeginner)),
                      DropdownMenuItem(
                          value: 'INTERMEDIATE',
                          child: Text(l10n.admin_classes_diffIntermediate)),
                      DropdownMenuItem(
                          value: 'ADVANCED',
                          child: Text(l10n.admin_classes_diffAdvanced)),
                    ],
                    onChanged: (v) =>
                        setDialogState(() => difficulty = v ?? 'BEGINNER'),
                  ),
                  const SizedBox(height: 12),
                  _dialogLabel(l10n.admin_classes_typePriceLabel, cs),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    style: TextStyle(color: cs.onSurface),
                    decoration: _dialogDeco('0.00', cs),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (double.tryParse(v.trim()) == null) {
                        return l10n.admin_classes_mustBeNumber;
                      }
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
              child: Text(l10n.general_cancel,
                  style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final newType = await _createClassTypeOnBackend(
                  name: nameCtrl.text.trim(),
                  durationMinutes: int.parse(durationCtrl.text.trim()),
                  difficultyLevel: difficulty,
                  price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                );
                if (newType != null && ctx.mounted) {
                  Navigator.of(ctx).pop(newType);
                } else if (ctx.mounted) {
                  AppToast.error(ctx, AppLocalizations.of(ctx)!.admin_classes_failedCreateType);
                }
              },
              child: Text(AppLocalizations.of(ctx)!.admin_classes_createTypeButton),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _newTypes.add(result);
        _selectedType = result;
      });
    }
  }

  Future<ClassFormOptionItemEntity?> _createClassTypeOnBackend({
    required String name,
    required int durationMinutes,
    required String difficultyLevel,
    required double price,
  }) async {
    try {
      final tokenStore = const AdminTokenStore();
      final token = await tokenStore.getToken();
      if (token == null) return null;

      final r = await http.post(
        Uri.parse('${Env.apiProjectBaseUrl}/api/admin/classes/types'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
        body: jsonEncode({
          'name': name,
          'durationMinutes': durationMinutes,
          'difficultyLevel': difficultyLevel,
          'price': price,
        }),
      );

      if (r.statusCode == 201) {
        final json = jsonDecode(r.body) as Map<String, dynamic>;
        return ClassFormOptionItemEntity(
          id: json['id'] as int,
          name: json['name'] as String,
        );
      }

      if (r.statusCode == 409 && mounted) {
        AppToast.info(context, AppLocalizations.of(context)!.admin_classes_typeExists);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _selectedDate != null && _selectedDate!.isAfter(today)
        ? _selectedDate!
        : today;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      // If the previously chosen time is now in the past (date changed to today),
      // clear it so the user has to re-pick a valid time.
      if (_selectedTime != null) {
        final now2 = DateTime.now();
        final combined = DateTime(
            picked.year, picked.month, picked.day,
            _selectedTime!.hour, _selectedTime!.minute);
        if (combined.isBefore(now2)) {
          setState(() => _selectedTime = null);
          if (mounted) {
            AppToast.info(context, AppLocalizations.of(context)!.admin_classes_timeReset);
          }
        }
      }
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked == null) return;

    // If the chosen date is today, reject times already in the past.
    final now = DateTime.now();
    final isToday = _selectedDate != null &&
        _selectedDate!.year == now.year &&
        _selectedDate!.month == now.month &&
        _selectedDate!.day == now.day;

    if (isToday) {
      final combined = DateTime(
          now.year, now.month, now.day, picked.hour, picked.minute);
      if (combined.isBefore(now)) {
        if (mounted) {
          AppToast.info(context, AppLocalizations.of(context)!.admin_classes_timePast);
        }
        return;
      }
    }

    setState(() => _selectedTime = picked);
  }

  void _onSave() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      AppToast.info(context, l10n.admin_classes_selectDateTime);
      return;
    }

    final combined = DateTime(
        _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
        _selectedTime!.hour, _selectedTime!.minute);
    if (combined.isBefore(DateTime.now())) {
      AppToast.info(context, l10n.admin_classes_dateTimePast);
      return;
    }

    if (_selectedType == null ||
        _selectedTrainer == null ||
        _selectedBranch == null) {
      AppToast.info(context, l10n.admin_classes_fillRequired);
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
          className: _classNameCtrl.text.trim(),
          classTypeId: _selectedType!.id,
          trainerId: _selectedTrainer!.id,
          branchId: _selectedBranch!.id,
          date: dateStr,
          time: timeStr,
          durationMinutes: int.parse(_durationCtrl.text.trim()),
          capacity: int.parse(_capacityCtrl.text.trim()),
          roomName: _roomNameCtrl.text.trim().isEmpty
              ? null
              : _roomNameCtrl.text.trim(),
          notes: _notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim(),
        ),
      ));
    } else {
      bloc.add(ClassCreateRequested(
        CreateClassRequestModel(
          className: _classNameCtrl.text.trim(),
          classTypeId: _selectedType!.id,
          trainerId: _selectedTrainer!.id,
          branchId: _selectedBranch!.id,
          date: dateStr,
          time: timeStr,
          durationMinutes: int.parse(_durationCtrl.text.trim()),
          capacity: int.parse(_capacityCtrl.text.trim()),
          roomName: _roomNameCtrl.text.trim().isEmpty
              ? null
              : _roomNameCtrl.text.trim(),
          notes: _notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim(),
        ),
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs   = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final mq = MediaQuery.of(context);
    final bottomInset = mq.viewInsets.bottom;
    final navBarHeight = mq.viewPadding.bottom;

    return BlocListener<AdminClassesBloc, AdminClassesState>(
      listener: (context, state) {},
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20, bottom: bottomInset + navBarHeight + 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Handle + title ─────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _isEditMode ? l10n.admin_classes_editTitle : l10n.admin_classes_addTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Section: Class Details ─────────────────────────────────
                _SectionHeader(l10n.admin_classes_sectionDetails, cs),

                // ── Class Name ─────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_nameLabel, cs),
                _buildTextField(
                  cs: cs,
                  controller: _classNameCtrl,
                  hint: l10n.admin_classes_nameHint,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.admin_classes_required
                      : null,
                ),
                const SizedBox(height: 16),

                // ── Dropdowns ──────────────────────────────────────────────
                BlocBuilder<AdminClassesBloc, AdminClassesState>(
                  builder: (context, state) {
                    if (state is ClassFormOptionsLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: cs.primary));
                    }
                    if (state is ClassFormOptionsLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _initDropdownsFromOptions(state.options));
                      final options = state.options;
                      final allTypes = [
                        ...options.classTypes,
                        ..._newTypes.where((n) => !options.classTypes
                            .any((t) => t.id == n.id)),
                      ];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child:
                                  _FieldLabel(l10n.admin_classes_typeLabel, cs)),
                              TextButton.icon(
                                icon: Icon(Icons.add,
                                    size: 14, color: cs.primary),
                                label: Text(l10n.admin_classes_newTypeButton,
                                    style: TextStyle(
                                        fontSize: 12, color: cs.primary)),
                                onPressed: _showCreateTypeDialog,
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                              ),
                            ],
                          ),
                          _buildDropdown(
                              cs: cs,
                              items: allTypes,
                              value: _selectedType,
                              hint: l10n.admin_classes_selectType,
                              onChanged: (v) =>
                                  setState(() => _selectedType = v)),
                          const SizedBox(height: 16),
                          _FieldLabel(l10n.admin_classes_trainerLabel, cs),
                          _buildDropdown(
                              cs: cs,
                              items: options.trainers,
                              value: _selectedTrainer,
                              hint: l10n.admin_classes_selectTrainer,
                              onChanged: (v) =>
                                  setState(() => _selectedTrainer = v)),
                          const SizedBox(height: 16),
                          _FieldLabel(l10n.admin_classes_branchLabel, cs),
                          _buildDropdown(
                              cs: cs,
                              items: options.branches,
                              value: _selectedBranch,
                              hint: l10n.admin_classes_selectBranch,
                              onChanged: (v) =>
                                  setState(() => _selectedBranch = v)),
                        ],
                      );
                    }
                    // Not yet loaded — show empty dropdowns
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child:
                                _FieldLabel(l10n.admin_classes_typeLabel, cs)),
                            TextButton.icon(
                              icon: Icon(Icons.add,
                                  size: 14, color: cs.primary),
                              label: Text(l10n.admin_classes_newTypeButton,
                                  style: TextStyle(
                                      fontSize: 12, color: cs.primary)),
                              onPressed: _showCreateTypeDialog,
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                            ),
                          ],
                        ),
                        _buildDropdown(
                            cs: cs,
                            items: [],
                            value: null,
                            hint: l10n.admin_classes_selectType,
                            onChanged: (_) {}),
                        const SizedBox(height: 16),
                        _FieldLabel(l10n.admin_classes_trainerLabel, cs),
                        _buildDropdown(
                            cs: cs,
                            items: [],
                            value: null,
                            hint: l10n.admin_classes_selectTrainer,
                            onChanged: (_) {}),
                        const SizedBox(height: 16),
                        _FieldLabel(l10n.admin_classes_branchLabel, cs),
                        _buildDropdown(
                            cs: cs,
                            items: [],
                            value: null,
                            hint: l10n.admin_classes_selectBranch,
                            onChanged: (_) {}),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Section: Schedule ──────────────────────────────────────
                _SectionHeader(l10n.admin_classes_sectionSchedule, cs),

                // ── Date ───────────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_dateLabel, cs),
                _buildTapField(
                  cs: cs,
                  hint: 'mm/dd/yyyy',
                  icon: Icons.calendar_today_outlined,
                  value: _selectedDate != null
                      ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                      : null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // ── Time ───────────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_timeLabel, cs),
                _buildTapField(
                  cs: cs,
                  hint: '--:--',
                  icon: Icons.access_time_outlined,
                  value: _selectedTime?.format(context),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),

                // ── Duration ───────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_durationLabel, cs),
                _buildTextField(
                  cs: cs,
                  controller: _durationCtrl,
                  hint: l10n.admin_classes_durationHint,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.admin_classes_required;
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return l10n.admin_classes_mustBeNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Section: Capacity & Room ───────────────────────────────
                _SectionHeader(l10n.admin_classes_sectionCapacityRoom, cs),

                // ── Capacity ───────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_capacityLabel, cs),
                _buildTextField(
                  cs: cs,
                  controller: _capacityCtrl,
                  hint: l10n.admin_classes_capacityHint,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.admin_classes_required;
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return l10n.admin_classes_mustBeNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Room Name ──────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_roomLabel, cs),
                _buildTextField(
                  cs: cs,
                  controller: _roomNameCtrl,
                  hint: l10n.admin_classes_roomHint,
                  validator: null,
                ),
                const SizedBox(height: 16),

                // ── Section: Notes ─────────────────────────────────────────
                _SectionHeader(l10n.admin_classes_sectionNotes, cs),

                // ── Notes ──────────────────────────────────────────────────
                _FieldLabel(l10n.admin_classes_notesLabel, cs),
                _buildTextField(
                  cs: cs,
                  controller: _notesCtrl,
                  hint: l10n.admin_classes_notesHint,
                  maxLines: 3,
                  validator: null,
                ),
                const SizedBox(height: 28),

                // ── Buttons ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                              color: cs.outline.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          l10n.general_cancel,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          l10n.admin_classes_saveButton,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _dialogLabel(String text, ColorScheme cs) => Text(
    text,
    style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: cs.onSurface.withOpacity(0.7)),
  );

  InputDecoration _dialogDeco(String hint, ColorScheme cs) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3)),
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: cs.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.primary, width: 1.4),
        ),
      );

  Widget _buildTextField({
    required ColorScheme cs,
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
      style: TextStyle(color: cs.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(color: cs.onSurface.withOpacity(0.3), fontSize: 14),
        filled: true,
        fillColor: cs.surfaceVariant,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required ColorScheme cs,
    required List<ClassFormOptionItemEntity> items,
    required ClassFormOptionItemEntity? value,
    required String hint,
    required void Function(ClassFormOptionItemEntity?) onChanged,
  }) {
    ClassFormOptionItemEntity? safeValue;
    if (value != null) {
      try {
        safeValue = items.firstWhere((i) => i.id == value.id);
      } catch (_) {
        safeValue = null;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: cs.outline.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassFormOptionItemEntity>(
          value: safeValue,
          isExpanded: true,
          dropdownColor: cs.surface,
          hint: Text(hint,
              style: TextStyle(
                  color: cs.onSurface.withOpacity(0.3), fontSize: 14)),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item.name,
                style: TextStyle(color: cs.onSurface)),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTapField({
    required ColorScheme cs,
    required String hint,
    required IconData icon,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: value != null
                      ? cs.onSurface
                      : cs.onSurface.withOpacity(0.3),
                  fontSize: 14,
                ),
              ),
            ),
            Icon(icon, size: 18, color: cs.onSurface.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}

/// Groups related fields under a small section heading so the long form
/// reads as a few clear steps instead of one wall of inputs.
class _SectionHeader extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  const _SectionHeader(this.text, this.cs);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  const _FieldLabel(this.text, this.cs);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}