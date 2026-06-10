import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
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

  void _showReactivateConfirmation(BuildContext context, int sessionId) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(l10n.admin_classes_reactivateTitle,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        content: Text(
          l10n.admin_classes_reactivateMessage,
          style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.general_cancel,
                style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AdminClassesBloc>().add(
                ClassReactivateRequested(sessionId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.admin_classes_reactivateConfirm),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, int sessionId) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(l10n.admin_classes_cancelTitle,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        content: Text(
          l10n.admin_classes_cancelMessage,
          style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.admin_classes_keepClass,
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
            child: Text(l10n.admin_classes_cancelConfirm),
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
        sessionId: session.sessionId,
        existing: session,
        existingDate: _lastLoadedState?.selectedDate);
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
              final l10n = AppLocalizations.of(context)!;
              final message = switch (state.actionType) {
                'created'     => l10n.admin_classes_createdSuccess,
                'updated'     => l10n.admin_classes_updatedSuccess,
                'cancelled'   => l10n.admin_classes_cancelledSuccess,
                'reactivated' => l10n.admin_classes_reactivatedSuccess,
                _             => 'Done',
              };
              AppToast.success(context, message);
              // BLoC already refreshes the list internally with the correct date —
              // do NOT dispatch another ClassesStarted here or it overwrites to today.
            }

            if (state is ClassActionError) {
              AppToast.error(context, state.message);
            }
          },
          builder: (context, state) {
            final loadedState =
            state is ClassesLoaded ? state : _lastLoadedState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminAppBar(
                  title:            AppLocalizations.of(context)!.navClasses,
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
                            child: Text(AppLocalizations.of(context)!.retry),
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
                                AppLocalizations.of(context)!.admin_classes_noClasses,
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
                              onEditTap:        () => _openEditClassSheet(session),
                              onCancelTap:      () => _showCancelConfirmation(
                                  context, session.sessionId),
                              onReactivateTap:  () => _showReactivateConfirmation(
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