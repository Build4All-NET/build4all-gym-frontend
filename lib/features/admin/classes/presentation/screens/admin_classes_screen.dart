import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
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
      context.read<AdminClassesBloc>().add(ClassesStarted(DateTime.now()));
    });
  }

  void _onBranchChanged(int? branchId) {
    setState(() => _selectedBranchId = branchId);
    context.read<AdminClassesBloc>().add(ClassesStarted(DateTime.now()));
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
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text('Cancel Class',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        content: Text(
          'Are you sure you want to cancel this class? All booked members will be notified.',
          style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Keep Class',
                style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AdminClassesBloc>().add(
                ClassCancelRequested(sessionId, cancelReason: null),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _openAddClassSheet() {
    context.read<AdminClassesBloc>().add(const ClassFormOptionsRequested());
    AddEditClassBottomSheet.show(context);
  }

  void _openEditClassSheet(dynamic session) {
    context.read<AdminClassesBloc>().add(const ClassFormOptionsRequested());
    AddEditClassBottomSheet.show(context,
        sessionId: session.sessionId, existing: session);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer:  AdminNavigationDrawer(
        gymName:    profile.gymName,
        branchName: profile.branchName,
        adminName:  profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl:  profile.avatarUrl,
        initialActiveId: 'classes_pt',
      ),
      backgroundColor: cs.background,               // ← was Color(0xFFF5F6FA)
      body: SafeArea(
        child: BlocConsumer<AdminClassesBloc, AdminClassesState>(
          listener: (context, state) {
            if (state is ClassesLoaded) _lastLoadedState = state;

            if (state is ClassActionSuccess) {
              final messages = {
                'created':   'Class created successfully',
                'updated':   'Class updated successfully',
                'cancelled': 'Class cancelled',
              };
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:         Text(messages[state.actionType] ?? 'Done'),
                backgroundColor: cs.primary,         // ← was Color(0xFF4CAF50)
                behavior:        SnackBarBehavior.floating,
              ));
              context.read<AdminClassesBloc>().add(ClassesStarted(DateTime.now()));
            }

            if (state is ClassActionError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:         Text(state.message),
                backgroundColor: cs.error,            // ← was Color(0xFFF44336)
                behavior:        SnackBarBehavior.floating,
              ));
            }
          },
          builder: (context, state) {
            final loadedState =
            state is ClassesLoaded ? state : _lastLoadedState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminAppBar(
                  title:            'Classes',
                  selectedBranchId: _selectedBranchId,
                  onBranchChanged:  _onBranchChanged,
                  onAddTap:         _openAddClassSheet,
                ),

                if (state is ClassesLoading && loadedState == null)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: cs.primary),
                    ),
                  )
                else if (state is ClassesError && loadedState == null)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: cs.error),  // ← was hardcoded
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: TextStyle(color: cs.error)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AdminClassesBloc>()
                                .add(ClassesStarted(DateTime.now())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (loadedState != null)
                    ...[
                      const SizedBox(height: 12),
                      ClassDateFilterWidget(selectedDate: loadedState.selectedDate),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _formatSectionHeader(loadedState.selectedDate),
                          style: TextStyle(
                            fontSize:   13,
                            fontWeight: FontWeight.w600,
                            color:      cs.onSurface.withOpacity(0.5), // ← was Color(0xFF757575)
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: loadedState.classes.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.event_busy,
                                  size: 48,
                                  color: cs.onSurface.withOpacity(0.3)), // ← was Color(0xFFBDBDBD)
                              const SizedBox(height: 12),
                              Text(
                                'No classes scheduled for this day',
                                style: TextStyle(
                                  color:    cs.onSurface.withOpacity(0.4), // ← was Color(0xFF9E9E9E)
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
                            final session = loadedState.classes[index];
                            final loadingId = state is ClassActionLoading
                                ? state.sessionId
                                : null;
                            return ClassCardWidget(
                              session:          session,
                              loadingSessionId: loadingId,
                              onBookingsTap: () {
                                SessionBookingsBottomSheet.show(
                                  context,
                                  sessionId: session.sessionId,
                                  className: session.className,
                                );
                              },
                              onEditTap:   () => _openEditClassSheet(session),
                              onCancelTap: () => _showCancelConfirmation(
                                  context, session.sessionId),
                            );
                          },
                        ),
                      ),
                    ]
                  else
                    const Expanded(child: SizedBox.shrink()),
              ],
            );
          },
        ),
      ),
    );
  }
}