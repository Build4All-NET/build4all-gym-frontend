// PATH: lib/features/admin/classes/presentation/widgets/add_edit_class_bottom_sheet.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../../data/models/create_class_request_model.dart';
import '../../data/models/update_class_request_model.dart';
import '../../domain/entities/admin_class_card_entity.dart';
import '../../domain/entities/class_form_option_item_entity.dart';
import '../../../../../common/widgets/app_toast.dart';
import '../../../../../common/widgets/form_section_kit.dart';
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
    final c = context.read<ThemeCubit>().state.tokens.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
  late final TextEditingController _commissionPercentageCtrl;
  bool _clearCommissionPercentage = false;

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
    _commissionPercentageCtrl = TextEditingController();

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
    _commissionPercentageCtrl.dispose();
    super.dispose();
  }

  Future<void> _showCreateTypeDialog() async {
    final c    = context.read<ThemeCubit>().state.tokens.colors;
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
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.category_outlined, size: 18, color: c.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.admin_classes_newTypeTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16, color: c.label),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormFieldLabel(l10n.admin_classes_typeNameLabel, c),
                  TextFormField(
                    controller: nameCtrl,
                    style: TextStyle(color: c.label),
                    decoration: formInputDecoration(hint: l10n.admin_classes_typeNameHint, c: c),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.admin_classes_required
                        : null,
                  ),
                  const SizedBox(height: 14),
                  FormFieldLabel(l10n.admin_classes_typeDurationLabel, c),
                  TextFormField(
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: c.label),
                    decoration: formInputDecoration(hint: l10n.admin_classes_durationHint, c: c),
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
                  const SizedBox(height: 14),
                  FormFieldLabel(l10n.admin_classes_typeDifficultyLabel, c),
                  DropdownButtonFormField<String>(
                    value: difficulty,
                    style: TextStyle(color: c.label),
                    decoration: formInputDecoration(hint: '', c: c),
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
                  const SizedBox(height: 14),
                  FormFieldLabel(l10n.admin_classes_typePriceLabel, c),
                  TextFormField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    style: TextStyle(color: c.label),
                    decoration: formInputDecoration(
                        hint: '0.00', c: c, prefixIcon: Icons.attach_money_rounded),
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
                  style: TextStyle(color: c.muted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    final commissionPercentage =
        double.tryParse(_commissionPercentageCtrl.text.trim());

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
          commissionPercentage: _clearCommissionPercentage ? null : commissionPercentage,
          clearCommissionPercentage: _clearCommissionPercentage,
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
          commissionPercentage: commissionPercentage,
        ),
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c    = context.watch<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final navBarHeight = MediaQuery.of(context).viewPadding.bottom;

    return BlocListener<AdminClassesBloc, AdminClassesState>(
      listener: (context, state) {},
      child: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20, bottom: bottomInset + navBarHeight + 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FormSheetHandle(c),
                const SizedBox(height: 16),
                FormSheetHeader(
                  title: _isEditMode ? l10n.admin_classes_editTitle : l10n.admin_classes_addTitle,
                  icon: Icons.event_available_rounded,
                  c: c,
                  onClose: () => Navigator.of(context).pop(),
                ),

                // ── Section: Class Details ─────────────────────────────────
                FormSectionHeader(
                  title: l10n.admin_classes_sectionDetails,
                  icon: Icons.info_outline_rounded,
                  c: c,
                ),

                // ── Class Name ─────────────────────────────────────────────
                FormFieldLabel(l10n.admin_classes_nameLabel, c),
                TextFormField(
                  controller: _classNameCtrl,
                  style: TextStyle(color: c.label),
                  decoration: formInputDecoration(
                    hint: l10n.admin_classes_nameHint,
                    c: c,
                    prefixIcon: Icons.label_outline_rounded,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.admin_classes_required
                      : null,
                ),
                const SizedBox(height: 14),

                // ── Dropdowns ──────────────────────────────────────────────
                BlocBuilder<AdminClassesBloc, AdminClassesState>(
                  builder: (context, state) {
                    if (state is ClassFormOptionsLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: c.primary));
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
                                  child: FormFieldLabel(
                                      l10n.admin_classes_typeLabel, c)),
                              _NewTypeChip(
                                  label: l10n.admin_classes_newTypeButton,
                                  c: c,
                                  onTap: _showCreateTypeDialog),
                            ],
                          ),
                          _optionDropdown(
                              c: c,
                              items: allTypes,
                              value: _selectedType,
                              hint: l10n.admin_classes_selectType,
                              icon: Icons.category_outlined,
                              onChanged: (v) =>
                                  setState(() => _selectedType = v)),
                          const SizedBox(height: 14),
                          FormFieldLabel(l10n.admin_classes_trainerLabel, c),
                          _optionDropdown(
                              c: c,
                              items: options.trainers,
                              value: _selectedTrainer,
                              hint: l10n.admin_classes_selectTrainer,
                              icon: Icons.person_outline_rounded,
                              onChanged: (v) =>
                                  setState(() => _selectedTrainer = v)),
                          const SizedBox(height: 14),
                          FormFieldLabel(l10n.admin_classes_branchLabel, c),
                          _optionDropdown(
                              c: c,
                              items: options.branches,
                              value: _selectedBranch,
                              hint: l10n.admin_classes_selectBranch,
                              icon: Icons.store_outlined,
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
                                child: FormFieldLabel(
                                    l10n.admin_classes_typeLabel, c)),
                            _NewTypeChip(
                                label: l10n.admin_classes_newTypeButton,
                                c: c,
                                onTap: _showCreateTypeDialog),
                          ],
                        ),
                        _optionDropdown(
                            c: c,
                            items: const [],
                            value: null,
                            hint: l10n.admin_classes_selectType,
                            icon: Icons.category_outlined,
                            onChanged: (_) {}),
                        const SizedBox(height: 14),
                        FormFieldLabel(l10n.admin_classes_trainerLabel, c),
                        _optionDropdown(
                            c: c,
                            items: const [],
                            value: null,
                            hint: l10n.admin_classes_selectTrainer,
                            icon: Icons.person_outline_rounded,
                            onChanged: (_) {}),
                        const SizedBox(height: 14),
                        FormFieldLabel(l10n.admin_classes_branchLabel, c),
                        _optionDropdown(
                            c: c,
                            items: const [],
                            value: null,
                            hint: l10n.admin_classes_selectBranch,
                            icon: Icons.store_outlined,
                            onChanged: (_) {}),
                      ],
                    );
                  },
                ),

                // ── Section: Schedule ──────────────────────────────────────
                FormSectionHeader(
                  title: l10n.admin_classes_sectionSchedule,
                  icon: Icons.event_outlined,
                  c: c,
                ),

                // ── Date + Time ────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel(l10n.admin_classes_dateLabel, c),
                          FormPickerField(
                            icon: Icons.calendar_today_outlined,
                            label: _selectedDate != null
                                ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                                : 'mm/dd/yyyy',
                            hasValue: _selectedDate != null,
                            onTap: _pickDate,
                            c: c,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel(l10n.admin_classes_timeLabel, c),
                          FormPickerField(
                            icon: Icons.access_time_outlined,
                            label: _selectedTime?.format(context) ?? '--:--',
                            hasValue: _selectedTime != null,
                            onTap: _pickTime,
                            c: c,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Duration ───────────────────────────────────────────────
                FormFieldLabel(l10n.admin_classes_durationLabel, c),
                TextFormField(
                  controller: _durationCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: c.label),
                  decoration: formInputDecoration(
                    hint: l10n.admin_classes_durationHint,
                    c: c,
                    prefixIcon: Icons.timer_outlined,
                  ),
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

                // ── Section: Capacity & Room ───────────────────────────────
                FormSectionHeader(
                  title: l10n.admin_classes_sectionCapacityRoom,
                  icon: Icons.groups_outlined,
                  c: c,
                ),

                // ── Capacity + Room Name ───────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel(l10n.admin_classes_capacityLabel, c),
                          TextFormField(
                            controller: _capacityCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: c.label),
                            decoration: formInputDecoration(
                              hint: l10n.admin_classes_capacityHint,
                              c: c,
                              prefixIcon: Icons.groups_outlined,
                            ),
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel(l10n.admin_classes_roomLabel, c),
                          TextFormField(
                            controller: _roomNameCtrl,
                            style: TextStyle(color: c.label),
                            decoration: formInputDecoration(
                              hint: l10n.admin_classes_roomHint,
                              c: c,
                              prefixIcon: Icons.meeting_room_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Trainer Commission % (optional) ──────────────────────
                FormFieldLabel(l10n.admin_classes_commissionLabel, c),
                TextFormField(
                  controller: _commissionPercentageCtrl,
                  enabled: !_clearCommissionPercentage,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: c.label),
                  decoration: formInputDecoration(
                    hint: l10n.admin_classes_commissionHint,
                    c: c,
                    prefixIcon: Icons.percent_rounded,
                  ),
                  validator: (v) {
                    if (_clearCommissionPercentage) return null;
                    if (v == null || v.trim().isEmpty) return null;
                    final n = double.tryParse(v.trim());
                    if (n == null) return l10n.admin_classes_mustBeNumber;
                    if (n < 0 || n > 100) return l10n.trainer_commissionRangeError;
                    return null;
                  },
                ),
                // This form never pre-fills the current commission % (the
                // backend list endpoint doesn't return it), so there's no
                // way to show "currently 15%" here — this checkbox is the
                // only way to explicitly remove a previously-set value.
                if (_isEditMode) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _clearCommissionPercentage,
                          activeColor: c.primary,
                          onChanged: (v) => setState(() {
                            _clearCommissionPercentage = v ?? false;
                            if (_clearCommissionPercentage) {
                              _commissionPercentageCtrl.clear();
                            }
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.admin_classes_removeCommission,
                          style: TextStyle(fontSize: 12.5, color: c.muted),
                        ),
                      ),
                    ],
                  ),
                ],

                // ── Section: Notes ─────────────────────────────────────────
                FormSectionHeader(
                  title: l10n.admin_classes_sectionNotes,
                  icon: Icons.sticky_note_2_outlined,
                  c: c,
                ),

                // ── Notes ──────────────────────────────────────────────────
                FormFieldLabel(l10n.admin_classes_notesLabel, c),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  style: TextStyle(color: c.label),
                  decoration: formInputDecoration(
                    hint: l10n.admin_classes_notesHint,
                    c: c,
                  ),
                ),
                const SizedBox(height: 26),

                // ── Buttons ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: c.border.withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            l10n.general_cancel,
                            style: TextStyle(
                              color: c.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FormPrimaryButton(
                        label: l10n.admin_classes_saveButton,
                        icon: Icons.check_rounded,
                        background: c.primary,
                        foreground: c.onPrimary,
                        onPressed: _onSave,
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

  Widget _optionDropdown({
    required ColorTokens c,
    required List<ClassFormOptionItemEntity> items,
    required ClassFormOptionItemEntity? value,
    required String hint,
    required IconData icon,
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

    return DropdownButtonFormField<ClassFormOptionItemEntity>(
      value: safeValue,
      isExpanded: true,
      dropdownColor: c.surface,
      decoration: formInputDecoration(hint: hint, c: c, prefixIcon: icon),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item.name, style: TextStyle(color: c.label)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Small outlined chip that opens the "create new class type" dialog.
class _NewTypeChip extends StatelessWidget {
  final String label;
  final ColorTokens c;
  final VoidCallback onTap;

  const _NewTypeChip({required this.label, required this.c, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: c.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 14, color: c.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
