// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/class_date_filter_widget.dart
//
// PURPOSE:
//   Horizontally scrollable row of date chips covering 14 days (7 before + today
//   + 6 after). Auto-scrolls to center the selected chip on first render.
//   Tapping a chip dispatches ClassesDateChanged to AdminClassesBloc.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';

class ClassDateFilterWidget extends StatefulWidget {
  final DateTime selectedDate;

  const ClassDateFilterWidget({super.key, required this.selectedDate});

  @override
  State<ClassDateFilterWidget> createState() => _ClassDateFilterWidgetState();
}

class _ClassDateFilterWidgetState extends State<ClassDateFilterWidget> {
  late final ScrollController _scrollController;

  // Generate 14 dates: 7 days before today through 6 days after today
  // Today sits at index 7 (the center)
  final List<DateTime> _dates = List.generate(14, (i) {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day - 7 + i);
  });

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll to center today's chip after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    // Each chip is approximately 60px wide — scroll to put selected in center
    final selectedIndex = _dates.indexWhere((d) =>
    d.year  == widget.selectedDate.year &&
        d.month == widget.selectedDate.month &&
        d.day   == widget.selectedDate.day);
    if (selectedIndex >= 0) {
      final chipWidth = 60.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (selectedIndex * chipWidth) - (screenWidth / 2) + (chipWidth / 2);
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSelected(DateTime date) =>
      date.year  == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day   == widget.selectedDate.day;

  String _weekdayLabel(DateTime date) {
    // Short weekday abbreviation
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date     = _dates[index];
          final selected = _isSelected(date);
          final today    = _isToday(date);

          return GestureDetector(
            onTap: () {
              // Dispatch date change event to BLoC
              context.read<AdminClassesBloc>().add(ClassesDateChanged(date));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1A1A2E)   // dark filled for selected
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFE0E0E0),
                ),
                boxShadow: selected
                    ? [BoxShadow(
                    color: const Color(0xFF1A1A2E).withOpacity(0.2),
                    blurRadius: 8, offset: const Offset(0, 2))]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Show "Today" label for today's chip, weekday for others
                    today ? 'Today' : _weekdayLabel(date),
                    style: TextStyle(
                      fontSize: today ? 9 : 10,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// FILE: class_card_widget.dart
//
// PURPOSE:
//   Displays ONE class session as a white card matching the Figma design.
//   Shows: class name, type tag, trainer, branch, time, duration, capacity bar,
//   and three action buttons (Bookings, Edit, Cancel).
//
//   nearlyFull = true → shows orange "Nearly Full" badge top-right.
//   Capacity bar color changes based on fill percentage:
//     < 60%  → green
//     60-80% → orange
//     > 80%  → red
// ─────────────────────────────────────────────────────────────────────────────

class ClassCardWidget extends StatelessWidget {
  final dynamic session;       // AdminClassCardEntity
  final int?    loadingSessionId; // from ClassActionLoading state — which card is spinning
  final VoidCallback onBookingsTap;
  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;

  const ClassCardWidget({
    super.key,
    required this.session,
    this.loadingSessionId,
    required this.onBookingsTap,
    required this.onEditTap,
    required this.onCancelTap,
  });

  Color _capacityBarColor(int booked, int capacity) {
    if (capacity == 0) return Colors.grey;
    final ratio = booked / capacity;
    if (ratio < 0.6) return const Color(0xFF4CAF50);  // green
    if (ratio < 0.8) return const Color(0xFFFF9800);  // orange
    return const Color(0xFFF44336);                    // red
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = loadingSessionId == session.sessionId;
    final fillRatio = session.capacity > 0
        ? (session.bookedCount / session.capacity).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Row 1: Class name + Nearly Full badge ──────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.className,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                if (session.nearlyFull)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Nearly Full',
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Type tag chip ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Text(
                session.typeName,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF616161),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Info grid: trainer, branch, time, duration ─────────────────
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                      icon: Icons.person_outline,
                      label: session.trainerName),
                ),
                Expanded(
                  child: _InfoItem(
                      icon: Icons.location_on_outlined,
                      label: session.branchName),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                      icon: Icons.access_time_outlined,
                      label: session.startTime),
                ),
                Expanded(
                  child: _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: '${session.durationMinutes} min'),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Capacity row + progress bar ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Capacity',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500)),
                Text(
                  '${session.bookedCount}/${session.capacity}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fillRatio,
                minHeight: 6,
                backgroundColor: const Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(
                    _capacityBarColor(session.bookedCount, session.capacity)),
              ),
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),

            // ── Action buttons ─────────────────────────────────────────────
            isLoading
                ? const Center(
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : Row(
              children: [
                // Bookings button
                _ActionButton(
                  icon: Icons.people_outline,
                  label: 'Bookings',
                  color: const Color(0xFF1A1A2E),
                  onTap: onBookingsTap,
                ),
                const SizedBox(width: 8),
                // Edit button
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: const Color(0xFF616161),
                  onTap: onEditTap,
                ),
                const SizedBox(width: 8),
                // Cancel button — red
                _ActionButton(
                  icon: Icons.close,
                  label: 'Cancel',
                  color: const Color(0xFFF44336),
                  onTap: onCancelTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers for ClassCardWidget ──────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String   label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF424242)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 15, color: color),
        label: Text(label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: color.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}