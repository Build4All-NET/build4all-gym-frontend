// =============================================================================
// FILE: recent_queries_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/
// LAYER: Presentation Layer → Reusable Widget
// =============================================================================
//
// PURPOSE
// -------
// Displays the owner's recent AI queries as tappable chips.
//
// The widget is shown on the AI assistant start screen when the backend
// returns previous query history.
//
// Each chip represents one previous query.
//
// Data flow:
//
// API → Repository → UseCase → Bloc → State → Widget
//
// The widget receives:
//
//   List<AiQueryHistoryEntity>
//
// from:
//
//   AiAssistantReady.recentQueries
//
// IMPORTANT
// ---------
// The BLoC does NOT provide List<String>.
//
// Therefore we MUST extract queryText from each entity.
//
// Event dispatched on tap:
//
//   AiHistoryItemTapped
//
// The BLoC then:
//
//   1. Clears old conversation
//   2. Sends query again
//   3. Emits loading state
//   4. Emits answered state
//
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ai_query_history_entity.dart';
import '../bloc/ai_assistant_bloc.dart';

class RecentQueriesWidget extends StatelessWidget {

  // ===========================================================================
  // LIST OF RECENT QUERY ENTITIES
  // ===========================================================================
  final List<AiQueryHistoryEntity> queries;

  const RecentQueriesWidget({
    super.key,
    required this.queries,
  });

  @override
  Widget build(BuildContext context) {

    // =========================================================================
    // HIDE ENTIRE WIDGET IF THERE IS NO HISTORY
    // =========================================================================
    if (queries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // =====================================================================
        // SECTION TITLE
        // =====================================================================
        Text(
          'Recent Queries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 12),

        // =====================================================================
        // RESPONSIVE CHIP LAYOUT
        // =====================================================================
        Wrap(
          spacing: 8,
          runSpacing: 8,

          // ===================================================================
          // CONVERT EVERY QUERY ENTITY INTO A CHIP
          // ===================================================================
          children: queries.map((queryItem) {

            // ================================================================
            // EXTRACT QUERY TEXT FROM ENTITY
            // ================================================================
            final String query = queryItem.queryText;

            return ActionChip(

              // ===============================================================
              // CHIP LABEL
              // ===============================================================
              label: Text(
                query.length > 40
                    ? '${query.substring(0, 40)}…'
                    : query,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),

              // ===============================================================
              // CHIP TAP ACTION
              // ===============================================================
              //
              // Dispatches:
              //
              //   AiHistoryItemTapped
              //
              // Positional constructor:
              //
              //   AiHistoryItemTapped(query)
              //
              // ===============================================================
              onPressed: () {

                context.read<AiAssistantBloc>().add(

                  AiHistoryItemTapped(query),

                );

              },
            );

          }).toList(),
        ),
      ],
    );
  }
}