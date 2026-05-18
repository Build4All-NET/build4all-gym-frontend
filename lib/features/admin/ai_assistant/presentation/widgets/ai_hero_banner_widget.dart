// =============================================================================
// FILE: suggested_questions_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/suggested_questions_widget.dart
// LAYER: Presentation Layer → Widgets
// =============================================================================
// Displays the 5 suggested question chips in a vertical list.
// Shown on the start screen (before the owner types anything).
// Tapping a chip dispatches AiSuggestionTapped to the BLoC.
// =============================================================================
// =============================================================================
// FILE: ai_hero_banner_widget.dart
// =============================================================================
// The purple gradient banner at the top of the AI assistant screen.
// All strings are now localised via AppLocalizations.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class AiHeroBannerWidget extends StatelessWidget {
  const AiHeroBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_outlined,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiHeroBannerTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.aiHeroBannerSubtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.aiHeroBannerBody,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}