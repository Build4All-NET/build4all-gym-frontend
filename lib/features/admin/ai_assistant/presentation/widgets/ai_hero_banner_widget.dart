// =============================================================================
// FILE: ai_hero_banner_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/ai_hero_banner_widget.dart
// LAYER: Presentation Layer → Widgets
// =============================================================================
// The purple gradient banner at the top of the AI assistant screen.
// Shows the feature title, subtitle, and a robot icon.
// Matches the Figma design: "AI Insights Assistant / Ask me anything..."
// =============================================================================

import 'package:flutter/material.dart';

class AiHeroBannerWidget extends StatelessWidget {
  const AiHeroBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Robot / AI icon in a semi-transparent circle
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
          // Text block
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insights Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ask me anything about your gym',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 8),
                Text(
                  'Get instant analytics, insights, and\nrecommendations based on your gym\'s data.',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}