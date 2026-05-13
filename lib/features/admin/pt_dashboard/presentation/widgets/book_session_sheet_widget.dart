// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/widgets/book_session_sheet_widget.dart
//
// FIX SUMMARY:
//   1. Sheet now accepts trainerId, isAdmin, trainers params.
//   2. Admin sees a "Assign to Trainer" dropdown at the top.
//   3. Trainer role: trainerId is fixed to their own ID (no picker shown).
//   4. Correct trainerId is sent in PtSessionCreateRequested.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../data/models/pt_service_model.dart';
import '../../data/services/pt_service_service.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_event.dart';

class BookSessionSheet extends StatefulWidget {
  final int    branchId;
  final int    tenantId;
  final int    trainerId;   // ← explicit, never 0
  final bool   isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final DateTime selectedDate;

  const BookSessionSheet({
    super.key,
    required this.branchId,
    required this.tenantId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
    required this.selectedDate,
  });

  static Future<void> show(
      BuildContext context, {
        required int    branchId,
        required int    tenantId,
        required int    trainerId,
        required bool   isAdmin,
        required List<AdminTrainerCardModel> trainers,
        required DateTime selectedDate,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TrainerPtSessionsBloc>(),
        child: BookSessionSheet(
          branchId:     branchId,
          tenantId:     tenantId,
          trainerId:    trainerId,
          isAdmin:      isAdmin,
          trainers:     trainers,
          selectedDate: selectedDate,
        ),
      ),
    );
  }

  @override
  State<BookSessionSheet> createState() => _BookSessionSheetState();
}

class _BookSessionSheetState extends State<BookSessionSheet> {
  final _formKey       = GlobalKey<FormState>();
  final _memberIdCtrl  = TextEditingController();
  final _notesCtrl     = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  List<PtServiceModel> _services        = [];
  bool                 _servicesLoading = false;
  PtServiceModel?      _selectedService;

  // For admin: which trainer is this session assigned to
  late int _assignedTrainerId;

  @override
  void initState() {
    super.initState();
    _selectedDate      = widget.selectedDate;
    _assignedTrainerId = widget.trainerId; // default to currently viewed trainer
    _loadServices();
  }

  @override
  void dispose() {
    _memberIdCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() => _servicesLoading = true);
    try {
      final list = await PtServiceService().getServices(widget.tenantId);
      if (mounted) {
        setState(() {
          _services        = list.where((s) => s.isActive == true).toList();
          _servicesLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _servicesLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate:  DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 9, minute: 0)
          : const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) _startTime = picked;
      else          _endTime   = picked;
    });
  }

  DateTime _toDateTime(TimeOfDay t) => DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    t.hour,
    t.minute,
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end times.')),
      );
      return;
    }

    final userId = int.tryParse(_memberIdCtrl.text.trim());
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid Member ID.')),
      );
      return;
    }

    context.read<TrainerPtSessionsBloc>().add(
      PtSessionCreateRequested(
        branchId:   widget.branchId,
        trainerId:  _assignedTrainerId, // ← correct trainer
        userId:     userId,
        serviceId:  _selectedService?.serviceId,
        startTime:  _toDateTime(_startTime!),
        endTime:    _toDateTime(_endTime!),
        notes:      _notesCtrl.text.trim().isEmpty
            ? null
            : _notesCtrl.text.trim(),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Book Session',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.surface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Admin-only: Assign to Trainer ──────────────────────
                      if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
                        _label('Assign to Trainer'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _assignedTrainerId,
                              isExpanded: true,
                              items: widget.trainers
                                  .map((t) => DropdownMenuItem(
                                value: t.trainerId,
                                child: Text(t.fullName),
                              ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _assignedTrainerId = v);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ── Member ID ──────────────────────────────────────────
                      _label('Member ID'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _memberIdCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDec('Enter member user ID'),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty || int.tryParse(v.trim()) == null)
                            ? 'Enter a valid member ID'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Date ───────────────────────────────────────────────
                      _label('Date'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 18, color: cs.primary),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('EEE, MMM d, yyyy')
                                    .format(_selectedDate),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Start / End time ───────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Start Time'),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _pickTime(true),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[300]!),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 18, color: cs.primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          _startTime == null
                                              ? 'Pick time'
                                              : _startTime!.format(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _startTime == null
                                                ? Colors.grey[400]
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('End Time'),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _pickTime(false),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[300]!),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 18, color: cs.primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          _endTime == null
                                              ? 'Pick time'
                                              : _endTime!.format(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _endTime == null
                                                ? Colors.grey[400]
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Service ────────────────────────────────────────────
                      _label('Service (optional)'),
                      const SizedBox(height: 8),
                      if (_servicesLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PtServiceModel?>(
                              value: _selectedService,
                              isExpanded: true,
                              hint: const Text('No service'),
                              items: [
                                const DropdownMenuItem<PtServiceModel?>(
                                  value: null,
                                  child: Text('No service'),
                                ),
                                ..._services.map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.name),
                                )),
                              ],
                              onChanged: (v) =>
                                  setState(() => _selectedService = v),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // ── Notes ──────────────────────────────────────────────
                      _label('Notes (optional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration:
                        _inputDec('e.g. Focus on upper body today'),
                      ),
                      const SizedBox(height: 28),

                      // ── Submit ─────────────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Book Session',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF374151),
    ),
  );

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
      const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
    ),
  );
}