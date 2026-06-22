// lib/features/admin/trainers/presentation/widgets/trainer_search_filter_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/admin_trainers_bloc.dart';
import '../bloc/admin_trainers_event.dart';
import '../bloc/admin_trainers_state.dart';

class TrainerSearchFilterBarWidget extends StatefulWidget {
  const TrainerSearchFilterBarWidget({super.key});

  @override
  State<TrainerSearchFilterBarWidget> createState() =>
      _TrainerSearchFilterBarWidgetState();
}

class _TrainerSearchFilterBarWidgetState
    extends State<TrainerSearchFilterBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;

    return BlocBuilder<AdminTrainersBloc, AdminTrainersState>(
      builder: (context, state) {
        List<String> specialties = [];
        if (state is TrainerFormOptionsLoaded) {
          specialties = state.options.specialties;
        } else if (state is TrainersLoaded) {
          specialties = state.trainers
              .expand((t) => t.specialties)
              .toSet()
              .toList()
            ..sort();
        }

        final activeSpecialty =
        state is TrainersLoaded ? state.activeSpecialty : null;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              // ── Search bar (~60% width) ────────────────────────────
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _controller,
                  style: TextStyle(fontSize: 14, color: c.label),
                  decoration: InputDecoration(
                    hintText:  l10n.admin_trainers_searchHint,
                    hintStyle: TextStyle(color: c.muted, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: c.muted, size: 20),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear,
                          color: c.muted, size: 18),
                      onPressed: () {
                        _controller.clear();
                        context
                            .read<AdminTrainersBloc>()
                            .add(const TrainersSearchChanged(''));
                      },
                    )
                        : null,
                    filled:         true,
                    fillColor:      c.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.primary, width: 1.5),
                    ),
                  ),
                  onChanged: (q) {
                    setState(() {}); // update clear button
                    context
                        .read<AdminTrainersBloc>()
                        .add(TrainersSearchChanged(q));
                  },
                ),
              ),

              const SizedBox(width: 8),

              // ── Specialty dropdown (~40% width) ────────────────────
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color:        c.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value:      activeSpecialty,
                      isExpanded: true,
                      hint: Text(
                        l10n.admin_trainers_allSpecialties,
                        style: TextStyle(fontSize: 13, color: c.muted),
                      ),
                      style: TextStyle(fontSize: 13, color: c.label),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.admin_trainers_allSpecialties,
                              style: TextStyle(
                                  fontSize: 13, color: c.label)),
                        ),
                        ...specialties.map((s) => DropdownMenuItem<String?>(
                          value: s,
                          child: Text(
                            s,
                            style: TextStyle(
                                fontSize: 13, color: c.label),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ],
                      onChanged: (value) => context
                          .read<AdminTrainersBloc>()
                          .add(TrainersSpecialtyFilterChanged(value)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}