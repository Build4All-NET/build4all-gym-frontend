// PATH: lib/features/admin/trainers/presentation/widgets/trainer_search_filter_bar_widget.dart
// =============================================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<AdminTrainersBloc, AdminTrainersState>(
      builder: (context, state) {
        // Get specialty list from form options if loaded
        List<String> specialties = [];
        if (state is TrainerFormOptionsLoaded) {
          specialties = state.options.specialties;
        } else if (state is TrainersLoaded) {
          // Try to extract from loaded trainers
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
                  decoration: InputDecoration(
                    hintText:  'Search by name or specialty',
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFF757575), size: 20),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: Color(0xFF757575), size: 18),
                      onPressed: () {
                        _controller.clear();
                        context.read<AdminTrainersBloc>()
                            .add(const TrainersSearchChanged(''));
                      },
                    )
                        : null,
                    filled:      true,
                    fillColor:   Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (q) {
                    setState(() {}); // update clear button
                    context.read<AdminTrainersBloc>()
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
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value:       activeSpecialty,
                      isExpanded:  true,
                      hint: const Text('All',
                          style: TextStyle(fontSize: 13,
                              color: Color(0xFF757575))),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All',
                              style: TextStyle(fontSize: 13)),
                        ),
                        ...specialties.map((s) => DropdownMenuItem<String?>(
                          value: s,
                          child: Text(s,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis),
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
