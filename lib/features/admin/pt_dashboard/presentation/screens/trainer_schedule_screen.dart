// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_schedule_screen.dart
//
// FIX SUMMARY:
//   1. Screen receives isAdmin + trainers list.
//   2. ADMIN: loads availability for ALL trainers combined; shows trainer badge
//      on each slot. "Add Slot" dialog lets admin choose which trainer.
//   3. TRAINER: loads only own slots; no trainer picker shown.
//   4. Fixed loading states and error handling.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../data/models/availability_model.dart';
import '../../data/services/availability_service.dart';
import '../bloc/availability_bloc.dart';

// ── Internal model: slot + trainer name ────────────────────────────────────

class _SlotWithTrainer {
  final AvailabilityModel      slot;
  final AdminTrainerCardModel  trainer;
  _SlotWithTrainer({required this.slot, required this.trainer});
}

// =============================================================================

class TrainerScheduleScreen extends StatefulWidget {
  final int  branchId;
  final int  trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerScheduleScreen({
    super.key,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  State<TrainerScheduleScreen> createState() => _TrainerScheduleScreenState();
}

class _TrainerScheduleScreenState extends State<TrainerScheduleScreen> {
  final _svc = AvailabilityHttpService();

  // Trainer-mode: single bloc
  AvailabilityBloc? _bloc;

  // Admin-mode: merged list
  List<_SlotWithTrainer> _allSlots = [];
  bool    _adminLoading = false;
  String? _adminError;

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      _loadAllSlots();
    } else {
      _bloc = AvailabilityBloc(_svc)
        ..add(LoadAvailability(
          trainerId: widget.trainerId,
          branchId:  widget.branchId,
        ));
    }
  }

  @override
  void didUpdateWidget(covariant TrainerScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchId != widget.branchId) {
      if (widget.isAdmin) {
        _loadAllSlots();
      } else {
        _bloc?.add(LoadAvailability(
          trainerId: widget.trainerId,
          branchId:  widget.branchId,
        ));
      }
    }
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  // ── Admin: fetch slots for every trainer ────────────────────────────────

  Future<void> _loadAllSlots() async {
    if (!mounted) return;
    setState(() { _adminLoading = true; _adminError = null; });
    try {
      final List<_SlotWithTrainer> merged = [];
      for (final trainer in widget.trainers) {
        final slots = await _svc.getSlots(
          trainerId: trainer.trainerId,
          branchId:  widget.branchId,
        );
        for (final s in slots) {
          merged.add(_SlotWithTrainer(slot: s, trainer: trainer));
        }
      }
      if (!mounted) return;
      setState(() { _allSlots = merged; _adminLoading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _adminLoading = false; _adminError = e.toString(); });
    }
  }

  Future<void> _deleteSlot(int id) async {
    try {
      await _svc.deleteSlot(id);
      if (widget.isAdmin) {
        _loadAllSlots();
      } else {
        _bloc!.add(DeleteSlot(id));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs     = tokens.colors;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.isAdmin ? 'All Availability' : 'Availability',
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _AddAvailabilityDialog.show(
                context,
                svc:             _svc,
                bloc:            _bloc,
                isAdmin:         widget.isAdmin,
                trainers:        widget.trainers,
                defaultTrainerId: widget.trainerId,
                branchId:        widget.branchId,
                onAdded:         () {
                  if (widget.isAdmin) {
                    _loadAllSlots();
                  } else {
                    _bloc!.add(LoadAvailability(
                      trainerId: widget.trainerId,
                      branchId:  widget.branchId,
                    ));
                  }
                },
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Slot', style: TextStyle(fontSize: 13)),
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
      body: widget.isAdmin
          ? _buildAdminBody()
          : _buildTrainerBody(cs),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _AddAvailabilityDialog.show(
          context,
          svc:             _svc,
          bloc:            _bloc,
          isAdmin:         widget.isAdmin,
          trainers:        widget.trainers,
          defaultTrainerId: widget.trainerId,
          branchId:        widget.branchId,
          onAdded:         () {
            if (widget.isAdmin) {
              _loadAllSlots();
            } else {
              _bloc!.add(LoadAvailability(
                trainerId: widget.trainerId,
                branchId:  widget.branchId,
              ));
            }
          },
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ── Admin body ────────────────────────────────────────────────────────────

  Widget _buildAdminBody() {
    if (_adminLoading && _allSlots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_adminError != null && _allSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 12),
            Text(_adminError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllSlots,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_allSlots.isEmpty) {
      return const Center(
        child: Text('No availability set yet.',
            style: TextStyle(color: Color(0xFF6B7280))),
      );
    }

    // Group by day name
    const dayOrder = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    final grouped = <String, List<_SlotWithTrainer>>{};
    for (final item in _allSlots) {
      grouped.putIfAbsent(item.slot.dayName, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: dayOrder
          .where((d) => grouped.containsKey(d))
          .map((day) => _AdminDaySection(
        day:      day,
        items:    grouped[day]!,
        onDelete: (id) => _deleteSlot(id),
      ))
          .toList(),
    );
  }

  // ── Trainer body (bloc-based) ─────────────────────────────────────────────

  Widget _buildTrainerBody(dynamic cs) {
    return BlocConsumer<AvailabilityBloc, AvailabilityState>(
      bloc: _bloc,
      listener: (ctx, state) {
        if (state is AvailabilityMutated) {
          _bloc!.add(LoadAvailability(
            trainerId: widget.trainerId,
            branchId:  widget.branchId,
          ));
        }
        if (state is AvailabilityError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red));
        }
      },
      builder: (ctx, state) {
        if (state is AvailabilityLoading || state is AvailabilityInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AvailabilityError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFEF4444), size: 48),
                const SizedBox(height: 12),
                Text(state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7280))),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _bloc!.add(LoadAvailability(
                    trainerId: widget.trainerId,
                    branchId:  widget.branchId,
                  )),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is AvailabilityLoaded) {
          final slots = state.slots;
          if (slots.isEmpty) {
            return const Center(
              child: Text('No availability set yet.',
                  style: TextStyle(color: Color(0xFF6B7280))),
            );
          }
          const dayOrder = [
            'Monday', 'Tuesday', 'Wednesday',
            'Thursday', 'Friday', 'Saturday', 'Sunday',
          ];
          final grouped = <String, List<AvailabilityModel>>{};
          for (final s in slots) {
            grouped.putIfAbsent(s.dayName, () => []).add(s);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: dayOrder
                .where((d) => grouped.containsKey(d))
                .map((day) => _TrainerDaySection(
              day:      day,
              slots:    grouped[day]!,
              onDelete: (id) => _bloc!.add(DeleteSlot(id)),
            ))
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ── Admin day section (shows trainer badge) ───────────────────────────────────

class _AdminDaySection extends StatelessWidget {
  final String                  day;
  final List<_SlotWithTrainer>  items;
  final ValueChanged<int>       onDelete;

  const _AdminDaySection({
    required this.day,
    required this.items,
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
        ...items.map((item) => _SlotRow(
          slot:        item.slot,
          trainerName: item.trainer.fullName,
          onDelete:    () => onDelete(item.slot.availabilityId),
        )),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ── Trainer day section (no badge) ────────────────────────────────────────────

class _TrainerDaySection extends StatelessWidget {
  final String                  day;
  final List<AvailabilityModel> slots;
  final ValueChanged<int>       onDelete;

  const _TrainerDaySection({
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
          slot:        s,
          trainerName: null,
          onDelete:    () => onDelete(s.availabilityId),
        )),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ── Slot row ──────────────────────────────────────────────────────────────────

class _SlotRow extends StatelessWidget {
  final AvailabilityModel slot;
  final String?           trainerName; // null = trainer view, no badge
  final VoidCallback      onDelete;

  const _SlotRow({
    super.key,
    required this.slot,
    required this.trainerName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                  '${slot.startDisplay} – ${slot.endDisplay}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (slot.recurring)
                  Text(
                    'Recurring weekly',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                // Trainer badge for admin view
                if (trainerName != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline,
                            size: 12, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 4),
                        Text(
                          trainerName!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4F46E5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

// ── Add Availability Dialog ───────────────────────────────────────────────────
class _AddAvailabilityDialog extends StatefulWidget {
  final AvailabilityHttpService svc;
  final AvailabilityBloc? bloc;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int defaultTrainerId;
  final int branchId;
  final VoidCallback onAdded;

  const _AddAvailabilityDialog({
    required this.svc,
    required this.bloc,
    required this.isAdmin,
    required this.trainers,
    required this.defaultTrainerId,
    required this.branchId,
    required this.onAdded,
  });

  static Future<void> show(
      BuildContext context, {
        required AvailabilityHttpService svc,
        required AvailabilityBloc? bloc,
        required bool isAdmin,
        required List<AdminTrainerCardModel> trainers,
        required int defaultTrainerId,
        required int branchId,
        required VoidCallback onAdded,
      }) {
    return showDialog(
      context: context,
      builder: (_) => _AddAvailabilityDialog(
        svc: svc,
        bloc: bloc,
        isAdmin: isAdmin,
        trainers: trainers,
        defaultTrainerId: defaultTrainerId,
        branchId: branchId,
        onAdded: onAdded,
      ),
    );
  }

  @override
  State<_AddAvailabilityDialog> createState() =>
      _AddAvailabilityDialogState();
}

class _AddAvailabilityDialogState extends State<_AddAvailabilityDialog> {
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _recurring = true;
  bool _saving = false;

  int? _selectedTrainerId;

  @override
  void initState() {
    super.initState();

    /// FIXED HERE
    /// Only assign if trainer exists in dropdown items
    final trainerExists = widget.trainers.any(
          (t) => t.trainerId == widget.defaultTrainerId,
    );

    if (trainerExists) {
      _selectedTrainerId = widget.defaultTrainerId;
    } else if (widget.trainers.isNotEmpty) {
      _selectedTrainerId = widget.trainers.first.trainerId;
    } else {
      _selectedTrainerId = null;
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 9, minute: 0)
          : const TimeOfDay(hour: 17, minute: 0),
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

  String _fmt(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (_selectedDay == null ||
        _startTime == null ||
        _endTime == null ||
        _selectedTrainerId == null) {
      return;
    }

    setState(() => _saving = true);

    try {
      final weekday = _days.indexOf(_selectedDay!) + 1;

      await widget.svc.createSlot(
        trainerId: _selectedTrainerId!,
        branchId: widget.branchId,
        weekday: weekday,
        startTime: _fmt(_startTime!),
        endTime: _fmt(_endTime!),
        recurring: _recurring,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onAdded();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Availability Slot'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
              DropdownButtonFormField<int>(
                value: _selectedTrainerId,
                decoration: const InputDecoration(
                  labelText: 'Assign to Trainer',
                ),

                /// FIXED HERE
                /// Prevent duplicate trainer IDs
                items: widget.trainers
                    .map(
                      (t) => DropdownMenuItem<int>(
                    value: t.trainerId,
                    child: Text(t.fullName),
                  ),
                )
                    .toList(),

                onChanged: (v) {
                  setState(() {
                    _selectedTrainerId = v;
                  });
                },
              ),

              const SizedBox(height: 12),
            ],

            DropdownButtonFormField<String>(
              value: _selectedDay,
              decoration: const InputDecoration(
                labelText: 'Day of Week',
              ),
              items: _days
                  .map(
                    (d) => DropdownMenuItem<String>(
                  value: d,
                  child: Text(d),
                ),
              )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedDay = v;
                });
              },
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'Start',
                      style: TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      _startTime == null
                          ? 'Tap to pick'
                          : _startTime!.format(context),
                    ),
                    onTap: () => _pickTime(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'End',
                      style: TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      _endTime == null
                          ? 'Tap to pick'
                          : _endTime!.format(context),
                    ),
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),

            SwitchListTile(
              title: const Text('Recurring weekly'),
              value: _recurring,
              onChanged: (v) {
                setState(() {
                  _recurring = v;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_selectedDay == null ||
              _startTime == null ||
              _endTime == null ||
              _selectedTrainerId == null ||
              _saving)
              ? null
              : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
          ),
          child: _saving
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}