// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/class_date_filter_widget.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
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

  final List<DateTime> _dates = List.generate(14, (i) {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day - 7 + i);
  });

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    final selectedIndex = _dates.indexWhere((d) =>
    d.year == widget.selectedDate.year &&
        d.month == widget.selectedDate.month &&
        d.day == widget.selectedDate.day);
    if (selectedIndex >= 0) {
      const chipWidth = 60.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (selectedIndex * chipWidth) -
          (screenWidth / 2) +
          (chipWidth / 2);
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
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) =>
      date.year == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day == widget.selectedDate.day;

  String _weekdayLabel(AppLocalizations l10n, DateTime date) {
    final days = [
      l10n.dayMonday,
      l10n.dayTuesday,
      l10n.dayWednesday,
      l10n.dayThursday,
      l10n.dayFriday,
      l10n.daySaturday,
      l10n.daySunday,
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final selected = _isSelected(date);
          final today = _isToday(date);

          return GestureDetector(
            onTap: () => context
                .read<AdminClassesBloc>()
                .add(ClassesDateChanged(date)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color: selected ? cs.primary : cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? cs.primary
                      : cs.outline.withOpacity(0.3),
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    today ? l10n.admin_dashboard_today : _weekdayLabel(l10n, date),
                    style: TextStyle(
                      fontSize: today ? 9 : 10,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? cs.onPrimary
                          : cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? cs.onPrimary : cs.onSurface,
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
// FILE: lib/features/admin/classes/presentation/widgets/class_card_widget.dart
// ─────────────────────────────────────────────────────────────────────────────

class ClassCardWidget extends StatelessWidget {
  final dynamic session;
  final int? loadingSessionId;
  final VoidCallback onBookingsTap;
  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;
  final VoidCallback? onReactivateTap;

  const ClassCardWidget({
    super.key,
    required this.session,
    this.loadingSessionId,
    required this.onBookingsTap,
    required this.onEditTap,
    required this.onCancelTap,
    this.onReactivateTap,
  });

  // Capacity bar colors are semantic data indicators — intentionally NOT theme-driven
  Color _capacityBarColor(int booked, int capacity) {
    if (capacity == 0) return Colors.grey;
    final ratio = booked / capacity;
    if (ratio < 0.6) return const Color(0xFF4CAF50);
    if (ratio < 0.8) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = loadingSessionId == session.sessionId;
    final fillRatio = session.capacity > 0
        ? (session.bookedCount / session.capacity).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.06),
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

            // ── Row 1: Class name + status badge ──────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.className,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (session.status == 'CANCELLED')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.admin_classes_statusCancelled,
                      style: TextStyle(
                        color: cs.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (session.status == 'COMPLETED')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.admin_classes_statusCompleted,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                // "Nearly Full" badge — orange is semantic (warning), not brand
                else if (session.nearlyFull)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.admin_classes_nearlyFull,
                      style: const TextStyle(
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
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.outline.withOpacity(0.3)),
              ),
              child: Text(
                session.typeName,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Info grid ──────────────────────────────────────────────────
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
                      label: l10n.memberHomeDurationMinutes(session.durationMinutes)),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Capacity ───────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.admin_classes_capacity,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${session.bookedCount}/${session.capacity}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fillRatio,
                minHeight: 6,
                backgroundColor: cs.outline.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(
                    _capacityBarColor(session.bookedCount, session.capacity)),
              ),
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: cs.outline.withOpacity(0.1)),
            const SizedBox(height: 12),

            // ── Action buttons ─────────────────────────────────────────────
            if (isLoading)
              Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: cs.primary),
                ),
              )
            else if (session.status == 'CANCELLED')
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.people_outline,
                    label: l10n.classFilterBookings,
                    color: cs.primary,
                    onTap: onBookingsTap,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.refresh_rounded,
                    label: l10n.classFilterReactivate,
                    color: cs.tertiary != cs.surface ? cs.tertiary : const Color(0xFF4CAF50),
                    onTap: onReactivateTap ?? () {},
                  ),
                ],
              )
            else if (session.status == 'COMPLETED')
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.people_outline,
                    label: l10n.classFilterBookings,
                    color: cs.primary,
                    onTap: onBookingsTap,
                  ),
                ],
              )
            else
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.people_outline,
                    label: l10n.classFilterBookings,
                    color: cs.primary,
                    onTap: onBookingsTap,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    label: l10n.classFilterEdit,
                    color: cs.onSurface.withOpacity(0.6),
                    onTap: onEditTap,
                  ),
                  const SizedBox(width: 8),
                  // Cancel button — error color is semantic
                  _ActionButton(
                    icon: Icons.close,
                    label: l10n.classFilterCancel,
                    color: cs.error,
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

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 15, color: cs.onSurface.withOpacity(0.4)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 13, color: cs.onSurface.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
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
        label: Text(
          label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w600),
        ),
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