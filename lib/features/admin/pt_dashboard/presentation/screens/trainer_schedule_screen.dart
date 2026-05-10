// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/screens/trainer_schedule_screen.dart
//
// DESIGN: Images 8-9 — Schedule tab (Availability).
//
// Shows recurring weekly time slots grouped by day of week.
// "+ Add Slot" button and FAB both open the Add Availability dialog.
//
// TODO: Wire to real backend availability endpoints when implemented.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../data/models/availability_model.dart';
import '../bloc/availability_bloc.dart';

class TrainerScheduleScreen extends StatefulWidget {
  const TrainerScheduleScreen({super.key});

  @override
  State<TrainerScheduleScreen> createState() =>
      _TrainerScheduleScreenState();
}

class _TrainerScheduleScreenState extends State<TrainerScheduleScreen> {



  late final AvailabilityBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AvailabilityBloc(AvailabilityHttpService());
    _bloc.add(LoadAvailability(trainerId: /* from auth */, branchId: /* from auth */));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs = tokens.colors;

    // Group by day
    final grouped = <String, List<_IndexedSlot>>{};
    for (int i = 0; i < _slots.length; i++) {
      grouped.putIfAbsent(_slots[i].day, () => []);
      grouped[_slots[i].day]!.add(_IndexedSlot(index: i, slot: _slots[i]));
    }

    const dayOrder = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Availability',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _AddAvailabilityDialog.show(
                  context, onAdd: _addSlot),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Slot',
                  style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),

      body: BlocConsumer<AvailabilityBloc, AvailabilityState>(
        bloc: _bloc,
        listener: (ctx, state) {
          if (state is AvailabilityMutated) {
            _bloc.add(LoadAvailability(trainerId: _trainerId, branchId: _branchId));
          }
          if (state is AvailabilityError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red));
          }
        },
        builder: (ctx, state) {
          if (state is AvailabilityLoading) return const Center(child: CircularProgressIndicator());
          if (state is AvailabilityLoaded) {
            final slots = state.slots;
            if (slots.isEmpty) return const Center(child: Text('No availability set yet.'));
            // Build grouped map using slot.dayName
            final grouped = <String, List<AvailabilityModel>>{};
            for (final s in slots) {
              grouped.putIfAbsent(s.dayName, () => []).add(s);
            }
            const dayOrder = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: dayOrder
                  .where((d) => grouped.containsKey(d))
                  .map((day) => _DaySection(
                day: day,
                slots: grouped[day]!,
                onDelete: (id) => _bloc.add(DeleteSlot(id)),
              ))
                  .toList(),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _AddAvailabilityDialog.show(context, onAdd: _addSlot),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IndexedSlot {
  final int index;
  final _AvailabilitySlot slot;
  const _IndexedSlot({required this.index, required this.slot});
}

// ── Day section ───────────────────────────────────────────────────────────────

class _DaySection extends StatelessWidget {
  final String day;
  final List<_IndexedSlot> slots;
  final ValueChanged<int> onDelete;

  const _DaySection({
    required this.day,
    required this.slots,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        ...slots.map((s) => _SlotRow(
              indexed: s,
              onDelete: () => onDelete(s.index),
            )),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ── Slot row ──────────────────────────────────────────────────────────────────

class _SlotRow extends StatelessWidget {
  final _IndexedSlot indexed;
  final VoidCallback onDelete;

  const _SlotRow({super.key, required this.indexed, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final slot = indexed.slot;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.access_time_rounded,
                size: 18, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${slot.startDisplay} - ${slot.endDisplay}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (slot.recurring)
                  Text(
                    'Recurring weekly',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline,
                size: 20, color: Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }
}

// ── Add Availability dialog ───────────────────────────────────────────────────

class _AddAvailabilityDialog extends StatefulWidget {
  final ValueChanged<_AvailabilitySlot> onAdd;

  const _AddAvailabilityDialog({required this.onAdd});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<_AvailabilitySlot> onAdd,
  }) {
    return showDialog(
      context: context,
      builder: (_) => _AddAvailabilityDialog(onAdd: onAdd),
    );
  }

  @override
  State<_AddAvailabilityDialog> createState() =>
      _AddAvailabilityDialogState();
}

class _AddAvailabilityDialogState
    extends State<_AddAvailabilityDialog> {
  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _recurring = true;

  static const _days = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 8, minute: 0)
          : const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) _startTime = picked;
      else _endTime = picked;
    });
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

// Map day name to weekday number
  static const _dayNumbers = {
    'Monday': 1, 'Tuesday': 2, 'Wednesday': 3,
    'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7,
  };

  void _submit() {
    widget.bloc.add(AddSlot(
      trainerId: widget.trainerId,
      branchId: widget.branchId,
      weekday: _dayNumbers[_selectedDay]!,
      startTime: _startTime.format(context), // "HH:mm"
      endTime: _endTime.format(context),
    ));
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close,
                      color: Color(0xFF9CA3AF)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Day of week
            const _Label2('Day of Week'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedDay,
              hint: const Text('Select day'),
              decoration: _dec2(null),
              items: _days
                  .map((d) =>
                      DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedDay = v),
            ),

            const SizedBox(height: 16),

            // Start + End time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label2('Start Time'),
                      const SizedBox(height: 6),
                      _TimePickerField(
                        time: _startTime,
                        onTap: () => _pickTime(true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label2('End Time'),
                      const SizedBox(height: 6),
                      _TimePickerField(
                        time: _endTime,
                        onTap: () => _pickTime(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recurring toggle
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recurring Weekly',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          'Repeat this slot every week',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _recurring,
                    onChanged: (v) => setState(() => _recurring = v),
                    activeColor: const Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline,
                        size: 18),
                    label: const Text('Add Availability'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Label2 extends StatelessWidget {
  final String text;
  const _Label2(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151)));
  }
}

class _TimePickerField extends StatelessWidget {
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimePickerField({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 18, color: Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              time != null ? time!.format(context) : '--:-- --',
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

InputDecoration _dec2(String? hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}
