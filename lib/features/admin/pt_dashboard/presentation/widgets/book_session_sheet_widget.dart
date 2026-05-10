// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/widgets/book_session_sheet_widget.dart
//
// Bottom sheet triggered by the "+ Book Session" button in the sessions screen.
// Fields:
//   - Member ID (userId) — required (TODO: replace with member search picker)
//   - Service ID — optional
//   - Date (pre-filled with selected date)
//   - Start time — required
//   - End time — required
//   - Notes — optional
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_event.dart';

class BookSessionSheet extends StatefulWidget {
  final int branchId;
  final DateTime selectedDate;

  const BookSessionSheet({
    super.key,
    required this.branchId,
    required this.selectedDate,
  });

  static Future<void> show(
    BuildContext context, {
    required int branchId,
    required DateTime selectedDate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TrainerPtSessionsBloc>(),
        child: BookSessionSheet(
          branchId: branchId,
          selectedDate: selectedDate,
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
  final _serviceIdCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _memberIdCtrl.dispose();
    _serviceIdCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
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

    context.read<TrainerPtSessionsBloc>().add(
          PtSessionCreateRequested(
            branchId:  widget.branchId,
            userId:    userId,
            serviceId: int.tryParse(_serviceIdCtrl.text.trim()),
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
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs = tokens.colors;
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
              // Handle bar
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
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(widget.selectedDate),
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),

              const SizedBox(height: 24),

              // Member ID field
              // TODO: Replace with a member search picker once the member
              // lookup endpoint is available.
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

              const SizedBox(height: 16),

              // Service ID (optional)
              _FieldLabel('Service ID (optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _serviceIdCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g., 3'),
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

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Book Session',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
        borderSide:
            const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
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
              time != null
                  ? time!.format(context)
                  : hint,
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
