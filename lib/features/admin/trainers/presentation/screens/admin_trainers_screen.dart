// FILE: lib/features/admin/trainers/presentation/screens/admin_trainers_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/AdminTrainerDetailEntity.dart';
import '../../domain/entities/trainer_form_options_entity.dart';
import '../bloc/admin_trainers_bloc.dart';
import '../bloc/admin_trainers_event.dart';
import '../bloc/admin_trainers_state.dart';
import '../widgets/add_edit_trainer_bottom_sheet.dart';
import '../widgets/trainer_card_widget.dart';
import '../widgets/trainer_search_filter_bar_widget.dart';

class AdminTrainersScreen extends StatefulWidget {
  const AdminTrainersScreen({super.key});

  @override
  State<AdminTrainersScreen> createState() => _AdminTrainersScreenState();
}

class _AdminTrainersScreenState extends State<AdminTrainersScreen> {
  TrainerFormOptionsEntity? _cachedOptions;
  int? _pendingEditTrainerId;
  TrainersLoaded? _lastLoadedState;
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AdminTrainersBloc>();
      bloc.add(const TrainersStarted());
      bloc.add(const TrainerFormOptionsRequested());
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context:           context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _closeDialogIfOpen() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _openAddSheet() {
    final options = _cachedOptions;
    if (options == null) {
      context.read<AdminTrainersBloc>().add(
        const TrainerFormOptionsRequested(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Loading trainer form options...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    AddEditTrainerBottomSheet.show(
      context,
      options:  options,
      onCreate: (request) => context
          .read<AdminTrainersBloc>()
          .add(TrainerCreateRequested(request)),
      onUpdate: (_, __) {},
    );
  }

  void _requestEditTrainer(int trainerId) {
    if (_cachedOptions == null) {
      context.read<AdminTrainersBloc>().add(
        const TrainerFormOptionsRequested(),
      );
    }
    _pendingEditTrainerId = trainerId;
    _showLoadingDialog();
    context.read<AdminTrainersBloc>().add(TrainerDetailRequested(trainerId));
  }

  void _openEditSheet(AdminTrainerDetailEntity detail) {
    final options   = _cachedOptions;
    final trainerId = _pendingEditTrainerId;
    if (options == null || trainerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Trainer form options are not ready yet'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    AddEditTrainerBottomSheet.show(
      context,
      trainerId: trainerId,
      options:   options,
      detail:    detail,
      onCreate:  (_) {},
      onUpdate:  (id, request) => context
          .read<AdminTrainersBloc>()
          .add(TrainerUpdateRequested(id, request)),
    );
  }

  Widget _buildTrainersList(BuildContext context, TrainersLoaded loadedState) {
    final c = context.read<ThemeCubit>().state.tokens.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            '${loadedState.total} Trainer${loadedState.total == 1 ? '' : 's'}',
            style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      c.muted),
          ),
        ),
        Expanded(
          child: loadedState.trainers.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_outlined,
                    size: 48, color: c.border.withOpacity(0.5)),
                const SizedBox(height: 12),
                Text('No trainers found',
                    style: TextStyle(color: c.muted, fontSize: 14)),
              ],
            ),
          )
              : ListView.builder(
            padding:    const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount:  loadedState.trainers.length,
            itemBuilder: (context, index) {
              final trainer = loadedState.trainers[index];
              return TrainerCardWidget(
                trainer:   trainer,
                isLoading: false,
                onEditTap: () =>
                    _requestEditTrainer(trainer.trainerId),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onBranchChanged(int? branchId) {
    setState(() => _selectedBranchId = branchId);
    context.read<AdminTrainersBloc>().add(const TrainersStarted());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    return Scaffold(
      drawer: const AdminNavigationDrawer(
        gymName:         'Build4All Gym',
        branchName:      'Downtown',
        adminName:       'Mounir',
        adminEmail:      'mounir@gym.com',
        avatarUrl:       null,
        initialActiveId: 'trainers',
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: BlocConsumer<AdminTrainersBloc, AdminTrainersState>(
          listener: (context, state) {
            if (state is TrainersLoaded) _lastLoadedState = state;

            if (state is TrainerFormOptionsLoaded) {
              _cachedOptions = state.options;
            }

            if (state is TrainerDetailLoaded) {
              _closeDialogIfOpen();
              _openEditSheet(state.detail);
            }

            if (state is TrainerDetailError) {
              _closeDialogIfOpen();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:         Text(state.message),
                  backgroundColor: c.danger,
                  behavior:        SnackBarBehavior.floating,
                ),
              );
            }

            if (state is TrainerActionSuccess) {
              final messages = {
                'created':   'Trainer added successfully ✓',
                'updated':   'Trainer updated ✓',
                'blocked':   'Trainer blocked',
                'unblocked': 'Trainer unblocked ✓',
              };

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(messages[state.actionType] ?? 'Done'),
                  backgroundColor: state.actionType == 'blocked'
                      ? Color.lerp(c.danger, c.primary, 0.5)
                      : c.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              context.read<AdminTrainersBloc>().add(const TrainersReload());
            }

            if (state is TrainerActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:         Text(state.message),
                  backgroundColor: c.danger,
                  behavior:        SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final loadedState =
            state is TrainersLoaded ? state : _lastLoadedState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminAppBar(
                  title:             'Trainers / PT',
                  selectedBranchId:  _selectedBranchId,
                  onBranchChanged:   _onBranchChanged,
                  onAddTap:          _openAddSheet,
                  notificationCount: 0,
                ),

                const TrainerSearchFilterBarWidget(),
                const SizedBox(height: 4),

                if (state is TrainersLoading && loadedState == null)
                  Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                              color: c.primary)))
                else if (state is TrainersError && loadedState == null)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: c.danger),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: TextStyle(color: c.danger)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AdminTrainersBloc>()
                                .add(const TrainersStarted()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.primary,
                              foregroundColor: c.onPrimary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (loadedState != null)
                    Expanded(
                        child: _buildTrainersList(context, loadedState))
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