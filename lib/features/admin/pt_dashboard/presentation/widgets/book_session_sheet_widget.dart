// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/widgets/book_session_sheet_widget.dart
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
  final int branchId;
  final int tenantId;
  final DateTime selectedDate;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const BookSessionSheet({
    super.key,
    required this.branchId,
    required this.tenantId,
    required this.selectedDate,
    this.isAdmin = false,
    this.trainers = const [],
  });

  static Future<void> show(
    BuildContext context, {
    required int branchId,
    required int tenantId,
    required DateTime selectedDate,
    bool isAdmin = false,
    List<AdminTrainerCardModel> trainers = const [],
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TrainerPtSessionsBloc>(),
        child: BookSessionSheet(
          branchId: branchId,
          tenantId: tenantId,
          selectedDate: selectedDate,
          isAdmin: isAdmin,
          trainers: trainers,
        ),
      ),
    );
  }

  @override
  State<BookSessionSheet> createState() => _BookSessionSheetState();
}

class _BookSessionSheetState extends State<BookSessionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  List<PtServiceModel> _services = [];
  bool _servicesLoading = false;
  PtServiceModel? _selectedService;
  int? _selectedTrainerId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
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
          _services = list.where((s) => s.isActive == true).toList();
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  DateTime _combine(TimeOfDay time) {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end time.')),
      );
      return;
    }

    final userId = int.tryParse(_memberIdCtrl.text.trim());
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Member ID.')),
      );
      return;
    }

    if (widget.isAdmin && _selectedTrainerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trainer.')),
      );
      return;
    }

    context.read<TrainerPtSessionsBloc>().add(
          PtSessionCreateRequested(
            branchId:  widget.branchId,
            trainerId: widget.isAdmin ? _selectedTrainerId : null,
            userId:    userId,
            serviceId: _selectedService?.serviceId,
            startTime: _combine(_startTime!),
            endTime:   _combine(_endTime!),
            notes:     _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                'Book Session',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),

              // Tappable date row
              _FieldLabel('Date'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 18, color: Colors.grey[500]),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.edit_calendar_outlined,
                          size: 16, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Member ID field
              _FieldLabel('Member ID'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _memberIdCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g., 42'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty || int.tryParse(v.trim()) == null)
                        ? 'Enter a valid member ID'
                        : null,
              ),

              // Trainer dropdown — admin/owner only
              if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
                const SizedBox(height: 16),
                _FieldLabel('Trainer'),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  value: _selectedTrainerId,
                  decoration: _inputDecoration('Select a trainer'),
                  isExpanded: true,
                  items: widget.trainers
                      .map((t) => DropdownMenuItem<int>(
                            value: t.trainerId,
                            child: Text(
                              t.fullName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTrainerId = v),
                ),
              ],

              const SizedBox(height: 16),

              // Service dropdown
              _FieldLabel('Service (optional)'),
              const SizedBox(height: 6),
              _servicesLoading
                  ? Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text('Loading services…',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[400])),
                        ],
                      ),
                    )
                  : DropdownButtonFormField<PtServiceModel?>(
                      value: _selectedService,
                      decoration: _inputDecoration('No service selected'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<PtServiceModel?>(
                          value: null,
                          child: Text('— None —',
                              style: TextStyle(color: Color(0xFF9CA3AF))),
                        ),
                        ..._services.map(
                          (s) => DropdownMenuItem<PtServiceModel?>(
                            value: s,
                            child: Text(
                              '${s.name} (${s.durationMinutes} min)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedService = v),
                    ),

              const SizedBox(height: 16),

              // Start + End time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('Start Time'),
                        const SizedBox(height: 6),
                        _TimePicker(
                          time: _startTime,
                          hint: '--:-- --',
                          onTap: () => _pickTime(true),
                          primaryColor: cs.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('End Time'),
                        const SizedBox(height: 6),
                        _TimePicker(
                          time: _endTime,
                          hint: '--:-- --',
                          onTap: () => _pickTime(false),
                          primaryColor: cs.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Notes
              _FieldLabel('Notes (optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: _inputDecoration('e.g., Focus on upper body'),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Book Session',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final String hint;
  final VoidCallback onTap;
  final Color primaryColor;

  const _TimePicker({
    required this.time,
    required this.hint,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 18, color: Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              time != null ? time!.format(context) : hint,
              style: TextStyle(
                fontSize: 14,
                color: time != null
                    ? const Color(0xFF1A1A2E)
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
