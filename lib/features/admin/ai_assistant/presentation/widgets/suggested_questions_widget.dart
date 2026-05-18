// =============================================================================
// FILE: suggested_questions_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/suggested_questions_widget.dart
// LAYER: Presentation Layer → Widgets
// =============================================================================
// Displays the 5 suggested question chips in a vertical list.
// Shown on the start screen (before the owner types anything).
// Tapping a chip dispatches AiSuggestionTapped to the BLoC.
// =============================================================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/suggested_question_entity.dart';
import '../bloc/ai_assistant_bloc.dart';

class SuggestedQuestionsWidget extends StatelessWidget {
  final List<SuggestedQuestionEntity> suggestions;

  const SuggestedQuestionsWidget({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiSuggestedQuestionsHeader,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: suggestions.map((s) {
            return _SuggestionChip(question: s.question);
          }).toList(),
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String question;

  const _SuggestionChip({required this.question});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AiAssistantBloc>().add(AiSuggestionTapped(question));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          question,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}