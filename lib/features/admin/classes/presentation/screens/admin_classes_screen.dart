// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/screens/admin_classes_screen.dart
//
// PURPOSE:
//   The main "Classes & Schedules" screen shown in the screenshots.
//   Wraps everything in a BlocProvider and handles the full state lifecycle.
//
// LAYOUT (top to bottom, matching Figma):
//   1. AppBar: hamburger menu | branch chip (center) | + add button | bell
//   2. ClassDateFilterWidget — horizontally scrollable date chips
//   3. Section label: "Today's Classes — Monday, March 16, 2026"
//   4. ListView of ClassCardWidgets (or empty state / loading / error)
//
// BlocConsumer:
//   LISTENER: ClassActionSuccess → green snackbar + list refresh
//             ClassActionError   → red snackbar
//   BUILDER:  ClassesLoading     → CircularProgressIndicator
//             ClassesLoaded      → date filter + card list
//             ClassesError       → error text + Retry button
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    // Kick off the initial load with today's date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminClassesBloc>().add(ClassesStarted(DateTime.now()));
    });
  }

  // Formats the selected date for the section header label
  String _formatSectionHeader(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final dayLabel = isToday
        ? "Today's Classes"
        : DateFormat('EEEE\'s Classes').format(date); // e.g. "Monday's Classes"
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
      backgroundColor: const Color(0xFFF5F6FA),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1A1A2E)),
          onPressed: () {
            // Open admin drawer — connect to your existing DrawerScreen
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Column(
          children: [
            const Text(
              'Classes & Schedules',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E)),
            ),
            // Branch context chip — matches the "Viewing: Mumbai Central" in screenshot
            BlocBuilder<AdminClassesBloc, AdminClassesState>(
              builder: (context, state) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        size: 12, color: Color(0xFF757575)),
                    const SizedBox(width: 2),
                    const Text(
                      'Viewing: Mumbai Central',
                      style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // + Add New Class button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
            onPressed: () {
              // Load form options then open Add sheet
              context.read<AdminClassesBloc>()
                  .add(const ClassFormOptionsRequested());
              AddEditClassBottomSheet.show(context);
            },
          ),
          // Notification bell
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined,
                  color: Color(0xFF1A1A2E)),
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: BlocConsumer<AdminClassesBloc, AdminClassesState>(
        listener: (context, state) {
          // ── Success: show green snackbar ─────────────────────────────
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

          // ── Error: show red snackbar ─────────────────────────────────
          if (state is ClassActionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFF44336),
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {

          // ── Loading ────────────────────────────────────────────────
          if (state is ClassesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── Error ──────────────────────────────────────────────────
          if (state is ClassesError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message,
                      style: const TextStyle(color: Color(0xFFF44336))),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AdminClassesBloc>()
                        .add(ClassesStarted(DateTime.now())),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ── Loaded ─────────────────────────────────────────────────
          if (state is ClassesLoaded) {
            final loadingSessionId =
            state is ClassActionLoading ? (state as dynamic).sessionId : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

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
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: state.classes.length,
                    itemBuilder: (context, index) {
                      final session = state.classes[index];
                      return ClassCardWidget(
                        session: session,
                        loadingSessionId: loadingSessionId,
                        // Bookings button
                        onBookingsTap: () {
                          SessionBookingsBottomSheet.show(
                            context,
                            sessionId: session.sessionId,
                            className: session.className,
                          );
                        },
                        // Edit button
                        onEditTap: () {
                          context.read<AdminClassesBloc>()
                              .add(const ClassFormOptionsRequested());
                          AddEditClassBottomSheet.show(
                            context,
                            sessionId: session.sessionId,
                            existing: session,
                          );
                        },
                        // Cancel button — shows confirmation dialog first
                        onCancelTap: () => _showCancelConfirmation(
                            context, session.sessionId),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // Default initial state — empty while first load fires
          return const SizedBox.shrink();
        },
      ),
    );
  }
}