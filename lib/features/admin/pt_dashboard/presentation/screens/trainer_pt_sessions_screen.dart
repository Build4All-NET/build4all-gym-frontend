// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_pt_sessions_screen.dart
//
// CHANGES:
//   1. SessionCardWidget now receives isAdmin param so it can show trainer badge.
//   2. Retry event passes trainerNames for admin all-trainers mode.
//   3. Admin: the session list already contains ALL trainers' services (the bloc
//      fetches per-trainer and merges). No separate fetching needed here.
//   4. Fixed BookSessionSheet to use proper tenantId from token store.
// =============================================================================

import 'package:build4allgym/features/member/sessions/presentation/bloc/sessions_bloc.dart';
import 'package:build4allgym/features/member/sessions/presentation/bloc/sessions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/data/services/admin_token_store.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_event.dart';
import '../widgets/session_card_widget.dart';
import '../widgets/book_session_sheet_widget.dart';

class TrainerPtSessionsScreen extends StatelessWidget {
  final int  branchId;
  final int  trainerId;   // 0 for admin all-trainers mode
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerPtSessionsScreen({
    super.key,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  Widget build(BuildContext context) {
    return _SessionsView(
      branchId:  branchId,
      trainerId: trainerId,
      isAdmin:   isAdmin,
      trainers:  trainers,
    );
  }
}

// ── Main view ─────────────────────────────────────────────────────────────────

class _SessionsView extends StatelessWidget {
  final int  branchId;
  final int  trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const _SessionsView({
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.read<ThemeCubit>().state.tokens.colors;
    final tokenStore = AdminTokenStore();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          isAdmin ? 'All Sessions' : 'Sessions',
          style: const TextStyle(
            color:      Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize:   20,
          ),
        ),
        actions: [
          BlocBuilder<TrainerPtSessionsBloc, TrainerPtSessionsState>(
            builder: (context, state) {
              final date = state is PtSessionsLoaded
                  ? state.selectedDate
                  : DateTime.now();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final tenantIdStr = tokenStore.getTenantId();
                    final tenantId = int.tryParse(tenantIdStr.toString()) ?? 1;
                    BookSessionSheet.show(
                      context,
                      branchId:     branchId,
                      tenantId:     tenantId,
                      trainerId:    (isAdmin && trainers.isNotEmpty)
                          ? trainers.first.trainerId
                          : trainerId,
                      isAdmin:      isAdmin,
                      trainers:     trainers,
                      selectedDate: date,
                    );
                  },
                  icon:  const Icon(Icons.add, size: 18),
                  label: const Text('Book Session', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    elevation:  0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TrainerPtSessionsBloc, TrainerPtSessionsState>(
        listener: (context, state) {
          if (state is PtSessionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:         Text(_successMsg(state.actionType)),
                backgroundColor: const Color(0xFF22C55E),
                behavior:        SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
          if (state is PtSessionActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:         Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
                behavior:        SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        buildWhen: (prev, curr) =>
        curr is PtSessionsLoading ||
            curr is PtSessionsLoaded  ||
            curr is PtSessionsError   ||
            curr is PtSessionsInitial ||
            curr is PtSessionActionLoading ||
            curr is PtSessionActionSuccess ||
            curr is PtSessionActionError,
        builder: (context, state) {
          if (state is PtSessionsLoading || state is PtSessionsInitial) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }

          if (state is PtSessionsError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<TrainerPtSessionsBloc>().add(PtSessionsStarted(
                  branchId:     branchId,
                  trainerId:    trainerId,
                  trainerNames: isAdmin
                      ? { for (final t in trainers) t.trainerId: t.fullName }
                      : const {},
                ));
              },
            );
          }

          // Handle action states by extracting the loaded state
          PtSessionsLoaded? loadedState;
          if (state is PtSessionsLoaded) loadedState = state;
          if (state is PtSessionActionLoading) loadedState = state.previousState;
          if (state is PtSessionActionSuccess) loadedState = state.updatedState;
          if (state is PtSessionActionError) loadedState = state.previousState;

          if (loadedState != null) {
            return _LoadedBody(
              state:    loadedState,
              isAdmin:  isAdmin,
              trainers: trainers,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _successMsg(String actionType) {
    switch (actionType) {
      case 'accepted':  return '✅ Session request accepted.';
      case 'declined':  return 'Session request declined.';
      case 'completed': return '✅ Session marked as completed.';
      case 'cancelled': return 'Session cancelled.';
      case 'no_show':   return 'Session marked as no-show.';
      case 'created':   return '✅ Session booked successfully.';
      default:          return 'Session updated.';
    }
  }
}

// ── Loaded body ───────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  final PtSessionsLoaded state;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const _LoadedBody({
    required this.state,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DateNavigator(selectedDate: state.selectedDate),
        _TabFilter(
          selectedIndex: state.selectedTabIndex,
          onTap: (i) => context
              .read<TrainerPtSessionsBloc>()
              .add(PtSessionsTabChanged(tabIndex: i)),
        ),
        Expanded(
          child: state.filteredSessions.isEmpty
              ? _EmptyState(tabIndex: state.selectedTabIndex)
              : ListView.builder(
            padding:   const EdgeInsets.all(16),
            itemCount: state.filteredSessions.length,
            itemBuilder: (_, i) => SessionCardWidget(
              session: state.filteredSessions[i],
              isAdmin: isAdmin,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Date navigator ────────────────────────────────────────────────────────────

class _DateNavigator extends StatelessWidget {
  final DateTime selectedDate;
  const _DateNavigator({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.read<TrainerPtSessionsBloc>().add(
              PtSessionsDateChanged(
                  date: selectedDate.subtract(const Duration(days: 1))),
            ),
            icon: const Icon(Icons.chevron_left_rounded,
                size: 28, color: Color(0xFF4B5563)),
          ),
          Expanded(
            child: Column(
              children: [
                Text(DateFormat('EEEE').format(selectedDate),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E))),
                Text(DateFormat('MMM d, yyyy').format(selectedDate),
                    style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<TrainerPtSessionsBloc>().add(
              PtSessionsDateChanged(
                  date: selectedDate.add(const Duration(days: 1))),
            ),
            icon: const Icon(Icons.chevron_right_rounded,
                size: 28, color: Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }
}

// ── Segmented tab filter ──────────────────────────────────────────────────────

class _TabFilter extends StatelessWidget {
  final int               selectedIndex;
  final ValueChanged<int> onTap;

  static const _tabs = ['Today', 'Upcoming', 'Completed'];

  const _TabFilter({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color:        const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final selected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:  const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: selected
                        ? [BoxShadow(
                        color:     Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset:    const Offset(0, 1))]
                        : [],
                  ),
                  child: Text(
                    _tabs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color:      selected
                          ? const Color(0xFF4F46E5)
                          : Colors.grey[500],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final int tabIndex;
  const _EmptyState({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    const messages = [
      'No services scheduled for today.',
      'No upcoming services.',
      'No completed services yet.',
    ];
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(messages[tabIndex.clamp(0, 2)],
              style: TextStyle(fontSize: 15, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF4B5563))),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}