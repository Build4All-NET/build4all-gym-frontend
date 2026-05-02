// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/screens/admin_classes_screen.dart
// CHANGE: Replaced AppBar widget with Container-based header that matches
//         AdminDashboardScreen / AdminMembersScreen / AdminPlansScreen exactly.
//
// LAYOUT (top to bottom):
//   SafeArea → Column:
//     1. _ClassesAppBar  — [hamburger] [branch pill] [title] [spacer] [+] [bell]
//     2. ClassDateFilterWidget
//     3. Section label
//     4. ListView of ClassCardWidgets (or empty / loading / error)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';
import '../widgets/class_date_filter_widget.dart';
import '../widgets/add_edit_class_bottom_sheet.dart';
import '../widgets/session_bookings_bottom_sheet.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminClassesBloc>().add(ClassesStarted(DateTime.now()));
    });
  }

  String _formatSectionHeader(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final dayLabel = isToday
        ? "Today's Classes"
        : DateFormat('EEEE\'s Classes').format(date);
    return '$dayLabel — ${DateFormat('EEEE, MMMM d, yyyy').format(date)}';
  }

  void _showCancelConfirmation(BuildContext context, int sessionId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Class',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Are you sure you want to cancel this class? All booked members will be notified.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Class'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AdminClassesBloc>().add(
                  ClassCancelRequested(sessionId, cancelReason: null));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336)),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Drawer ─────────────────────────────────────────────────────────
      drawer: const AdminNavigationDrawer(
        gymName:         'Build4All Gym',
        branchName:      'Downtown',
        adminName:       'Mounir',
        adminEmail:      'mounir@gym.com',
        avatarUrl:       null,
        initialActiveId: 'classes_pt',
      ),
      backgroundColor: const Color(0xFFF5F6FA),

      // ── Body — no appBar property, header is inside SafeArea ────────────
      body: SafeArea(
        child: BlocConsumer<AdminClassesBloc, AdminClassesState>(
          listener: (context, state) {
            if (state is ClassActionSuccess) {
              final messages = {
                'created':   'Class created successfully',
                'updated':   'Class updated successfully',
                'cancelled': 'Class cancelled',
              };
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(messages[state.actionType] ?? 'Done'),
                backgroundColor: const Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (state is ClassActionError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFF44336),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── 1. App bar — matches dashboard / members / plans ─────
                _ClassesAppBar(
                  onAddTap: () {
                    context.read<AdminClassesBloc>()
                        .add(const ClassFormOptionsRequested());
                    AddEditClassBottomSheet.show(context);
                  },
                ),

                // ── 2‑4. Content area ────────────────────────────────────
                if (state is ClassesLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ClassesError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Color(0xFFF44336)),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style:
                              const TextStyle(color: Color(0xFFF44336))),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AdminClassesBloc>()
                                .add(ClassesStarted(DateTime.now())),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is ClassesLoaded) ...[

                    const SizedBox(height: 12),

                    // Date filter chip row
                    ClassDateFilterWidget(selectedDate: state.selectedDate),

                    const SizedBox(height: 16),

                    // Section header label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _formatSectionHeader(state.selectedDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Class list or empty state
                    Expanded(
                      child: state.classes.isEmpty
                          ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_busy,
                                size: 48, color: Color(0xFFBDBDBD)),
                            SizedBox(height: 12),
                            Text('No classes scheduled for this day',
                                style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14)),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding:
                        const EdgeInsets.only(bottom: 80),
                        itemCount: state.classes.length,
                        itemBuilder: (context, index) {
                          final session = state.classes[index];
                          final loadingId = state
                          is ClassActionLoading
                              ? (state as ClassActionLoading)
                              .sessionId
                              : null;
                          return ClassCardWidget(
                            session: session,
                            loadingSessionId: loadingId,
                            onBookingsTap: () {
                              SessionBookingsBottomSheet.show(
                                context,
                                sessionId: session.sessionId,
                                className: session.className,
                              );
                            },
                            onEditTap: () {
                              context.read<AdminClassesBloc>().add(
                                  const ClassFormOptionsRequested());
                              AddEditClassBottomSheet.show(
                                context,
                                sessionId: session.sessionId,
                                existing: session,
                              );
                            },
                            onCancelTap: () =>
                                _showCancelConfirmation(
                                    context, session.sessionId),
                          );
                        },
                      ),
                    ),
                  ] else
                    const Expanded(child: SizedBox.shrink()),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ClassesAppBar
// Mirrors AdminDashboardScreen / AdminMembersScreen / AdminPlansScreen header.
//
// Layout: [hamburger] [branch pill — Expanded] [Classes & Schedules] [spacer]
//         [+ add] [bell]
// ─────────────────────────────────────────────────────────────────────────────
class _ClassesAppBar extends StatelessWidget {
  const _ClassesAppBar({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.onPrimary, // white — same as dashboard
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // ── Hamburger ─────────────────────────────────────────────────
          Builder(
            builder: (ctx) => IconButton(
              icon:      const Icon(Icons.menu_rounded),
              color:     cs.onSurface,
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),

          const SizedBox(width: 10),

          // ── Branch pill (expanded) ────────────────────────────────────
          const Expanded(child: _BranchPill()),

          const SizedBox(width: 10),

          // ── Screen title ──────────────────────────────────────────────
          Text(
            'Classes',
            style: TextStyle(
              fontSize:   17,
              fontWeight: FontWeight.w700,
              color:      cs.onSurface,
            ),
          ),

          const Spacer(),

          // ── + Add new class button ────────────────────────────────────
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color:        cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),

          const SizedBox(width: 8),

          // ── Notification bell ─────────────────────────────────────────
          const _NotificationBell(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BranchPill — identical to AdminMembersScreen._BranchPill
// ─────────────────────────────────────────────────────────────────────────────
class _BranchPill extends StatelessWidget {
  const _BranchPill();

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final pillBg = cs.primary.withOpacity(0.08);
    final pillFg = cs.primary;

    return GestureDetector(
      onTap: () {
        // TODO: show branch picker and dispatch ClassesStarted with new branchId
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color:        pillBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: pillFg),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                'All Branches', // TODO: pull from AuthBloc / branch state
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                  color:      pillFg,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: pillFg),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NotificationBell — identical to AdminMembersScreen._NotificationBell
// ─────────────────────────────────────────────────────────────────────────────
class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  static const int _count = 0; // TODO: drive from notifications BLoC

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          width:  36,
          height: 36,
          decoration: BoxDecoration(
            color:        cs.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: cs.onSurfaceVariant,
            size:  18,
          ),
        ),
        if (_count > 0)
          Positioned(
            top:   2,
            right: 2,
            child: Container(
              width:  16,
              height: 16,
              decoration: BoxDecoration(
                color: cs.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _count > 99 ? '99+' : '$_count',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ],
    );
  }
}