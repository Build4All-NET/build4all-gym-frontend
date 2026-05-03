// PATH: lib/features/admin/classes/presentation/screens/admin_classes_screen.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';
import '../widgets/add_edit_class_bottom_sheet.dart';
import '../widgets/class_date_filter_widget.dart';
import '../widgets/session_bookings_bottom_sheet.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  int? _selectedBranchId;
  ClassesLoaded? _lastLoadedState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminClassesBloc>().add(
        ClassesStarted(DateTime.now()),
      );
    });
  }

  void _onBranchChanged(int? branchId) {
    setState(() {
      _selectedBranchId = branchId;
    });

    context.read<AdminClassesBloc>().add(
      ClassesStarted(DateTime.now()),
    );
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
        title: const Text(
          'Cancel Class',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to cancel this class? All booked members will be notified.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Class'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();

              context.read<AdminClassesBloc>().add(
                ClassCancelRequested(
                  sessionId,
                  cancelReason: null,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddClassSheet() {
    context.read<AdminClassesBloc>().add(
      const ClassFormOptionsRequested(),
    );

    AddEditClassBottomSheet.show(context);
  }

  void _openEditClassSheet(dynamic session) {
    context.read<AdminClassesBloc>().add(
      const ClassFormOptionsRequested(),
    );

    AddEditClassBottomSheet.show(
      context,
      sessionId: session.sessionId,
      existing: session,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminNavigationDrawer(
        gymName: 'Build4All Gym',
        branchName: 'Downtown',
        adminName: 'Mounir',
        adminEmail: 'mounir@gym.com',
        avatarUrl: null,
        initialActiveId: 'classes_pt',
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: BlocConsumer<AdminClassesBloc, AdminClassesState>(
          listener: (context, state) {
            if (state is ClassesLoaded) {
              _lastLoadedState = state;
            }

            if (state is ClassActionSuccess) {
              final messages = {
                'created': 'Class created successfully',
                'updated': 'Class updated successfully',
                'cancelled': 'Class cancelled',
              };

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(messages[state.actionType] ?? 'Done'),
                  backgroundColor: const Color(0xFF4CAF50),
                  behavior: SnackBarBehavior.floating,
                ),
              );

              context.read<AdminClassesBloc>().add(
                ClassesStarted(DateTime.now()),
              );
            }

            if (state is ClassActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFF44336),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final loadedState =
            state is ClassesLoaded ? state : _lastLoadedState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminAppBar(
                  title: 'Classes',
                  selectedBranchId: _selectedBranchId,
                  onBranchChanged: _onBranchChanged,
                  onAddTap: _openAddClassSheet,
                ),

                if (state is ClassesLoading && loadedState == null)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is ClassesError && loadedState == null)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Color(0xFFF44336),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: Color(0xFFF44336),
                            ),
                          ),
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
                else if (loadedState != null)
                    ...[
                      const SizedBox(height: 12),

                      ClassDateFilterWidget(
                        selectedDate: loadedState.selectedDate,
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _formatSectionHeader(loadedState.selectedDate),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: loadedState.classes.isEmpty
                            ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 48,
                                color: Color(0xFFBDBDBD),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No classes scheduled for this day',
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: loadedState.classes.length,
                          itemBuilder: (context, index) {
                            final session =
                            loadedState.classes[index];

                            final loadingId = state is ClassActionLoading
                                ? state.sessionId
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
                              onEditTap: () => _openEditClassSheet(session),
                              onCancelTap: () => _showCancelConfirmation(
                                context,
                                session.sessionId,
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  else
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}