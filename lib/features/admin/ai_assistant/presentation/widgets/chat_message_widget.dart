// =============================================================================
// FILE: chat_message_widget.dart
// PATH: lib/features/owner/ai_assistant/presentation/widgets/
// =============================================================================
// PURPOSE:
// Renders a single chat message bubble.
//
// FEATURES:
// - User messages → right aligned (purple bubble)
// - Assistant messages → left aligned (white bubble + bot icon)
// - Optional stat cards shown under assistant messages
// =============================================================================

import 'package:flutter/material.dart';

import '../../domain/entities/ai_message_entity.dart';
import '../../domain/entities/ai_stat_card_entity.dart';

class ChatMessageWidget extends StatelessWidget {

  // ───────────────────────────────────────────────────────────────────────────
  // REQUIRED DATA
  // ───────────────────────────────────────────────────────────────────────────
  final AiMessageEntity message;

  // Optional stat cards (AI analytics / metrics under assistant reply)
  final List<AiStatCardEntity> statCards;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.statCards = const [],
  });

  // Helper → check if message is from user
  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: _isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // ───────────────────────────────────────────────────────────────
          // BOT AVATAR (ONLY FOR ASSISTANT)
          // ───────────────────────────────────────────────────────────────
          if (!_isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // ───────────────────────────────────────────────────────────────
          // MESSAGE BUBBLE
          // ───────────────────────────────────────────────────────────────
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: _isUser
                    ? const Color(0xFF6C63FF)
                    : Colors.white,

                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(_isUser ? 16 : 4),
                  bottomRight: Radius.circular(_isUser ? 4 : 16),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              // ─────────────────────────────────────────────────────────────
              // CONTENT INSIDE BUBBLE
              // IMPORTANT: MUST USE COLUMN (not multiple children in Container)
              // ─────────────────────────────────────────────────────────────
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ─────────────────────────────────────────────
                  // MESSAGE TEXT
                  // ─────────────────────────────────────────────
                  Text(
                    message.content,
                    style: TextStyle(
                      color: _isUser
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),

                  // ─────────────────────────────────────────────
                  // STAT CARDS (ONLY FOR ASSISTANT)
                  // ─────────────────────────────────────────────
                  if (!_isUser && statCards.isNotEmpty) ...[
                    const SizedBox(height: 10),

                    Column(
                      children: statCards.map((card) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Text(
                            card.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}