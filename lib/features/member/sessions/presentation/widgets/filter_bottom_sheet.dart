import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/filter_option_item_entity.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../bloc/sessions_state.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? selectedClassTypeId;
  int? selectedTrainerId;
  String? selectedBranchId;
  late SessionsBloc _sessionsBloc;
  bool _didApplyOrReset = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sessionsBloc = context.read<SessionsBloc>();
  }

  @override
  void dispose() {
    if (!_didApplyOrReset) {
      _sessionsBloc.add(const SessionsStarted());
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<SessionsBloc>().add(
      const SessionsFilterOptionsRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.card.radius),
        ),
      ),
      child: BlocBuilder<SessionsBloc, SessionsState>(
        builder: (context, state) {
          List<FilterOptionItemEntity> classTypes = [];
          List<FilterOptionItemEntity> trainers = [];
          List<FilterOptionItemEntity> branches = [];

          if (state is SessionsFilterOptionsLoaded) {
            classTypes = state.classTypes;
            trainers = state.trainers;
            branches = state.branches;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.memberSessionsFilterTitle,
                      style: tokens.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: l10n.memberSessionsFilterClassType,
                value: selectedClassTypeId,
                items: classTypes,
                onChanged: (value) {
                  setState(() {
                    selectedClassTypeId = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              _buildDropdown(
                label: l10n.memberSessionsFilterTrainer,
                value: selectedTrainerId,
                items: trainers,
                onChanged: (value) {
                  setState(() {
                    selectedTrainerId = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              _buildBranchDropdown(
                label: l10n.memberSessionsFilterBranch,
                value: selectedBranchId,
                items: branches,
                onChanged: (value) {
                  setState(() {
                    selectedBranchId = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _didApplyOrReset = true;

                        context.read<SessionsBloc>().add(
                          const SessionsFilterReset(),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.memberSessionsFilterReset,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _didApplyOrReset = true;

                        context.read<SessionsBloc>().add(
                          SessionsFilterApplied(
                            classTypeId: selectedClassTypeId,
                            trainerId: selectedTrainerId,
                            branchId: selectedBranchId,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.memberSessionsFilterApply,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<FilterOptionItemEntity> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
      ),
      hint: Text(label),
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: int.tryParse(item.id),
          child: Text(item.name),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildBranchDropdown({
    required String label,
    required String? value,
    required List<FilterOptionItemEntity> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
      ),
      hint: Text(label),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item.id,
          child: Text(item.name),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}